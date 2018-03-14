# coding: utf-8
# !/usr/bin/env python3
# Created by wit at 14.03.18

import sys

#{"301-69-79769-1-10-20171127.xml": {"order": 1}},
def main():

    if len(sys.argv) >1:
        f = open(sys.argv[1],'r')
        for i, row in enumerate(f.readlines()):
            print('{{"{}":{{"order": {}}}}},'.format(row.strip(),i+1))

        f.close()
    else:
        print('Usage:\t  python booklistToJSON.py  booklist.csv')



if __name__ == "__main__":
    main()
