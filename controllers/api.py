import gluon.contrib.simplejson


def arg_0(a):
    if a:
        return a[0]
    else:
        raise HTTP(404, 'not found')


def project():
    def add_elem(cur, arg1, val1):
        cur[arg1] = p.get(val1)

    # todo change 1
    p = db(db.projects.id == arg_0(request.args)).select().first().as_dict()
    c = {"projects": [{}]}
    cur = c.get("projects")[0]
    add_elem(cur, "active", "project_active")
    add_elem(cur, "chain", "project_chain")
    add_elem(cur, "path", "project_path")
    add_elem(cur, "name", "name")

    cur["files"] = {}
    cur["typesetters"] = {}
    c["typesetters"] = {}

    for i, f in enumerate(p.get("files")):
        cur.get("files")[i + 1] = f

    for i, t in enumerate(p.get("typesetters")):
        ts = db(db.typesetters.id == t).select().first()
        args = {}

        for j, a in enumerate(ts["project_arguments"]):
            args[j + 1] = a

        cur.get("typesetters")[i + 1] = {
            "name": ts["name"],
            "out_type": ts["out_type"],
            ts["process_type"]: True,
            "arguments": args
        }

        ts_name = c["typesetters"]
        ts_name[ts["name"]] = {}
        ts_name[ts["name"]]["arguments"] = {}
        ts_name[ts["name"]]["executable"] = ts["executable"]
        for j, a in enumerate(ts["typesetter_arguments"]):
            ts_name[ts["name"]]["arguments"][j + 1] = a

    return gluon.contrib.simplejson.dumps(c)


