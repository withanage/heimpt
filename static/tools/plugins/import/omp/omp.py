# coding=utf-8
"""
Usage:
  heimpt.py import omp [options] [<submission_id>...]

Options:
  -h --help
  -t --project-template=<file>
  -a --all-submissions          Import all submissions of any configured presses
"""
import json
import os.path
import shutil

from ImportInterface import Import
from lxml import etree
from lxml import html
from lxml.builder import E
from pydal.base import DAL

from ompdal import OMPSettings, OMPDAL
from omptables import define_tables

LANG_ATTR = '{http://www.w3.org/XML/1998/namespace}lang'

FILE_STAGE_TO_PATH = {
    2: 'submission',
    10: 'submission/proof',
    11: 'submission/productionReady'
}

USER_GROUP_TO_CONTRIB_TYPE = {
    'Author': 'author',
    'Volume editor': 'editor',
    'Chapter Author': 'author'
}

PUBLICATION_FORMAT_MAPPING = {
    'PDF': 'epdf',
    'Softcover': 'softcover',
    'Hardcover': 'hardcover'
}


def get_omp_filename(submission_file, revision=None, with_extension=True):
    """
    Based on pkp-lib/classes/submission/SubmissionFile.inc.php#_generateFilename
    :param revision: If specified will be used as revision part in filename
    :param submission_file: Row object of submission_file Table
    :return: unique filename according to _generateFilename 
    """
    if not revision:
        revision = submission_file.revision
    date_uploaded = submission_file.date_uploaded.strftime('%Y%m%d')
    original_name, extension = os.path.splitext(submission_file.original_file_name)
    filename = '-'.join([str(submission_file.submission_id), str(submission_file.genre_id),
                         str(submission_file.file_id), str(revision), str(submission_file.file_stage),
                         date_uploaded])
    if with_extension:
        return filename + extension
    else:
        return filename


def path_to_omp_submission_file(submission_file, press_id, files_dir):
    return os.path.join(files_dir, 'presses', str(press_id), 'monographs', str(submission_file.submission_id),
                        FILE_STAGE_TO_PATH[submission_file.file_stage], get_omp_filename(submission_file))


def path_to_submission_output(submission_id, press_id, output_dir):
    return os.path.join(output_dir, 'presses', str(press_id), 'monographs', str(submission_id))


def path_to_submission_metadata(submission_id, press_id, output_dir, filename='mpt.book-meta.bits2.xml'):
    """
    Return the complete path to a metadata file.
    
    :param submission_id: Identifier of the submission
    :param press_id: Identifier of the press
    :param output_dir: Base path to metadata files
    :param filename: Name of the metadata file, defaults to 'mpt.book-meta.bits2.xml'
    :return: 
    """
    return os.path.join(path_to_submission_output(submission_id, press_id, output_dir), 'metadata', filename)


class OMPImport(Import):
    def __init__(self):
        self.db = None
        self.dal = None
        self.settings = {}
        self.results = None
        self.presses = None
        self.module_path = os.path.dirname(os.path.realpath(__file__))

    def initialize(self, args, settings_override=None, settings_path='settings.json'):
        path = os.path.join(self.module_path, settings_path)
        with open(path) as f:
            self.settings = json.load(f)
        if settings_override:
            self.settings.update(settings_override)
        if args.get('--project-template'):
            self.settings['project-template'] = args.get('--project-template')
        print('Loaded settings: {}'.format(self.settings))
        os.chdir(self.settings['base-path'])
        print('Changed working directory to: {}'.format(self.settings['base-path']))
        self.db = DAL(self.settings['db-uri'], migrate=False)
        define_tables(self.db)
        self.dal = OMPDAL(self.db, None)
        self.load_configured_presses()

    def load_configured_presses(self):
        if self.settings['presses']:
            configured_press_paths = set(self.settings['presses'].keys())
            presses_list = self.db(self.db.presses.path.belongs(configured_press_paths)).select(
                self.db.presses.ALL).as_list()
            self.presses = {p['press_id']: p for p in presses_list}
            loaded_press_paths = {p['path'] for p in presses_list}
            if configured_press_paths.difference(loaded_press_paths):
                print('ERROR: Configured presses with paths={} not found in DB'
                      .format(", ".join(configured_press_paths.difference(loaded_press_paths))))
                return False
            for press in self.presses.values():
                press.update(self.settings['presses'][press['path']])
                print('Configured press: {}'.format(press))

        else:
            print('ERROR: No presses configured in settings!')
            return False

    def run(self, args, settings):
        print('Running plugin omp import')
        self.initialize(args, settings)
        if args.get('--all-submissions'):
            print('Importing all submissions for presses: {}'.format(", ".join(p['path'] for p in self.presses.values())))
            rows = self.db(self.db.submissions.context_id.belongs(self.presses.keys())).select(self.db.submissions.submission_id)
            submission_ids = [row.submission_id for row in rows]
        elif args.get('<submission_id>'):
            submission_ids = [int(id_arg) for id_arg in args.get('<submission_id>')]
        else:
            if not isinstance(self.settings['submission'], list):
                submission_ids = [self.settings['submission']]
            else:
                submission_ids = self.settings['submission']
        print('Importing submissions: {}'.format(submission_ids))
        self.results = []
        for submission_id in submission_ids:
            print('Loading submission {}'.format(submission_id))
            submission = self.db.submissions[submission_id]
            print('Querying submission files ...')
            manuscript_genre = self.presses[submission.context_id]['manuscript-genre']
            chapter_genre = self.presses[submission.context_id]['chapter-genre']
            if not self.submission_files_exists(submission) and self.settings['skip-submission-without-files']:
                print('No matching submission or chapter files, skipping import')
                continue
            submission_files = self.get_files_from_db(submission_id, manuscript_genre)
            full_file_path = None
            if not submission_files:
                print('ERROR: No submission file found with genre={genre}, file_stage={file-stage} and file_types={file-types}'
                      .format(genre=manuscript_genre, **self.settings))
            elif len(submission_files) > 1:
                print('WARNING: Found more than one matching manuscript file: {}'
                      .format(', '.join(f.file_id for f in submission_files)))
            else:
                full_file_path = path_to_omp_submission_file(submission_files[0], submission.context_id,
                                                   self.settings['omp-files-dir'])
                print('Found full book file:' + full_file_path)

            print('Loading metadata for submission')
            submission_metadata_path = path_to_submission_metadata(submission.submission_id, submission.context_id,
                                                             self.settings['files-output-dir'])
            book_bits_xml = self.read_submission_metadata(submission_metadata_path)
            # generate metadata for the whole submission first and then for each chapter
            self.inject_submission_metadata(submission, book_bits_xml)
            chapters = self.dal.getChaptersBySubmission(submission_id)
            print('Loading metadata for chapters')
            chapters_metadata_xml = []
            chapter_file_paths = []
            for chapter in chapters:
                chapter_settings = OMPSettings(self.dal.getChapterSettings(chapter.chapter_id))
                chapter_title = unicode(chapter_settings.getLocalizedValue('title', submission.locale), 'utf8')
                print(u'Loading chapter {}, "{}"'.format(chapter.chapter_seq, chapter_title))
                chapter_files = self.get_chapter_files_from_db(chapter.chapter_id, chapter_genre)
                if not chapter_files:
                    print('ERROR: No files found for chapter_id={} and genre={}'
                          .format(chapter.chapter_id, chapter_genre))
                    continue
                elif len(chapter_files) > 1:
                    print('WARNING: Found more than one matching chapter file: {}'
                          .format(', '.join(f.file_id for f in chapter_files)))
                    continue
                else:
                    chapter_file_path = path_to_omp_submission_file(chapter_files[0], submission.context_id,
                                                                    self.settings['omp-files-dir'])
                    chapter_file_paths.append(chapter_file_path)
                    print('Found chapter file: {}'.format(chapter_file_path))
                    chapter_metadata_path = path_to_submission_metadata(submission.submission_id, submission.context_id,
                                                                        self.settings['files-output-dir'],
                                                                        'chapter' + str(chapter.chapter_seq + 1)
                                                                        + self.settings['chapter-metadata-suffix'])
                    chapter_bits_xml = self.read_chapter_metadata(chapter_metadata_path)
                    self.inject_chapter_metadata(chapter_bits_xml, chapter, chapter_settings, submission,
                                                 {"doi": 'doi123', "urn": "urn123"})
                    chapters_metadata_xml.append((chapter_metadata_path, chapter_bits_xml))
            project_files_dir = path_to_submission_output(submission_id, submission.context_id,
                                                          self.settings['files-output-dir'])
            self.copy_submission_files(chapter_file_paths, project_files_dir)
            if full_file_path:
                self.copy_submission_files([full_file_path], project_files_dir)
            print('Writing submission metadata xml to: ' + submission_metadata_path)
            self.write_xml_to_file(book_bits_xml, submission_metadata_path)
            for file_path, chapter_xml in chapters_metadata_xml:
                print('Writing chapter metadata to: ' + file_path)
                self.write_xml_to_file(chapter_xml, file_path)
            project_filename = str(submission_id) + '.json'
            project_config = self.read_project_config(project_filename)
            project = project_config['projects'][0]
            project['name'] = 'omp-' + str(submission_id)
            project['files'] = {str(i): os.path.basename(path) for i, path in enumerate(chapter_file_paths, start=1)}
            if full_file_path:
                project['full_file'] = full_file_path
            project['path'] = project_files_dir
            self.write_project_config(project_filename, project_config)
            self.results.append(project_config)
        pass

    def copy_submission_files(self, file_paths, target_dir):
        if not os.path.exists(target_dir) and file_paths:
            os.makedirs(target_dir)
        for file_path in file_paths:
            print("Copying {} to {} ...".format(file_path, target_dir))
            shutil.copy(file_path, target_dir)

    def write_project_config(self, project_filename, project_config):
        project_file_dir = os.path.join(self.settings['base-path'], self.settings['project-output'])
        if not os.path.exists(project_file_dir):
            os.makedirs(project_file_dir)
        with open(os.path.join(project_file_dir, project_filename), "w") as f:
            json.dump(project_config, f, indent=2, sort_keys=True)

    def read_project_config(self, project_filename, template_path=None):
        project_output_path = os.path.join(self.settings['project-output'], project_filename)
        if os.path.isfile(project_output_path):
            path = project_output_path
        else:
            path = template_path or self.settings['project-template']
        with open(path) as f:
            return json.load(f)

    def submission_files_exists(self, submission):
        file_stage = self.settings['file-stage']
        file_types = self.settings['file-types']
        genres = [self.presses[submission.context_id]['manuscript-genre'],
                  self.presses[submission.context_id]['chapter-genre']]
        sf = self.db.submission_files
        q = ((sf.submission_id == submission.submission_id)
             & (sf.genre_id.belongs(genres))
             & (sf.file_type.belongs(file_types))
             & (sf.file_stage == file_stage)
             )
        return not self.db(q).isempty()

    def get_files_from_db(self, submission_id, genre_id):
        file_stage = self.settings['file-stage']
        file_types = self.settings['file-types']
        sf = self.db.submission_files
        q = ((sf.submission_id == submission_id)
             & (sf.genre_id == genre_id)
             & (sf.file_type.belongs(file_types))
             & (sf.file_stage == file_stage)
             )
        res = self.db(q).select(sf.ALL, orderby=sf.revision)
        return res

    def get_chapter_files_from_db(self, chapter_id, genre_id):
        file_types = self.settings['file-types']
        file_stage = self.settings['file-stage']
        sfs = self.db.submission_file_settings
        sf = self.db.submission_files
        q = ((sfs.setting_name == 'chapterId')
             & (sfs.setting_value == chapter_id)
             & (sfs.file_id == sf.file_id)
             & (sf.file_stage == file_stage)
             & (sf.genre_id == genre_id)
             & (sf.file_type.belongs(file_types))
             )
        res = self.db(q).select(sf.ALL, orderby=sf.revision)
        return res

    def read_submission_metadata(self, metadata_file_path):
        """
        Reads the submission metadata, either from an existing metadata file from a previous import or from a template.
        :param metadata_file_path: Path to bits2 xml file with metadata.
        :return: ElementTree object with bits2 metadata elements.
        """
        print("Try to load submission metadata from: {}".format(metadata_file_path))
        if os.path.isfile(metadata_file_path):
            # load existing metadata
            book_xml = etree.parse(metadata_file_path)
        else:
            # load bits xml skeleton from file
            book_xml = etree.parse(os.path.join(self.module_path, 'templates', 'sample-monograph.bits2.xml'))
        return book_xml

    def write_xml_to_file(self, bits_xml, file_path):
        if not os.path.exists(os.path.dirname(file_path)):
            os.makedirs(os.path.dirname(file_path))
        bits_xml.write(file_path, encoding='utf8', pretty_print=True)

    def inject_submission_metadata(self, submission, book_xml):
        """
        Generate the metadata from omp db for the given submission 

        :param book_xml: ElementTree object with bits2 metadata elements.
        :param submission: submission Row from db
        :return: ElementTree with metadata in BITS2 XML format
        """
        submission_id = submission.submission_id
        locale = submission.locale
        short_locale = locale[:2]
        # Set language of submission on book tag
        book_xml.xpath('/book')[0].set(LANG_ATTR, short_locale)
        book_meta_xml = book_xml.xpath('/book/book-meta')[0]
        book_meta_xpatheval = etree.XPathEvaluator(book_meta_xml)
        submission_settings = OMPSettings(self.dal.getSubmissionSettings(submission_id))
        press_settings = OMPSettings(self.dal.getPressSettings(submission.context_id))
        book_meta_xpatheval('book-id')[0].text = str(submission_id)

        book_title = u'{} {}'.format(unicode(submission_settings.getLocalizedValue('prefix', locale), 'utf8'),
                                    unicode(submission_settings.getLocalizedValue('title', locale), 'utf8'))
        subtitle = unicode(submission_settings.getLocalizedValue('subtitle', locale), 'utf8')
        book_meta_xpatheval('book-title-group/book-title')[0].text = book_title
        book_meta_xpatheval('book-title-group/subtitle')[0].text = subtitle
        # Add abstracts for all languages
        etree.strip_elements(book_meta_xml, 'abstract')
        for biography_locale, abstract_text in submission_settings.getValues('abstract').items():
            if abstract_text:
                abstract_html = html.fragment_fromstring(unicode(abstract_text, 'utf8'), create_parent=True)
                book_meta_xml.append(E.abstract(abstract_html, {LANG_ATTR: biography_locale[:2]}))
        # Inject publisher location and name
        publisher_loc_xml = book_meta_xpatheval('publisher/publisher-loc')[0]
        if press_settings.getLocalizedValue('location', ''):
            publisher_loc_xml.text = press_settings.getLocalizedValue('location', '')
        elif press_settings.getLocalizedValue('mailingAddress', ''):
            # Assume the city of the published is found in the second word in the last line of the address,
            # e.g., 69120 Heidelberg
            publisher_address = press_settings.getLocalizedValue('mailingAddress', '')
            publisher_loc_xml.text = publisher_address.splitlines()[-1].split()[1]
        book_meta_xpatheval('publisher/publisher-name')[0].text = press_settings.getLocalizedValue('name',
                                                                                                   locale)
        # Load isbn identifiers for all formats and doi from pdf
        doi = ''
        for pub_format in self.dal.getAllPublicationFormatsBySubmission(submission_id):
            format_settings = OMPSettings(self.dal.getPublicationFormatSettings(pub_format.publication_format_id))
            format_name = format_settings.getLocalizedValue('name', locale)
            if format_name == 'PDF':
                doi = format_settings.getLocalizedValue('pub-id::doi', '')
            isbn_row = self.dal.getIdentificationCodesByPublicationFormat(pub_format.publication_format_id).first()
            if isbn_row:
                isbn = isbn_row.value
                existing_isbn_nodes = book_meta_xpatheval(
                    'isbn[@publication-format = "{}"]'.format(PUBLICATION_FORMAT_MAPPING[format_name]))
                if existing_isbn_nodes:
                    existing_isbn_nodes[0].text = isbn
                else:
                    book_meta_xml.append(E.isbn(isbn, {'publication-format': PUBLICATION_FORMAT_MAPPING[format_name]}))
        # Add doi identifier
        book_meta_xpatheval('custom-meta-group/custom-meta[meta-name = "doi"]/meta-value')[0].text = doi

        contrib_group_xml = book_meta_xpatheval('contrib-group')[0]
        etree.strip_elements(contrib_group_xml, 'contrib')
        # Add contributors
        for contrib in self.dal.getAuthorsBySubmission(submission_id):
            contrib_group_xml.append(self.build_contrib_xml(contrib, contrib_group_xml, locale))
        book_meta_xpatheval('permissions/copyright-year')[0].text = submission_settings.getLocalizedValue('copyrightYear', '')
        book_meta_xpatheval('permissions/copyright-holder')[0].text = unicode(submission_settings.getLocalizedValue(
            'copyrightHolder', locale), 'utf8')
        # Add collection meta data
        if submission.series_id:
            series_settings = OMPSettings(self.dal.getSeriesSettings(submission.series_id))
            collection_meta_xml = book_xml.xpath('collection-meta')[0]
            series_title = unicode(series_settings.getLocalizedValue('title', locale), 'utf8')
            collection_meta_xml.xpath('title-group/title')[0].text = series_title
            series_subtitle = unicode(series_settings.getLocalizedValue('subtitle', locale), 'utf8')
            collection_meta_xml.xpath('title-group/subtitle')[0].text = series_subtitle
            series_print_issn = series_settings.getLocalizedValue('printIssn', '')
            if series_print_issn:
                collection_meta_xml.append(E.issn(series_print_issn, {'publication-format': 'print'}))
            series_electronic_issn = series_settings.getLocalizedValue('onlineIssn', '')
            if series_electronic_issn:
                collection_meta_xml.append(E.issn(series_print_issn, {'publication-format': 'online'}))
            # TODO series editors
        else:
            etree.strip_elements(book_xml, 'collection-meta')
        # TODO add copyright-statement. which omp field to use or which value to generate?
        # TODO add license
        return book_xml

    def build_contrib_xml(self, contrib, contrib_group_xml, locale):
        contrib_settings = OMPSettings(self.dal.getAuthorSettings(contrib.author_id))
        group_settings = self.dal.getUserGroupSettings(contrib.user_group_id)
        # Use the english name of the group for mapping to contrib-type attribute
        contrib_type = USER_GROUP_TO_CONTRIB_TYPE.get(group_settings.getLocalizedValue('name', 'en_US'))
        contrib_attrs = {'contrib-type': contrib_type} if contrib_type else {}
        given_names = unicode(contrib.first_name, 'utf8')
        if contrib.middle_name:
            given_names += " " + unicode(contrib.middle_name, 'utf8')
        contrib_xml = E.contrib(
            E.name(
                E.surname(unicode(contrib.last_name, 'utf8')),
                getattr(E, 'given-names')(given_names), {'name-style': 'western'}),
            contrib_attrs)
        # Add biography in all available languages
        for biography_locale, biography_text in contrib_settings.getValues('biography').items():
            if biography_text:
                # lxml cant parse html in the biographies if they contain multiple tags as root element.
                # TODO check which html element should be used to encapsulate the html from biographies
                biography_html = html.fragment_fromstring(unicode(biography_text, 'utf8'), create_parent=True)
                contrib_xml.append(getattr(E, 'author-comment')(biography_html, {LANG_ATTR: biography_locale[:2]}))
        affiliation = unicode(contrib_settings.getLocalizedValue('affiliation', locale), 'utf8')
        if affiliation:
            aff_nodes = contrib_group_xml.xpath('aff')
            if aff_nodes:
                # Find an existing aff tag with the same text
                aff_id = next((node.get('id') for node in aff_nodes if node.text == affiliation), None)
                if not aff_id:
                    aff_ids = set(node.get('id') for node in aff_nodes)
                    aff_id = max(aff_ids)
                    # Try to convert last two characters to int and increase
                    try:
                        aff_id = 'aff' + format(int(aff_id[-2:]) + 1, '02d')
                    except ValueError as e:
                        print(e)
                        pass
                    else:
                        aff_id = 'aff' + next(format(number, '02d') for number in range(1, 100)
                                              if 'aff' + format(number, '02d') not in aff_ids)
                    existing_aff = False
                else:
                    existing_aff = True
            else:
                existing_aff = False
                aff_id = 'aff01'
            if not existing_aff:
                contrib_group_xml.append(E.aff(affiliation, {'id': aff_id}))
            contrib_xml.append(E.xref({'ref-type': 'aff', 'rid': aff_id}))
        return contrib_xml

    def inject_chapter_metadata(self, bits_xml, chapter, chapter_settings, submission, custom_meta=None):
        """
        Generates the metadata for the chapter

        :param custom_meta: Dict containing entries which will be added as <custom-meta> tags.
        :param bits_xml: ElementTree object containing bits2 meta-data for a submission chapter.
        :param chapter: Chapter row object.
        :param chapter_settings: OMPSettings object containing the chapter settings
        :param submission: Submission row object, to which the chapter belongs.
        :return: Updated ElementTree object with new metadata from OMP db.
        """
        chapter_no = chapter.chapter_seq + 1
        book_part_xml = bits_xml.xpath('/book-part')[0]
        book_part_xml.set('id', 'b{}_ch_{}'.format(submission.submission_id, chapter_no))
        book_part_xml.set('seq', str(chapter_no))
        book_part_xml.set(LANG_ATTR, submission.locale[:2])
        # TODO How to distinguish other types?
        book_part_xml.set('book-part-type', 'chapter')
        book_part_meta_xml = book_part_xml.xpath('book-part-meta')[0]
        book_part_meta_xml.xpath('title-group/title')[0].text = unicode(chapter_settings.getLocalizedValue(
            'title', submission.locale), 'utf8')
        contrib_group_xml = book_part_meta_xml.xpath('contrib-group')[0]
        for contrib in self.dal.getAuthorsByChapter(chapter.chapter_id):
            contrib_group_xml.append(self.build_contrib_xml(contrib, contrib_group_xml, submission.locale))
        if custom_meta:
            custom_meta_group_xml = book_part_meta_xml.xpath('custom-meta-group')[0]
            # Clear old custom-meta tags
            etree.strip_elements(custom_meta_group_xml, 'custom-meta')
            for meta_name, meta_value in custom_meta.items():
                custom_meta_xml = etree.SubElement(custom_meta_group_xml, 'custom-meta', {'specific-use': meta_name})
                etree.SubElement(custom_meta_xml, 'meta-name').text = meta_name
                etree.SubElement(custom_meta_xml, 'meta-value').text = meta_value
        return bits_xml

    def read_chapter_metadata(self, metadata_file_path):
        print("Try to load chapter metadata from: {}".format(metadata_file_path))
        if os.path.isfile(metadata_file_path):
            bits_xml = etree.parse(metadata_file_path)
        else:
            # load bits xml skeleton from file
            bits_xml = etree.parse(os.path.join(self.module_path, 'templates', 'sample-chapter.bits2.xml'))
        return bits_xml
