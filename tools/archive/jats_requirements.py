import json
from pprint import pprint

with open('jats_requirements.json') as data_file:
    data = json.load(data_file)

def recurse(data):
    for d in data:
        print_row(d, data[d])
        children = data[d].get('children')
        if children:
            for c in children:
                if children[c].get('children'):
                    print_row(c, children[c])
                    recurse(children[c].get('children'))


def print_row(a,b):
    print 100 * '-'
    print a, b.get('omp'), b.get('api'), b.get('remarks')


recurse(data)