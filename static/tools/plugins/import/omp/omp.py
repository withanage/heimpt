# coding=utf-8
from ImportInterface import Import
from pydal.base import DAL
from omptables import define_tables
import json
import os.path
from lxml import etree
from lxml import html
from lxml.builder import E
from ompdal import OMPSettings, OMPDAL

LANG_ATTR = '{http://www.w3.org/XML/1998/namespace}lang'

FILE_STAGE_TO_PATH = {
    2: 'submission',
    10: 'submission/proof'
}

USER_GROUP_TO_CONTRIB_TYPE = {
    'Author': 'author'
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


def path_to_submission_file(submission_file, press_id, files_dir):
    return os.path.join(files_dir, 'presses', str(press_id), 'monographs', str(submission_file.submission_id),
                        FILE_STAGE_TO_PATH[submission_file.file_stage], get_omp_filename(submission_file))


def path_to_submission_metadata(submission_id, press_id, metadata_dir, filename='mpt.book-meta.bits2.xml'):
    """
    Return the complete path to a metadata file.
    
    :param submission_id: Identifier of the submission
    :param press_id: Identifier of the press
    :param metadata_dir: Base path to metadata files
    :param filename: Name of the metadata file, defaults to 'mpt.book-meta.bits2.xml'
    :return: 
    """
    return os.path.join(metadata_dir, 'presses', str(press_id), 'monographs', str(submission_id), 'metadata', filename)


class OMPImport(Import):
    def __init__(self):
        self.db = None
        self.dal = None
        self.settings = {}
        self.results = None
        self.module_path = os.path.dirname(os.path.realpath(__file__))

    def initialize(self, settings_override=None, settings_path='settings.json'):
        path = os.path.join(self.module_path, settings_path)
        with open(path) as f:
            self.settings = json.load(f)
        if settings_override:
            self.settings.update(settings_override)
        print('Loaded settings: {}'.format(self.settings))
        self.db = DAL(self.settings['db-uri'], migrate=False)
        define_tables(self.db)
        self.dal = OMPDAL(self.db, None)

    def run(self, settings=None):
        print('Running plugin omp import')
        self.initialize(settings)
        submission_id = self.settings['submission']
        print "Loading submission files"
        files = self.get_files(submission_id)
        if not files:
            print("No files found with genre={genre} and file_stage={file-stage}".format(**self.settings))
            return
        print "Loading metadata for submission"
        submission = self.db.submissions[submission_id]
        # generate metadata for the whole submission first and then for each chapter
        self.generate_metadata_for_submission(submission)
        file_paths = []
        for submission_file in files:
            path = path_to_submission_file(submission_file, submission.context_id, self.settings['files-dir'])
            if os.path.exists(path):
                print "Found submission file:", path
                file_paths.append(path)
                print "Importing", path


        self.results = {'path': '/tmp/'}
        # TODO Load project configuration template from file
        # TODO extend project configuration with path to imported submission file
        # TODO Import meta data form omp db
        # TODO write meta data as xml to file
        # TODO add path of meta data file to project configuration
        # TODO write configuration to output directory
        pass

    def get_files(self, submission_id):
        genre_id = self.settings['genre']
        file_stage = self.settings['file-stage']
        sf = self.db.submission_files
        q = ((sf.submission_id == submission_id)
             & (sf.genre_id == genre_id)
             & (sf.file_stage == file_stage)
             )
        res = self.db(q).select(sf.ALL, orderby=sf.revision)
        return res

    def generate_metadata_for_submission(self, submission, write_file=False):
        """
        Generate the metadata from omp db for the given submission 

        :param submission: submission Row from db
        :return: ElementTree with metadata in BITS2 XML format
        """
        submission_id = submission.submission_id
        metadata_file_path = path_to_submission_metadata(submission.submission_id, submission.context_id,
                                                         self.settings['output-dir'])
        if os.path.isfile(metadata_file_path):
            # load existing metadata
            bits_xml = etree.parse(metadata_file_path)
        else:
            # load bits xml skeleton from file
            bits_xml = etree.parse(os.path.join(self.module_path, 'templates', 'sample-monograph.bits.xml'))
        locale = submission.locale
        short_locale = locale[:2]
        # Set language of submission on book tag
        bits_xml.xpath('/book')[0].set(LANG_ATTR, short_locale)
        book_meta_xml = bits_xml.xpath('/book/book-meta')[0]
        self.db.submission_settings(submission_id=submission_id)
        submission_settings = OMPSettings(self.dal.getSubmissionSettings(submission_id))
        press_settings = OMPSettings(self.dal.getPressSettings(submission.context_id))
        book_meta_xml.xpath('book-id')[0].text = unicode(submission_id)

        book_title = unicode(submission_settings.getLocalizedValue('prefix', locale)) + \
                     " " + unicode(submission_settings.getLocalizedValue('title', locale))
        subtitle = unicode(submission_settings.getLocalizedValue('subtitle', locale))
        book_meta_xml.xpath('book-title-group/book-title')[0].text = book_title
        book_meta_xml.xpath('book-title-group/subtitle')[0].text = subtitle

        # Add abstracts for all languages
        etree.strip_elements(book_meta_xml, 'abstract')
        for lang, abstract_text in submission_settings.getValues('abstract').items():
            if abstract_text:
                book_meta_xml.append(E.abstract(etree.XML(abstract_text), {LANG_ATTR: lang}))
        # TODO Where to find publisher location?
        book_meta_xml.xpath('publisher/publisher-loc')[0].text = ''
        book_meta_xml.xpath('publisher/publisher-name')[0].text = press_settings.getLocalizedValue('name',
                                                                                                   locale)
        # Load isbn identifiers for all formats and doi from pdf
        etree.strip_elements(book_meta_xml, 'isbn')
        doi = ''
        for pub_format in self.dal.getAllPublicationFormatsBySubmission(submission_id):
            format_settings = OMPSettings(self.dal.getPublicationFormatSettings(pub_format.publication_format_id))
            format_name = format_settings.getLocalizedValue('name', locale)
            if format_name == 'PDF':
                doi = format_settings.getLocalizedValue('pub-id::doi', '')
            isbn = self.dal.getIdentificationCodesByPublicationFormat(pub_format.publication_format_id).first().value
            book_meta_xml.append(E.isbn(isbn, {'publication-format': PUBLICATION_FORMAT_MAPPING[format_name]}))
        # Add doi identifier
        book_meta_xml.xpath('custom-meta-group/custom-meta[meta-name = "doi"]/meta-value')[0].text = doi

        contrib_group_xml = book_meta_xml.xpath('contrib-group')[0]
        etree.strip_elements(contrib_group_xml, 'contrib')
        affiliation_counter = 0
        # Add contributors
        for contrib in self.dal.getAuthorsBySubmission(submission_id, filter_browse=True):
            contrib_settings = OMPSettings(self.dal.getAuthorSettings(contrib.author_id))
            group_settings = self.dal.getUserGroupSettings(contrib.user_group_id)
            # Use the english name of the group for mapping to contrib-type attribute
            contrib_type = USER_GROUP_TO_CONTRIB_TYPE[group_settings.getLocalizedValue('name', 'en_US')]
            given_names = contrib.first_name
            if contrib.middle_name:
                given_names += " " + contrib.middle_name
            contrib_xml = E.contrib(E.name(
                E.surname(contrib.last_name), getattr(E, 'given-names')(given_names), {'name-style': 'western'}),
                {'contrib-type': contrib_type})
            # Add biography in all available languages
            for lang, biography_text in contrib_settings.getValues('biography').items():
                if biography_text:
                    # lxml cant parse html in the biographies if they contain multiple tags as root element.
                    # TODO check which html element should be used to encapsulate the html from biographies
                    biography_html = html.fragment_fromstring(biography_text, create_parent=True)
                    contrib_xml.append(getattr(E, 'author-comment')(biography_html, {LANG_ATTR: lang[:2]}))
            # Somehow there was a bug with german umlauts, so we have to use unicode string
            affiliation = unicode(contrib_settings.getLocalizedValue('affiliation', locale), 'utf8')
            if affiliation:
                affiliation_id = 'aff' + format(affiliation_counter, '02d')
                contrib_xml.append(E.xref({'ref-type': 'aff', 'rid': affiliation_id}))
                print 'affiliation', type(affiliation), 'id', affiliation_id
                contrib_group_xml.append(E.aff(affiliation, {'id': affiliation_id}))
            contrib_group_xml.append(contrib_xml)
        book_meta_xml.xpath('permissions/copyright-year')[0].text = submission_settings.getLocalizedValue('copyrightYear', '')
        book_meta_xml.xpath('permissions/copyright-holder')[0].text = submission_settings.getLocalizedValue(
            'copyrightHolder', locale)
        # TODO add copyright-statement. which omp field to use or which value to generate?
        # TODO add license
        print etree.tostring(bits_xml, pretty_print=True)
        print metadata_file_path
        return bits_xml

    def load_metadata_of_chapter(self, submission_file):
        """
        Loads the metadata for the associated submission of a submission_file 
        
        :param submission_file: 
        :return: ElementTree with metadata in BITS format
        """
        submission = self.db.submissions[submission_id]
        metadata_file_path = path_to_submission_metadata(submission_id, submission.context_id,
                                                         self.settings['output-dir'])
        if os.path.isfile(metadata_file_path):
            bits_xml = etree.parse(metadata_file_path)
        else:
            # load bits xml skeleton from file
            bits_xml = etree.parse(os.path.join(self.module_path, 'templates', 'sample-monograph.bits.xml'))
        book_meta_xml = bits_xml.xpath('/book/book-meta')[0]
        self.db.submission_settings(submission_id=submission_id)
        submission_settings = OMPSettings(self.dal.getSubmissionSettings(submission_id))
        press_settings = OMPSettings(self.dal.getPressSettings(submission.context_id))
        book_meta_xml.xpath('book-id')[0].text = unicode(submission_id)

        book_title = unicode(submission_settings.getLocalizedValue('prefix', submission.locale)) + \
                     " " + unicode(submission_settings.getLocalizedValue('title', submission.locale))
        subtitle = unicode(submission_settings.getLocalizedValue('subtitle', submission.locale))
        book_meta_xml.xpath('book-title-group/book-title')[0].text = book_title
        book_meta_xml.xpath('book-title-group/subtitle')[0].text = subtitle

        # Add abstracts for all languages
        etree.strip_elements(book_meta_xml, 'abstract')
        for lang, abstract_text in submission_settings.getValues('abstract').items():
            if abstract_text:
                book_meta_xml.append(E.abstract(etree.XML(abstract_text), {LANG_ATTR: lang}))
        # TODO Where to find publisher location?
        book_meta_xml.xpath('publisher/publisher-loc')[0].text = ''
        book_meta_xml.xpath('publisher/publisher-name')[0].text = press_settings.getLocalizedValue('name', submission.locale)
        # Add isbn identifiers for all formats
        etree.strip_elements(book_meta_xml, 'isbn')
        for pub_format in self.dal.getAllPublicationFormatsBySubmission(submission_id):
            format_settings = OMPSettings(self.dal.getPublicationFormatSettings(pub_format.publication_format_id))
            format_name = format_settings.getLocalizedValue('name', submission.locale)
            isbn = self.dal.getIdentificationCodesByPublicationFormat(pub_format.publication_format_id).first().value
            print isbn
            book_meta_xml.append(E.isbn(isbn, {'publication-format': PUBLICATION_FORMAT_MAPPING[format_name]}))

        print etree.tostring(bits_xml, pretty_print=True)
        print metadata_file_path

        return bits_xml
        # load metadata for submission from omp db
        # update the xml file with the metadata from omp db
