# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <codecell>

# Copyright 13-October-2016, 14:51:07
#
# Author    : Dulip Withanage , University of Heidelberg


import json, sys
from debug import Debuggable
from docopt import docopt


class PreProcess(Debuggable):
    """ converts  source files into xml using the typsetter module"""
    
    def __init__(self):
        self.args = self.read_command_line()
        self.debug = Debug()
        Debuggable.__init__(self, 'Main')
        
        if self.args['--debug']:
            self.debug.enable_debug()
        
        if self.args['--config']:
            with open(self.args['--config']) as j:
                self.config = json.load(j)
        else:
             self.debug.print_debug(self, u'Metadata file wasn\'t specified')
             sys.exit(1)
        
        
    
    @staticmethod
    def read_command_line():
        doc="""Usage: preProcess.py [CONFIG] 
            preProcess.py (--doctest | --testsuite=DIR)
            """ 
        return docopt(doc, version='mpt 0.1')
    
    def run(self):
        return
            
        
def main():
    pre_process_instance = PreProcess()
    pre_process_instance.run()


if __name__ == '__main__':
    main()
      
        

# <codecell>


