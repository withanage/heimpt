db.define_table('typesetters',
                Field('name', requires=IS_NOT_EMPTY()),
                Field('executable', requires=IS_NOT_EMPTY()),
                Field('out_type',label=T('Output Type'), requires=IS_NOT_EMPTY(), default='xml'),
                Field('process_type', requires=IS_IN_SET(('process','merge','expand')), default='process'),
                Field('typesetter_arguments', type='list:string', label=T('Typesetter Arguments')),
                Field('project_arguments', type='list:string', label=T('Project Arguments'),default=['--created-dir'], required=True),
                format='%(name)s'
                )

user = auth.user.id if auth.user else 0

db.define_table('projects',
                Field('name', requires=IS_NOT_EMPTY(), label=T('Projects')),
                Field('project_path', requires=IS_NOT_EMPTY()),
                Field('files',type='list:string', requires=IS_NOT_EMPTY()),
                Field('typesetters',type='list:string'),

                Field('project_active', type="boolean", default=True),
                Field('project_chain', type="boolean", default=True),
                Field('user_id', type="integer", default= user, readable=False, writable=False)
                )


#db.projects.typesetter_1.widget = SQLFORM.widgets.autocomplete(request, db.typesetters.name, limitby=(0,10), min_length=2)
