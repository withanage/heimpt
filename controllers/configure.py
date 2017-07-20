typesetter_cols = {
    'name': SPAN((T("Name of the project")), _class=""),
    'out_type': SPAN((T("Generated output format. Default is XML")) ),
    'executable': SPAN((T("Program path, absolute path of the executable file")) ),
    'process_type': SPAN((T(
        "process: runs one output file, merge: generates combined output file, expand: generates more than one output files")),
                         _class=""),
    'typesetter_arguments': SPAN((T("Typesetter Arguments: Order is important")), _class=""),
    'project_arguments': SPAN((T("Project Arguments: Order is important")), ),

}


def validate(form,c,f):
    if form.accepts(request, session):
        response.flash = 'form accepted'
        redirect(URL(c,f))
    elif form.errors:
        response.flash = 'form has errors'
    else:
        response.flash = 'please fill the form'


@auth.requires_login()
def add_project():
    form = SQLFORM(db.projects, col3={'files': "file names"}, comments=True, keepopts=[], separator='')
    form['_style'] = 'border:1px solid white'
    validate(form)
    return dict(form=form)


@auth.requires_login()
def add_typesetter():
    form = SQLFORM(db.typesetters, comments=True, keepopts=[],
                   col3=typesetter_cols )
    validate(form, 'default', 'typesetters')
    return dict(form=form)

@auth.requires_login()
def edit_typesetter():
    if request.args:
        entry = request.args[0]
    else:
        raise HTTP(404,'not found')
    form = SQLFORM(db.typesetters,entry, comments=True, keepopts=[],
                   col3=typesetter_cols )
    validate(form,'default','typesetters')
    return dict(form=form)