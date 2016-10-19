# -*- coding: utf-8 -*-
# Copyright 13-October-2016, 14:51:07
#
# Author    : Dulip Withanage , University of Heidelberg


import os, collections, json, sys, uuid
from debug import Debuggable, Debug
from docopt import docopt
from subprocess import Popen, PIPE
from attrdict import AttrDict
from numpy.ctypeslib import ct

class PreProcess(Debuggable):
    """ converts  source files into xml using the typesetter module"""
    
    def __init__(self):
        self.args = self.read_command_line()
        print self.args
        self.debug = Debug()
        Debuggable.__init__(self, 'Main')
        
        if self.args.get('--debug'):
            self.debug.enable_debug()
            
    def run(self):
        self.config = self.read_json(self.args['<config_file>'])
        self.typeset_projects()
        return        
    
    @staticmethod
    def read_command_line():
        doc="""
        preProcess: 
        Usage: 
             preProcess.py  <config_file> [--debug]
           
        Options:
          --debug   enable debug.
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





    def typeset_run(self, mt):
        m =  ' '.join(mt).strip().split(' ')
        print m
        process = Popen(m, stdout=PIPE)
        output, err = process.communicate()
        exit_code = process.wait()
        print output
        print err
        print exit_code
        return output, err, exit_code

    def typeset_file(self, project, mt, od_fs, f):
        if project.get('path'):
            output, err, exit_code = self.typeset_run(mt)
        else:
            self.debug.print_debug(self, u'project folder not specified')

    def typeset_files(self, project, ct):
       
        fs = project.get('files')
        od_fs = collections.OrderedDict(sorted(fs.items()))
        for f in od_fs:
            mt = [ct.get('language')] if ct.get('language') else self.debug.print_debug(self, u'typesetter language is not specified')
            if os.path.isfile(ct.get('path')):
                mt.append(ct.get('path')) if ct.get('path') else self.debug.print_debug(self, u'typesetter path is not specified')
                mt.append(project.get("type")) if project.get("type") else self.debug.print_debug(self, u'typesetter type is not specified')
                #mt.append(project.get("output")) if project.get("output") else self.debug.print_debug(self, u'typesetter type is not specified')
                mt.append(os.path.join(project.get('path'),od_fs[f]))
                mt.append(os.path.join(project.get('path'), str(uuid.uuid4())))
                self.typeset_file(project, mt, od_fs, f)
            else:
                self.debug.print_debug(self, u'typesetter binary is not innstalled')
                  

    def tpyeset_project(self, project):
        ''' runs typesetter for  a project '''
        if project.get('active'):
            ts = project.get('typesetter')
            if ts:   
                tss = self.config.get('typesetters')
                if tss:
                    ct = tss.get(ts)
                    if ct:
                        self.typeset_files(project, ct)
                             
                        
                    else:
                        self.debug.print_debug(self, u'typesetter is not available')
                 
                else:
                    self.debug.print_debug(self, u'typesetter varaible is not specified')
            else:
                self.debug.print_debug(self, u'No typesetter is specified')
        else:
            self.debug.print_debug(self, u'project is not active')

    def typeset_projects(self):
        projects = self.config.get('projects')
        if projects:
            for p in projects :
                self.tpyeset_project(p)
                   
        else:
            self.debug.print_debug(self, u'No projects were specified')        
        
        
        
def main():
    print 10*'-'
    pre_process_instance = PreProcess()
    pre_process_instance.run()


if __name__ == '__main__':
    main()
      

