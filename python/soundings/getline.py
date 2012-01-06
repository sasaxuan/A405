from __future__ import with_statement
import glob,re
findchunk=re.compile('(.*?Observations at)(.*?\d{4,4})')

def get_segment(filename):
    with open(filename) as f:
        firstline=f.next()
        thematch=findchunk.match(firstline)
        if thematch:
            out=thematch.groups()
            time,day,month,year=out[1].split()
        else:
            raise Exception('broken')
        return out[0],time,day,month,year

if __name__=="__main__":
    listfiles=glob.glob('*txt')
    for filename in listfiles:
        print get_segment(filename)
        
