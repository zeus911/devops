#!/usr/bin/env python
'''
Created on 2013-8-13

@author: wangjiajun

This script do the following things to css file:
1 replace domain in url(...), "from" and "to" domain are specified by command options.
2 automatically add version at the end of url.
'''

from __future__ import print_function

import os
import fnmatch
import re
import hashlib
import shutil
import sys
import argparse

root = None
dirs = []
files = []

def processUrl(match):
    url = match.group(2)
    filepath = None
    if url.startswith(('http://', 'https://')):
        mo = re.match('(http|https)://([^/]+)/([^/]+)/([^?]+)', url)
        if mo is not None:
            domain = mo.group(2)
            project = mo.group(3)
            filename = mo.group(4)
            staticDomains = ('staticdev.example.com', 'statictest.example.com', 'static.example.com',
                'dn-static.qbox.me')
            if domain in staticDomains:
                if project == 'www.example.com': filepath = '~/www/www.example.com/public/'
                elif project == 'cloud': filepath = '~/data/www/cloud/'
                elif project == 'web': filepath = '~/data/www/52photo/live/'
                elif project == 'product': filepath = '~/data/www/product/'
                elif project == 'imgproc': filepath = '~/data/www/imgproc/public/'
            if filepath is not None:
                filepath = os.path.join(filepath, filename)
            
            if args.env == 'development': toDomain = 'staticdev.example.com'
            elif args.env == 'testing': toDomain = 'statictest.example.com'
            elif args.env == 'production': toDomain = 'dn-static.qbox.me'
            for staticDomain in staticDomains:
                url = url.replace(staticDomain, toDomain)
    elif url.startswith('/'):
        filepath = os.path.join(args.docroot, url.lstrip('/'))
    else:
        filepath = os.path.join(root, url)
    
    content = None
    if filepath is not None:
        filepath = os.path.expanduser(filepath)
        try:
            with open(filepath, 'rb') as fo:
                content = fo.read()
        except IOError as e:
            print(e)
    
    if content is None:
        query = ''
    else:
        h = hashlib.md5()
        h.update(content)
        query = '?v='+h.hexdigest()
    return match.group(1)+url+query+match.group(4)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='preprocess css files.')
    parser.add_argument('--docroot', default='.')
    parser.add_argument('--cssdir')
    parser.add_argument('--env', default='production', choices=['development', 'testing', 'production'])
    args = parser.parse_args()
    if args.cssdir is None:
        args.cssdir = args.docroot
    
    pattern = re.compile(r'(url\s*\(\s*[\'"]?\s*)([^\'"\s?]+)(\?[^\'"\s]*)?(\s*[\'"]?\s*\))', re.IGNORECASE)
    for root, dirs, files in os.walk(args.cssdir):
        for file in files:
            if fnmatch.fnmatch(file, '*.css'):
                print('begin process file "'+os.path.join(root, file)+'" ...')
                with open(os.path.join(root, file), 'r+') as fo:
                    lines = []
                    for line in fo.readlines():
                        if pattern.search(line):
                            print('original: '+line, end='')
                            line = pattern.sub(processUrl, line)
                            print('replaced: '+line, end='')
                        lines.append(line)
                    src = os.path.join(root, file)
                    dst = os.path.join(root, file+'.bak')
                    shutil.copyfile(src, dst)
                    fo.seek(0)
                    fo.truncate()
                    fo.write(''.join(lines))
