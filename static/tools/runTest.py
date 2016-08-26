#!/usr/bin/python

import sys
import os
import logging
import ConfigParser
import getopt
from lxml import etree

logging.basicConfig(level=logging.INFO)


class Pipeline:

    def __init__(self, base_dir, test_collection, test_name, cit=False):
        self.base_dir = base_dir
        self.test_collection = test_collection
        self.test_name = test_name

        self.doc_path = os.path.join(
            self.base_dir,
            "static",
            "tests",
            self.test_collection,
            "src",
            "docx",
            "")
        self.doc_fn = self.doc_path + self.test_name + ".docx"

        self.xml_path = os.path.join(
            self.base_dir,
            "static",
            "tests",
            self.test_collection,
            "src",
            "xml",
            self.test_name)
        self.xml_fn = self.xml_path + ".xml"

        self.cit = cit
        if cit:
            self.xml_cit_fn = self.xml_path + ".cit.xml"

        self.fo_fn = os.path.join(
            self.base_dir,
            "static",
            "tests",
            self.test_collection,
            "src",
            "fo",
            self.test_name +
            ".fo")
        self.html_fn = os.path.join(
            self.base_dir,
            "static",
            "tests",
            self.test_collection,
            "src",
            "html",
            self.test_name +
            ".html")

        self.pdf_path = os.path.join(
            self.base_dir,
            "static",
            "tests",
            self.test_collection,
            "pdf",
            "")

    def validate_paths(self):
        if not os.path.isdir(self.doc_path):
            logging.error(self.doc_path)
            return False
        if not os.path.isdir(self.pdf_path):
            logging.error(self.pdf_path)
            return False

        return True

    def doc2xml(self):
        logging.info("DOCX -> XML")

        cmd = []
        # Call meTypeset
        cmd.append(" ".join([os.path.join(self.base_dir,
                                          "static/tools/meTypeset/bin/meTypeset.py"),
                             "docx",
                             self.doc_fn,
                             self.xml_path]))
        # Move output to XML dir
        cmd.append(
            " ".join(["mv", os.path.join(self.xml_path, "nlm", "out.xml"), self.xml_fn]))
        # Clean output dir
        cmd.append(" ".join(["rm", "-r", self.xml_path]))

        # Execute commands
        for c in cmd:
            logging.info(c)
            os.system(c)

        logging.info("... done")

    def xml2cit(self, xsl_fn):
        logging.info("XML -> XML (format citations)")

        # Load stylesheet
        xsl = etree.parse(xsl_fn)
        transformer = etree.XSLT(xsl)

        # Transform XML
        xml = etree.parse(self.xml_fn)
        xml_cit = transformer(xml)

        logging.info("... done")

        # Save XML with formatted citations
        logging.info("Writing to %s" % self.xml_cit_fn)
        xml_cit.write(self.xml_cit_fn, encoding="utf-8")

    def xml2fo(self, xsl_fn):
        logging.info("XML -> FO")

        # Load stylesheet
        try:
            xsl = etree.parse(xsl_fn)
        except:
            logging.error("xsl_fn %s does not exist" % xsl_fn)

        transformer = etree.XSLT(xsl)

        # |  - extensions: a dict mapping ``(namespace, name)`` pairs to
        # extension functions or extension elements
        #(http://www.antennahouse.com/names/XSL/Extensions)

        # Transform XML
        xml = etree.parse(self.xml_fn)
        if self.cit:
            xml = etree.parse(self.xml_cit_fn)
        fo = transformer(xml)

        logging.info("... done")

        # Save FO
        logging.info("Writing to %s" % self.fo_fn)
        fo.write(self.fo_fn, encoding="utf-8")

    def xml2html(self, xsl_fn):
        logging.info("XML -> HTML")

        # Load stylesheet
        xsl = etree.parse(xsl_fn)
        transformer = etree.XSLT(xsl)

        # Transform XML
        xml = etree.parse(self.xml_fn)
        if self.cit:
            xml = etree.parse(self.xml_cit_fn)
        html = transformer(xml)

        logging.info("... done")

        # Save HTML
        logging.info("Writing to %s" % self.html_fn)
        html.write(self.html_fn, encoding="utf-8")

    def pdf(self, tool, path, css_fn):
        out = self.pdf_path + self.test_name + "." + tool + ".pdf"

        if tool == "mpdf":
            cmd = " ".join(["php",
                            path,
                            "--css",
                            css_fn,
                            "--html",
                            self.html_fn,
                            "-o",
                            self.pdf_path + self.test_name + "." + "mpdf" + ".pdf"])
        elif tool == "prince":
            cmd = " ".join([path, self.html_fn, "-s", css_fn, "-o",
                            self.pdf_path + self.test_name + "." + "prince" + ".pdf"])
        elif tool == "fop":
            cmd = " ".join([path, self.fo_fn, self.pdf_path +
                            self.test_name + "." + "fop" + ".pdf"])
        elif tool == "ahf":
            cmd = " ".join([path, "-d", self.fo_fn, "-o",
                            self.pdf_path + self.test_name + "." + "ahf" + ".pdf"])
        else:
            sys.stderr.write(
                "Unknown tool %s\n Tool options are 'mpdf', 'prince', 'fop' and 'ahf'.\n" %
                tool)
            sys.exit()

        logging.info(cmd)
        os.system(cmd)


def usage():
    sys.stderr.write("./test.py -c config\n")


def runTest(base_dir, test_collection, test_name, cit,
            cfg, cfg_fn, css, start, xslt_fo, xslt_html):
  # Run pipeline
    P = Pipeline(base_dir, test_collection, test_name, cit)

    if P.validate_paths() == False:
        logging.error("Invalid file paths specified in %s" % cfg_fn)
        exit(1)

    if start == "1":
        if os.path.isfile(P.doc_fn):
            # Step 1: DOCX to XML
            P.doc2xml()
        else:
            logging.error("DOCX file %s not found" % P.doc_fn)
            exit(1)

    if start == "1" or start == "2":
        if cit:
            P.xml2cit(cit)
        if os.path.isfile(P.xml_fn):
            # Step 2: XML to FO/HTML
            P.xml2fo(xslt_fo)
            P.xml2html(xslt_html)
        else:
            logging.error("XML file %s not found" % P.xml_fn)
            exit(1)

    if os.path.isfile(P.fo_fn):
        # Step 3: FO to PDF
        for tool, path in cfg.items("fo_tools"):
            P.pdf(tool, path, css)
    else:
        logging.error("FO file %s not found" % (P.fo_fn))

    if os.path.isfile(P.html_fn):
        # Step 3: HTML to PDF
        for tool, path in cfg.items("html_tools"):
            P.pdf(tool, path, css)
    else:
        logging.error("HTML file %s not found" % (P.html_fn))


def main():
    # Process config and command line options
    options, rest = getopt.getopt(sys.argv[1:], "c:", ["config="])

    cfg_fn = ""
    for opt, arg in options:
        if opt in ("-c", "--config"):
            cfg_fn = arg
        else:
            sys.stderr.write("Unknown option %s" % opt)
            exit(1)

    if not cfg_fn:
        usage()
        exit(1)

    if not(os.path.isfile(cfg_fn)):
        sys.stderr.write("Config file %s not found" % cfg_fn)
        exit(1)

    cfg = ConfigParser.ConfigParser()
    cfg.read(cfg_fn)

    base_dir = cfg.get("general", "base_dir")
    test_collection = cfg.get("general", "test_collection")
    xslt_html = cfg.get("stylesheets", "xslt_html")
    xslt_fo = cfg.get("stylesheets", "xslt_fo")
    css = cfg.get("stylesheets", "css")
    try:
        cit = cfg.get("stylesheets", "xslt_cit")
    except ConfigParser.NoOptionError:
        cit = None

    test_name = cfg.get("general", "test_name")
    print test_name
    start = cfg.get("pipeline", "start")
    if not start in ["1", "2", "3"]:
        logging.error(
            "Invalid value %s for start. Allowed values are 1, 2 or 3." %
            start)
        exit(1)
    test_name = cfg.get("general", "test_name")
    for i in test_name.split(','):
      runTest(
          base_dir,
          test_collection,
          i,
          cit,
          cfg,
          cfg_fn,
          css,
          start,
          xslt_fo,
          xslt_html)


if __name__ == "__main__":
    main()
