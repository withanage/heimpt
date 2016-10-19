# -*- coding: utf-8 -*-
# Copyright 13-October-2016, 14:51:07
#
# Author    : Dulip Withanage , University of Heidelberg


import os, json, sys
from debug import Debuggable, Debug
from docopt import docopt
from subprocess import Popen, PIPE
from attrdict import AttrDict
from numpy.ctypeslib import ct

class PreProcess(Debuggable):
    """ converts  source files into xml using the typesetter module"""
    
    def __init__(self):
        self.args = self.read_command_line()
        self.debug = Debug()
        Debuggable.__init__(self, 'Main')
        
        if self.args.get('--debug'):
            self.debug.enable_debug()
            
    def run(self):
        self.config = self.read_json(self.args['<config_file>'])
        self.typeset()
        return        
    
    @staticmethod
    def read_command_line():
        doc="""
        Usage: 
            preProcess.py  <config_file> [options] 
            preProcess.py (-h | --help | --version)
        Options:
            -h, --help  Show this screen and exit.
            -d, --debug Enable debug
            """ 
        return docopt(doc, version='mpt 0.1')
    
    @staticmethod
    def fatal_error(module, message):
        print(u'[FATAL ERROR] [{0}] {1}'.format(module.get_module_name(), message))
        sys.exit(1)

    
    def read_json(self, f):
        if os.path.isfile(f): 
            with open(f) as j:
                return AttrDict(json.load(j))
        else:
            self.debug.print_debug(self, u'Metadata file wasn\'t specified')
            sys.exit(1)    


    def tpyeset_project(self, project):
        ''' runs typesetter for  a project '''
        if project.get('active'):
            ts = project.get('typesetter')
            if ts:   
                mt = [""]
                tss = self.config.get('typesetters')
                if tss:
                    ct = tss.get(ts)
                    if ct:
                        print ct
                        mt=[ct.get('path')] if ct.get('path') else self.debug.print_debug(self, u'typesetter path is not specified')
                        mt.append(project.get("type")) if project.get("type") else  self.debug.print_debug(self, u'typesetter type is not specified')
                        fs  = project.get('files')
                        for f in fs:
                            print f
                            #process = Popen(["python", ' '.join(mt)], stdout=PIPE)
                            #output, err = process.communicate()
                            #exit_code = process.wait()
                            #return output, err, exit_code
                        
                             
                        
                    else:
                        self.debug.print_debug(self, u'typesetter is not available')
                 
                else:
                    self.debug.print_debug(self, u'typesetter varaible is not specified')
            else:
                self.debug.print_debug(self, u'No typesetter is specified')
        else:
            self.debug.print_debug(self, u'project is not active')

    def typeset(self):
        projects = self.config.get('projects')
        if projects:
            for p in projects :
                output, err, exit_code = self.tpyeset_project(p)
                   
        else:
            self.debug.print_debug(self, u'No projects were specified')        
        
        
        
def main():
    print 10*'-'
    pre_process_instance = PreProcess()
    pre_process_instance.run()


if __name__ == '__main__':
    main()
      

