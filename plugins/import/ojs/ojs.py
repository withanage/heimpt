from ImportInterface import Import
from pydal.base import DAL
from ojsdal import *


class OJSImport(Import):
    def __init__(self):
        self.db = DAL('mysql://user:pass@localhost:3306/omp', migrate=False)
        self.dal = OMPDAL(self.db, {})

        # TODO define tables
        # FIXME How to load config?

    def run(self):
        print("Running plugin omp import")
        print self.db.as_dict()
        self.results = {'path': '/tmp/'}
        pass

#plugin = OMPImport()
