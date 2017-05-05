from ImportInterface import Import
from pydal.base import DAL
from ompdal import *


class OMPImport(Import):
    def __init__(self):
        self.db = DAL('mysql://omp-user:omp-password@172.17.0.2:3306/omp', migrate=False)
        self.dal = OMPDAL(self.db, {})
        # TODO define tables
        # FIXME How to load config?

    def run(self):
        print("Running plugin omp import")
        print self.db.as_dict()
        pass

#plugin = OMPImport()
