#!/usr/bin/python
# -*- coding: utf-8 -*-
# Date:   2018-02-22 17:08
# Author: Kenson Man <kenson@kenson.idv.hk>
# Desc:   Unzip the first zip file
# Usage:  
#      python extract 

import zipfile, os, shutil, argparse

parser=argparse.ArgumentParser(description='Extract the zip file to specified folder (default: output)')
parser.add_argument('--zip', dest='zip', help='The zip file or the folder contains the zip files (default: .)', default='.')
parser.add_argument('--dest', dest='dest', help='The destination folder, default: output', default='output')
parser.add_argument('-s', '--skip', dest='skip', help='Skip the first level if and only if zipfile 1st level contains one folder', action='store_false', default=True)
args=parser.parse_args()

# Massage the arguments
if os.path.isfile(args.zip):
   files=[args.zip, ]
else:
   files= [ os.path.join(args.zip, f) for f in os.listdir(args.zip) if os.path.isfile(os.path.join(args.zip, f)) and f.upper().endswith('.ZIP')]
output=args.dest
if not os.path.isdir(output): os.mkdir(output)

# Extracting
for f in files:
   print('Unzip <%s> to <%s>...'%(f, output))
   zf=zipfile.ZipFile(f, 'r')
   zf.extractall(output)
   zf.close()

# Skipping 1st level 
if args.skip:
   files=[ f for f in os.listdir(output) if os.path.isdir(os.path.join(output, f))]
   if len(files)==1:
      for f in os.listdir(os.path.join(output, files[0])):
         src=os.path.join(output, files[0], f)
         trg=os.path.join(output, f)
         print('   Moving <%s> to <%s> ...'%(src, trg))
         shutil.move(src, trg)

print('DONE')
