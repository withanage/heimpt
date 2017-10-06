# -*- coding: utf-8 -*-
# this file is released under public domain and you can use without limitations

# -------------------------------------------------------------------------
# This is a sample controller
# - index is the default action of any application
# - user is required for authentication and authorization
# - download is for downloading files uploaded in the db (does streaming)
# -------------------------------------------------------------------------

from gluon.tools import Expose
import shutil
import gluon.contrib.simplejson

import os


"""
@auth.requires_login()
def folder():
    return dict(files=Expose('', basename='.',  extensions=['.py', '.jpg']))
"""



def create_modal(id, title, body, modal_body):
    a5 = BUTTON(_type="button", _class="close", **{"data-dismiss": "modal"})
    a6 = H4(title, _class="modal-title")
    a4 = DIV(a5, a6, _class="modal-header")
    a8 = P(body,**{"_id": modal_body})
    a7 = DIV(a8, _class="modal-body")
    a10 = BUTTON(T("close"), _type="button", _class="btn btn-default", **{"_data-dismiss": "modal"})
    a9 = DIV(a10, _class="modal-footer")
    a3 = DIV(a4, a7, a9, _class="modal-content")
    a2 = DIV(a3, _class="modal-dialog modal-lg")
    a1 = DIV(a2, _class="modal fade", **{"_id": id, "_role": "dialog"})
    return a1


def args(a):
    r = DIV(_class="")
    for i in a:
        r.append(SPAN(i, _class="label label-default"))
        r.append(BR())
    return r

@auth.requires_login()
def index():
    conf_add, tools = [], []
    b = {
        'Add Project': ["configure", "add_project", "info"],
        'Add Typesetter': ["configure", "add_typesetter", "info"],
        'Projects': ["default", "projects", "primary"],
        'Typesetters': ["default", "typesetters", "primary"]
         }

    a = {
        'Open Monograph Press': ["https://books.ub.uni-heidelberg.de/index.php/heiup/submissions", "", "default"],
        'Open Journal Systems': ["https://journals.ub.uni-heidelberg.de/index.php/ojs/login", "", "default"],
    }
    for m in sorted(a):
        conf_add.append(navigation(m,a[m][0],a[m][1],a[m][2]))

    for m in sorted(b):
        tools.append(navigation(m,b[m][0],b[m][1],b[m][2]))

    return dict(conf_add=conf_add, tools= tools)



def navigation(t,c,f,btn):
    p = P()
    if  c.startswith("http"):
        url = c
    else :
        url = URL(request.application, c, f)
    a = A(t,_href=url,_class="btn btn-"+btn+" btn-lg btn-block")
    p.append(a)

    return p



def path_to_dict(path):
    f = os.path.basename(path)

    d = {'text': f}

    if os.path.isdir(path):
        d['nodes'] = [path_to_dict(os.path.join(path,x)) for x in os.listdir(path)]
        d["backColor"] = "#FFFFFF"

    else:
        d["icon"] = "glyphicon glyphicon-file"
    return d





@auth.requires_login()
def projects():

    t = db.projects
    tbl = db (t.id >0).select().as_list()
    bt = TABLE(_class="table table-bordered" ,_name="tbl")
    th = THEAD()
    th.append(TR(TH(T("Run")),TH(T("Project name")),TH(T("File List")),TH(T("Typesetters")),TH(T("View Results")),TH(T("D.")),TH(T("E.")),TH(T("D."))))
    bt.append(th)
    tb = TBODY()

    modals = {}
    result_dir = {}
    for row in tbl:
        ts = [db(db.typesetters.id==ts_id).select().first()["name"] for ts_id in row["typesetters"]]

        result_path = os.path.join(row["project_path"], row["name"])
        result_dir[row["id"]] = gluon.contrib.simplejson.dumps(path_to_dict(result_path))
        download_view = TD(_id="result_directory_"+str(row["id"]),_class="col-md-4 col-lg-4")

        file_path = os.path.join(row["project_path"], row["name"], row["name"] + '.zip')
        if os.path.exists(file_path):
            download_td = TD(A(TAG.I(_class="icon icon-play glyphicon glyphicon-download align-middle "), _href=URL('default', '{}/{}'.format('get_results', row["id"]))),_id="download_zip_"+str(row["id"]))
        else:
            download_td = TD()

        modals[row["id"]] = create_modal("runHeimpt"+str(row["id"]), T("Processing"), "", "runHeimptBody"+str(row["id"]))
        tb.append(TR(
            TD(BUTTON("Run", _class="btn btn-info btn-sm", **{"_data-toggle":"modal","_data-target":"#runHeimpt"+str(row["id"])})),
            TD(DIV(row["name"])),
            TD(args(row["files"])),
            TD(args(ts)),
            download_view,
            download_td,
            TD(A(TAG.I(_class="glyphicon glyphicon-edit"), _href=URL('configure', '{}/{}'.format('edit_project', row["id"])))),
            TD(A(TAG.I(_class="glyphicon glyphicon-remove-sign"), _href=URL('configure', '{}/{}'.format('delete_project', row["id"]))))

        ))
    bt.append(tb)

    return dict(bt=bt, modals=modals, result_dir=result_dir)




@auth.requires_login()
def typesetters():

    def tooltip(m):
        return {"_data-toggle":"tooltip", "_data-placement":"right", "_title":m}

    def typesetter_path(p):
        if is_executable(p):
            return DIV(p)
        else:
            return DIV(TAG.DEL(p),**tooltip(T("Path invalid")))


    t=db.typesetters
    tbl = db(t.id>0).select().as_list()
    bt = TABLE(_class="table table-bordered")
    th = THEAD()
    th.append(TR(TH(T('Typesetters')),TH(T('Output Type')),TH(T('Executable path'),TH(T('Arguments')),TH(T('Project Arguments')))))
    bt.append(th)
    tb = TBODY()
    for row in tbl:
        tb.append(TR(TD(row["name"]),TD(DIV(row["out_type"],_class='text-uppercase')),
                     TD(typesetter_path(row["executable"])),
                     TD(args(row['typesetter_arguments'])),
                     TD(args(row['project_arguments'])),
                     TD(A(T('EDIT'),_href=URL('configure','{}/{}'.format('edit_typesetter',row["id"]))))

                     ))

    bt.append(tb)
    return dict(message=T('Loaded'),bt=bt)


def user():
    """
    exposes:
    http://..../[app]/default/user/login
    http://..../[app]/default/user/logout
    http://..../[app]/default/user/register
    http://..../[app]/default/user/profile
    http://..../[app]/default/user/retrieve_password
    http://..../[app]/default/user/change_password
    http://..../[app]/default/user/bulk_register
    use @auth.requires_login()
        @auth.requires_membership('group name')
        @auth.requires_permission('read','table name',record_id)
    to decorate functions that need access control
    also notice there is http://..../[app]/appadmin/manage/auth to allow administrator to manage users
    """
    return dict(form=auth())


@cache.action()
def download():
    """
    allows downloading of uploaded files
    http://..../[app]/default/download/[filename]
    """
    return response.download(request, db)





@auth.requires_login()
def upload_files():
    t = db.t_files
    record = t(request.args(0)) or redirect(URL('index'))
    url = URL('download')
    form = SQLFORM(t, record, deletable=True,
                   upload=url, fields=['name', 'image'])
    if request.vars.image != None:
        form.vars.image_filename = request.vars.image.filename
    if form.process().accepted:
        response.flash = 'form accepted'
    elif form.errors:
        response.flash = 'form has errors'
    return dict(form=form)


@auth.requires_login()
def get_results():
    from gluon.contenttype import contenttype
    if  request.args:
        entry = request.args[0]
    else:
        raise HTTP(404, 'not found')

    row = db(db.projects.id==entry).select().first()
    file_path = os.path.join(row["project_path"],row["name"],row["name"]+'.zip')

    ext = os.path.splitext(file_path)
    response.headers['Content-Type'] = contenttype('zip')
    response.headers['Content-disposition'] = 'attachment; filename=%s' % row["name"]+'.zip'
    res = response.stream(open(file_path, "rb"), chunk_size=4096)
    return res


def call():
    """
    exposes services. for example:
    http://..../[app]/default/call/jsonrpc
    decorate with @services.jsonrpc the functions to expose
    supports xml, json, xmlrpc, jsonrpc, amfrpc, rss, csv
    """
    return service()


def upload():
    response.headers['Access-Control-Allow-Origin'] = '*'
    d = {}
    if request.vars:
        filename = request.vars.upload.filename
        file = request.vars.upload.file
        pth ='/home/www-data/web2py/applications/UBHD_OMPPortal/static/files/presses/6/monographs/90/submission/proof/'
        shutil.copyfileobj(file, open(pth+ filename, 'wb'))
        if filename:
                d = {"name":filename, "type": "type", "size": "size",
                 "url": "url",
                 "deleteUrl": "delete_url",
                 "deleteType": "delete_type"}


    return gluon.contrib.simplejson.dumps(d)

