# Monograph Publishing Tool

Monograph Publication Tool (MPT) is a stand-alone platform, as well as a plug-in application for OMP. Developed by University of Heidelberg staff in cooperation with external partners, it enables a high degree of automation in the digital publication process. Dulip Withanage of the University of Heidelberg Library supervises MPTs technical development.

The platform consists of three modules: (1) meTypeset, (2) a WYSIWYG editor,and (3) an output generation engine.


(1) To covert from a Microsoft Word .docx format to NLM/JATS-XML for scholarly/scientific article typesetting, we utilize meTypeset, which Dulip Withanage developed in collaboration with Dr. Martin Eve and the Public Knowledge Project (PKP). meTypeset is an extension/wrapper of OxGarage and uses TEI as an intermediary format to facilitate interchange. meTypeset allows for intelligent size processing of input documents and section grouping algorithms. It automatically detects figure and table lists, footnotes, heading structure, bibliographies, and metadata.

 (2)  The WYSIWYG editor, provides an interactive interface to confirm the information detected by meTypeset and to generate a suitable layout for the desired output format. The editor is written in both HTML and JavaScript, and handles data in XML format, so that each monograph is efficiently standardized and can be re-used. The editor is designed in a WYSIWYG (what you see is what you get) format that enables users to work with both text and images as they envision them.

(3) XML documents are converted to desired output formats that can then be offered to users, including HTML, PDF, and ePub. This step is accomplished with the help of an open source tool, Apache FOP (Formatting Objects Processor).

#Software Development
Dulip Withanage,  Heidelberg  University Library
Katharina Wäschle, Heidelberg  University Library 
