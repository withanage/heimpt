from ImportInterface import Import
from pydal.base import DAL
from omptables import define_tables
import json
import os.path
from lxml import etree
from lxml.builder import E
from ompdal import OMPSettings, OMPDAL

LANG_ATTR = '{http://www.w3.org/XML/1998/namespace}lang'

FILE_STAGE_TO_PATH = {
    2: 'submission',
    10: 'submission/proof'
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
        files = self.get_files(self.settings['submission'])
        file_paths = []
        for submission_file in files:
            print self.load_metadata(submission_file)
            path = self.path_of_submission_file(submission_file)
            print "Importing", path
            if os.path.exists(path):
                print "Found submission file:", path
                file_paths.append(path)

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

    def path_of_submission_file(self, submission_file):
        return os.path.join(self.settings['files-dir'], 'presses', str(self.settings['press']),
                            'monographs', str(submission_file.submission_id),
                            FILE_STAGE_TO_PATH[submission_file.file_stage],
                            get_omp_filename(submission_file))

    def load_metadata(self, submission_file):
        submission_id = submission_file.submission_id
        submission = self.db.submissions[submission_id]
        filename = get_omp_filename(submission_file, revision=1, with_extension=False) + '.bits.xml'
        metadata_file_path = os.path.join(self.settings['metadata-dir'], 'presses', str(submission.context_id),
                                          'monographs', str(submission_id), filename)
        if os.path.isfile(metadata_file_path):
            bits_xml = etree.parse(metadata_file_path)
        else:
            # build empty bits xml
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
        for format in self.dal.getAllPublicationFormatsBySubmission(submission_id):
            format_settings = OMPSettings(self.dal.getPublicationFormatSettings(format.publication_format_id))
            format_name = format_settings.getLocalizedValue('name', submission.locale)
            isbn = self.dal.getIdentificationCodesByPublicationFormat(format.publication_format_id).first().value
            print isbn
            book_meta_xml.append(E.isbn(isbn, {'publication-format': PUBLICATION_FORMAT_MAPPING[format_name]}))

        print etree.tostring(bits_xml, pretty_print=True)
        print metadata_file_path

        # load metadata for submission from omp db
        # update the xml file with the metadata from omp db

