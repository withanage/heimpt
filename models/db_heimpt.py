db.define_table('typesetters',
                Field('name', requires=IS_NOT_EMPTY()),
                Field('executable', requires=IS_NOT_EMPTY()),
                Field('arguments', type='list:string'),
                format='%(name)s'
                )

db.define_table('projects',
                Field('name', requires=IS_NOT_EMPTY()),
                Field('project_path', requires=IS_NOT_EMPTY()),
                Field('files',type='list:string', requires=IS_NOT_EMPTY()),
                Field('typesetter_1', requires= IS_IN_DB(db,db.typesetters.id,'%(name)s')),
                Field('typesetter_2', requires= IS_EMPTY_OR(IS_IN_DB(db,db.typesetters.id,'%(name)s'))),
                Field('typesetter_3', requires= IS_EMPTY_OR(IS_IN_DB(db,db.typesetters.id,'%(name)s'))),
                Field('typesetter_4', requires= IS_EMPTY_OR(IS_IN_DB(db,db.typesetters.id,'%(name)s'))),
                Field('typesetter_5', requires= IS_EMPTY_OR(IS_IN_DB(db,db.typesetters.id,'%(name)s'))),
                Field('project_active', type="boolean", default=True),
                Field('project_chain', type="boolean", default=True),
                Field('user_id', type="integer", default= auth.user.id, readable=False, writable=False)
                )


#db.projects.typesetter_1.widget = SQLFORM.widgets.autocomplete(request, db.typesetters.name, limitby=(0,10), min_length=2)
