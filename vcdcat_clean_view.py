#!/usr/bin//env python3
import os,sys
import time
import re

RE_VARLINE=re.compile(r"^[0-9][0-9]*[ ].*")
RE_BAR=re.compile(r"=======.*")
RE_NOTNUMSTART=re.compile(r"^[^0-9].*")

if len(sys.argv) < 2:
  print("Please provide a file name.")
  sys.exit()

SOURCE=sys.argv[1]

# We want to determine the following:
# 1. how many variables
# 2. how large each field needs to be.

DATA=open(SOURCE,"r").readlines()

VARCOUNT=0
HEADERS=[]
INDEX_WIDTH=len(DATA[-1].split()[0]) + 2

for row in DATA:
  if RE_VARLINE.match(row):
    VARCOUNT = VARCOUNT+1;
    HEADERS.append(str(row.split()[1]))
  elif RE_NOTNUMSTART.match(row):
    break

print("{} variables".format(VARCOUNT))
print("{} index width".format(INDEX_WIDTH))

DATA_INDEX_START = VARCOUNT+3

TEMPLATE='{:>' + str(INDEX_WIDTH) + '} '

for header in HEADERS[1:]:
  TEMPLATE=str(TEMPLATE + ('{:>' + str(len(header)+1) + '} ' ))

print(HEADERS)
print(TEMPLATE)
print(TEMPLATE.format(*HEADERS))

for idx in range(DATA_INDEX_START,len(DATA)):

  print(TEMPLATE.format(*DATA[idx].split()))
