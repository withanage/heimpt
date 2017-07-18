@auth.requires_login()
def index():
    #solr.add(id=1, title='Lucene in Action', author=['Erik Hatcher', 'Otis Gospodneti'])
    #solr.commit()
   
    return locals()