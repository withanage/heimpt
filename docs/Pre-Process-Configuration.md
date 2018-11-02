##  Monograph Publishing Tool Configuration
* Configuration file is located in [folder](https://github.com/withanage/mpt/blob/master/static/tools/mpt.json)
* MPT can be run  as e.g.  with json file
` python mpt.py mpt.json`
* All the projects are listed in projects as in a json array. 
 * Project properties are listed under project.
   * project -> active parameter activates the project
   * project -> chain parameter defines the ath the output of the previous typesetter is the input for the current typesetter
   * project -> files defines the list of files. They should be a Json object as key/ value pair.
   * project ->  path  defines the input folder of the files defined under  project -> files 
   * project -> name can be  the name of the project.   MPT generates a folder called project -> name  under project ->path  and save the output.
    * 
 * Project typesetters are listed under typesetters
   * Each typesetter has a unique name pro configuration file.
   * typesetters  -> executable defines the executable path of the typesetter or any other application

   * typesetters  -> arguments defines  a certain configuration  of the typesetter for  the current configuration. Same typesetter can be defined using different configurations. 
   


 


    

* All the typesetters are listed in  typesetters.
