import gluon.contrib.simplejson
def projects():
    def add_elem(c, arg1, val1):
        c.get("projects")[0][arg1] = p.get(val1)
    #todo change 1
    p = db(db.projects.id == 1).select().first().as_dict()
    c = {"projects": [{}]}

    add_elem(c, "active", "project_active")
    add_elem(c, "chain", "project_chain")
    add_elem(c, "active", "project_active")
    add_elem(c, "name", "name")
    c.get("projects")[0]["files"] = {}

    for i, f in enumerate(p.get("files")):
        c.get("projects")[0].get("files")[i + 1] = f



    return gluon.contrib.simplejson.dumps(c)
"typesetters": {
      "1": {
        "arguments": {
          "1": "--create-dir"
        },
        "name": "metypeset",
        "out_type": "xml",
        "process": true
      },

    "typesetters": {
        "metypeset": {
            "arguments": {
                "1": "docx",
                "2": "--debug",
                "3": "--nogit",
                "4": "--noimageprocessing"
            },
            "executable": "/home/www-data/web2py/applications/heimpt/static/tools/meTypeset/bin/meTypeset.py"
        },