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

"""
@auth.requires_login()
def folder():
    return dict(files=Expose('', basename='.',  extensions=['.py', '.jpg']))
"""






def args(a):
    r = DIV(_class="btn-group btn-group-xs")
    for i in a:
        r.append(DIV(i, _class="btn btn-default"))
    return r

@auth.requires_login()
def index():
    ms = []
    a = {'Projects':["default","projects","ddeeff"],
         'Typesetters':["default","typesetters","ccbbaa"]

         }
    for m in a:
        ms.append(metro_block(m,a[m][0],a[m][1],a[m][2]))
    return dict(ms=ms)

def metro_block(t,c,f,bg_color):
    img_src= "{}{}{}{}".format("holder.js/200x200?size=15&bg=",bg_color,"&text=",t)
    div= DIV(_class="col-sm-2 col-xs-4")
    a = DIV(_class="tile")
    b = DIV(_class="carousel slide" ,**{"data-ride":"carousel"})
    d = DIV(_class="item active")
    d.append(A(IMG(_src=img_src ,_class="img-responsive"),_href=URL(c,f)))
    e = DIV(_class="item")
    e.append(IMG(**{"data-src":img_src}))
    c =DIV(d,e, _class="carousel-inner")
    b.append(c)
    a.append(b)

    div.append(a)

    return div



@auth.requires_login()
def projects():

    t = db.projects
    tbl = db (t.id ==auth.user.id).select().as_list()
    bt = TABLE(_class="table table-bordered")
    th = THEAD()
    th.append(TR(TH(T("Run")),TH(T("Project name")),TH(T("Project Path")),TH(T("File List")),TH(T("Typesetters"))))
    bt.append(th)
    tb = TBODY()
    for row in tbl:
        ts = [db(db.typesetters.id==ts_id).select().first()["name"] for ts_id in row["typesetters"]]

        tb.append(TR(
            TD(row["id"]),
            TD(row["name"]),
            TD(row["project_path"]),
            TD(args(row["files"])),
            TD(args(ts)),
        ))
    bt.append(tb)
    return dict(bt=bt)




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
    th.append(TR(TH(T('Projects')),TH(T('OUTPUT Type')),TH(T('Executable path'),TH(T('Arguments')),TH(T('Project Arguments')))))
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

