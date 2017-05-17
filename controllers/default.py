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


def index():
    """
    example action using the internationalization operator T and flash
    rendered by views/default/index.html or views/generic.html

    if you need a simple wiki simply replace the two lines below with:
    return auth.wiki()
    """
    response.flash = T("Hello World")
    return dict(message=T('Welcome to web2py!'))


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

