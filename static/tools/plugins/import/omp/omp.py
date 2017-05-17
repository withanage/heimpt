from ImportInterface import Import
from pydal.base import DAL
from omptables import define_tables
import json
import os.path

FILE_STAGE_TO_PATH = {
    2: 'submission',
    10: 'submission/proof'
}


def get_omp_filename(submission_file):
    """
    Based on pkp-lib/classes/submission/SubmissionFile.inc.php#_generateFilename
    :param submission_file: Row object of submission_file Table
    :return: unique filename according to _generateFilename 
    """
    date_uploaded = submission_file.date_uploaded.strftime('%Y%m%d')
    original_name, extension = os.path.splitext(submission_file.original_file_name)
    filename = '-'.join([str(submission_file.submission_id), str(submission_file.genre_id),
                         str(submission_file.file_id), str(submission_file.revision), str(submission_file.file_stage),
                         date_uploaded])
    return filename + extension


class OMPImport(Import):
    def __init__(self):
        self.db = None
        self.dal = None
        self.settings = {}
        self.results = None

    def initialize(self, settings_override=None, settings_path='settings.json'):
        path = os.path.join(os.path.dirname(os.path.realpath(__file__)), settings_path)
        with open(path) as f:
            self.settings = json.load(f)
        if settings_override:
            self.settings.update(settings_override)
        print('Loaded settings: {}'.format(self.settings))
        self.db = DAL(self.settings['db-uri'], migrate=False)
        define_tables(self.db)

    def run(self, settings=None):
        print('Running plugin omp import')
        self.initialize(settings)
        self.get_files(self.settings['submission'])
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
        file_paths = []
        for submission_file in res:
            path = self.get_path_to_submission_file(submission_file)
            print "Importing", path
            if os.path.exists(path):
                print "Found submission file:", path
                file_paths.append(path)
        return file_paths

    def get_path_to_submission_file(self, submission_file):
        return os.path.join(self.settings['files-dir'], 'presses', str(self.settings['press']),
                            'monographs', str(submission_file.submission_id),
                            FILE_STAGE_TO_PATH[submission_file.file_stage],
                            get_omp_filename(submission_file))
