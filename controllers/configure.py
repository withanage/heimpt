def validate(form):
    if form.accepts(request, session):
        response.flash = 'form accepted'
    elif form.errors:
        response.flash = 'form has errors'
    else:
        response.flash = 'please fill the form'

@auth.requires_login()
def add_project():
    form = SQLFORM(db.projects,  col3={'files':"file names"},comments=True, keepopts=[], separator='')
    form['_style'] = 'border:1px solid white'
    validate(form)
    return dict(form=form)

@auth.requires_login()
def add_typesetter():
    form = SQLFORM(db.typesetters)
    validate(form)
    return dict(form=form)