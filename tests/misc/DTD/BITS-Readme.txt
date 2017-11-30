Delivery Letter for the BITS Book DTD 2.0
    (BITS Book DTD Version 2.1 January 2016)

                                           January 2016

======================================================

This README describes:

   1.0 The Two BITS Book DTDs
   2.0 Modules Needed for each DTD
       2.1 Modules Used in BITS XHTML Tables DTD
       2.3 Modules Used in BITS Both XHTML and OASIS CALS
             Tables DTD
    3.0 Descriptions of the Base Modules
       3.1 BITS Base Modules (used by all the BITS DTDs)
       3.2  JATS Base Modules: Base Modules
       3.3  JATS Base Modules: Element Class Modules
       3.4  JATS Base Modules: Notations and Special Characters
       3.5  JATS Base Modules: Math Modules 
       3.6  JATS Base Modules: Table Modules
    4.0 Catalog Files

The BITS Book DTDs are generic book DTDs based on the NISO JATS 
Archiving and Interchange DTD (ANSI/NISO JATS Z39.96-2015
Version 1.1). The BITS file names incorporate
the number "2" for BITS version "2.0". The JATS file names 
incorporate the number "1" for ANSI/NISO JATS Z39.96-2015
version 1.1.

======================================================

1.0 The Two BITS Book DTDs

There are two BITS Book DTDs, based on the Suite. They 
are identical except for table modeling:

  - Basic BITS (BITS-book2.dtd) includes the JATS 
    XHTML-based table model.

  - BITS OASIS (BITS-book-oasis2.dtd) includes two table
    models: the JATS XHTML-based table model and the 
    OASIS CALS Exchange Table Model.

======================================================

2.0 Modules Needed for each DTD

2.1 Modules Specific to the BITS Book DTD

This DTD describes only XHTML tables.

BITS-book2.dtd
           - Main DTD module for the BITS DTD, which
             defines the model of the element <book>.

BITS-bookcustom-modules2.ent 
           - Names all new modules created specifically
             for this BITS DTD (therefore not part of
             the base NISO JATS)
               
             This module must be called as the first 
             module in the DTD, just before the Suite 
             Module of Modules %JATS-modules1.ent;, which it
             supplements.

BITS-bookcustom-classes2.ent
           - The DTD-specific class definitions for the 
             this BITS DTD. Used to over-ride the Suite
             default classes. 
             
             Declared in %bookcustom-modules1.ent;
             Must be invoked in the DTD file before the 
             default classes module.

BITS-bookcustom-mixes2.ent
           - The DTD-specific mix definitions for the 
             this BITS DTD. Used to over-ride the Suite
             default mixes. 
             
             Declared in %bookcustom-modules1.ent;
             Must be invoked in the DTD file before the 
             default mixes module.

BITS-bookcustom-models2.ent
           - The DTD-specific content model over-rides 
             for this BITS DTD. Used to over-ride the Suite
             default models.
             
             Declared in %bookcustom-modules2.ent;
             Must be invoked before all of the DTD Suite
             modules since it is used to over-ride them.
          
             There are two types of such over-rides. Those 
             that replace a complete content model are
             named with a suffix "-model". Those that are 
             OR-groups of elements (intended to be mixed 
             with #PCDATA inside a particular model) are 
             named with an "-elements" suffix.

BITS-book-part-wrap2.ent 
           - Content models and attributes for the other
             top-level element defined by the BITS Book
             Tag Set, the <book-part-wrapper> element.

------------------------------------------------------

2.2 Modules Specific to BITS Book DTD with 
    both OASIS and XHTML Tables 

BITS-book-oasis2.dtd
           - Main DTD module for the BITS OASIS DTD, which
             defines the model of the element <book>
             that uses both XHTML-like and OASIS table
             models.

BITS-book-oasis-custom-modules2.ent 
           - Names all new modules created specifically
             for this BITS OASIS DTD (therefore not part of
             the base NISO JATS or the regular BITS Book DTD)
               
             This module must be called as the first 
             module in the DTD, just before the Suite 
             Module of Modules %JATS-modules1.ent;, which it
             supplements.

BITS-book-oasis-custom-classes2.ent
           - The DTD-specific class definitions for the 
             this BITS OASIS DTD. Used to over-ride the Suite
             default classes. 
             
             Declared in BITS-book-oasis-custom-modules1.ent
             Must be invoked in the BITS OASIS DTD file before 
             the default classes module.

BITS-book-part-oasis-wrap2.ent 
           - Content models and attributes for the other
             top-level element defined by the BITS Book
             Tag Set, the <book-part-wrapper> element
             for the BITS Book OASIS DTD.

======================================================
3.0 Descriptions of the Base Modules

3.1 BITS Base Modules (used by all the BITS DTDs)

These modules define BITS-specific components.

BITS-bookmeta2.ent 
           - Content models and attributes for the new
             book metadata elements (such as 
             <collection-meta>); particular to the BITS 
             DTDs

BITS-book-part2.ent 
           - Content models and attributes for the book
             components (such as chapters, parts, modules,
             and units) which have all been named as
             <book-part>s; particular to the BITS DTDs

BITS-embedded-index2.ent
           - Content models and attributes for the 
             index terms to be embedded in running text.

BITS-index2.ent
           - BITS structural Index model.

BITS-toc2.ent
           - BITS structural Table of Contents model.

BITS-toc-index-nav2.ent
           - Elements used only in structural Indexes and
             Tables of Contents.

------------------------------------------------------
3.2 JATS Base Modules: Critical Base Modules
    (Used by all of the BITS DTDs)

JATS-modules1.ent
               Names the modules in the NISO JATS 
               DTD Suite.
                                      
               Called as the second or third module by any
               DTD:  after the DTD-specific module of
               of modules (if any), after the MathML 3.0
               modules (if any), and before all other modules.
                 
               NOTE: May name modules (such as the 
               OASIS-Exchange module) that are not called 
               by a particular DTD.

JATS-ali-namespace1.ent  
               Namespace setup for the NISO Access and
               Indicators elements (prefix ali:). The
               elements are defined in the JATS Common 
               module (described below).
               [Note: Unlike typical web practice, this
               URI ends in a slash.]

JATS-common-atts1.ent
               Defines attributes intended to be used on 
               ALL elements defined in the NISO JATS, 
               including table elements for both the 
               XHTML-inspired and OASIS-inspired table 
               models, with the exception of <mml:math> 
               whose namespaces JATS does not control. 
                                       
               Must be called after all module-of-modules
               modules and any namespacing modules, but 
               before all customization (over-ride) modules.

JATS-default-classes1.ent
               The class definitions that are common to the
               NISO JATS DTD Suite. These may be overridden
               by DTD-specific class declarations.

               Must be invoked before any element-defining
               modules such as common or the element
               modules.

JATS-default-mixes1.ent
               The mix definitions that are common to the
               NISO JATS DTD Suite. These may be overridden
               by DTD-specific mix declarations.

               Must be invoked before any element-defining
               modules such as common or the element
               modules.

JATS-common1.ent 
               Defines all elements, attributes, entities
               used by more than one module. This includes
               the namespaced ALI elements, so the 
               ALI namespace module should be declared and
               called before this module.
                   
               Called after all module-of-modules modules,
               namespace modules, and all customization 
               (over-ride) modules but before all the element
               class modules. 

These modules need to be invoked before all other modules 
in a DTD. Other modules can usually be invoked in any order.
They are listed below alphabetically.


------------------------------------------------------
3.3 JATS Base Modules: Element Class Modules 
    (Define the elements and attributes for one class)
    (Used by all of the DTDs)

JATS-articlemeta1.ent  - Article-level metadata elements 
JATS-backmatter1.ent   - Article-level back matter elements
JATS-display1.ent      - Display elements such as Table, Figure, Graphic
JATS-format1.ent       - Format-related elements such as Bold
JATS-funding1.ent      - Award, sponsor, and other funding-related metadata
JATS-journalmeta1.ent  - Journal-level metadata elements
JATS-link1.ent         - Linking elements such as X(Cross)-Reference
JATS-list1.ent         - List elements
JATS-math1.ent         - JATS-defined math elements such as Display Equation
JATS-para1.ent         - Paragraph-level elements such as Paragraph,
                         Statement, and Block Quote
JATS-phrase1.ent       - Phrase-level content-related elements
JATS-references1.ent   - Bibliographic reference list and the elements
                         that can be used inside a citation
JATS-related-object1.ent
                       - <related-object> is similar to but broader 
                         than <related-article> for databases, books, 
                         chapters in books, etc.
JATS-section1.ent      - Section-level elements


(Note: nlmcitation.ent  is NOT included. This defines <nlm-citation>,
which is deprecated in JATS and not used in BITS.)

------------------------------------------------------
3.4 JATS Base Modules: Notations and Special Characters
    (Used by all of the DTDs)

JATS-notat1.ent   
             - Names all Notations used

JATS-chars1.ent   
             - Defines JATS-specific and custom special
               characters (as general entities defined
               as hexadecimal or decimal character
               entities [Unicode numbers] or by using
               the <private-char> element).

JATS-xmlspecchars1.ent
             - Names all the standard special character
               entity sets to be used by the DTD. The
               MathML characters sets were used,
               unchanged, in the same directory
               structure used for MathML.

All the MathML special character entity sets:

(inside the iso8879 subdirectory)
  isobox.ent
  isocyr1.ent
  isocyr2.ent
  isodia.ent
  isolat1.ent
  isolat2.ent
  isonum.ent
  isopub.ent

(inside the iso9573-13 subdirectory)
  isoamsa.ent
  isoamsb.ent
  isoamsc.ent
  isoamsn.ent
  isoamso.ent
  isoamsr.ent
  isogrk3.ent
  isomfrk.ent
  isomopf.ent
  isomscr.ent
  isotech.ent

Special character entity sets NOT used in MathML
(included as part of the DTD for backwards compatibility)  

(inside the xmlchars subdirectory)
  isogrk1.ent
  isogrk2.ent
  isogrk4.ent

 
------------------------------------------------------
3.5 JATS Base Modules: Modules for MathML 3.0 
    (Define MathML tagging, used in %math.ent;)

JATS-mathml3-mathmlsetup1.ent - DTD Suite module that sets 
                                the parameter entities for the 
                                MathML 3.0 modules

The top-level MathML 3.0 modules:
  mathml3.dtd
  mathml3-qname-1.mod

And inside the mathml subdirectory:
  mmlalias.ent
  mmlextra.ent

------------------------------------------------------
3.6 JATS Base Modules: Table Modules 

3.6.1  XHTML Table Model (Defines XHTML Table Model)

These modules are defined in the Suite and should be invoked
from the DTD if XHTML table tagging is desired. The XHTML
table model is the default table model for the JATS Suite.

  JATS-XHTMLtablesetup1.ent 
                       - JATS module to set up parameter
                         entities and attributes for
                         XHTML table processing

  xhtml-table-1.mod    - XHTML DTD module
  xhtml-inlstyle-1.mod - XHTML style attribute module

3.6.2  OASIS Exchange CALS Table Model

If an organization wishes to use the OASIS Exchange CALS table 
model instead of OR IN ADDITION TO the XHTML model, the following
modules are included as well as the XHTML ones:

  JATS-oasis-tablesetup1.ent 
                       - JATS module to set up parameter
                         entities and attributes for
                         OASIS Exchange CALS table processing
  JATS-oasis-namespace1.ent 
                       - JATS module that sets up the OASIS 
                         namespace, by default with the namespace 
                         prefix of "oasis".

  oasis-exchange.ent   - Basic OASIS CALS table model


======================================================

4.0 CATALOG FILES

These files are not part of the JATS Base Modules proper, but 
are provided as a convenience to implementors.

catalog-jats-v1-1-no-base.xml
               - XML catalog made according to the
                 OASIS DTD Entity Resolution XML Catalog V2.1
"http://www.oasis-open.org/committees/entity/release/1.0/catalog.dtd"
                 with no @xml:base attribute provided
                 on the group level.

catalog-jats-v1-1-with-base.xml
               - XML catalog made according to the
                 OASIS DTD Entity Resolution XML Catalog V2.1
"http://www.oasis-open.org/committees/entity/release/1.0/catalog.dtd"
                 with a place-holder @xml:base attribute
                 provided on each group level, for the convenience
                 of implementors, who will change the @xml:base
                 to point to their locations.

=============== document end =========================





















