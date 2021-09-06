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
    HEADERS.append(  str(row.split()[1]) )
  elif RE_NOTNUMSTART.match(row):
    break

print("{} variables".format(VARCOUNT))
print("{} index width".format(INDEX_WIDTH))

DATA_INDEX_START = VARCOUNT+3

TEMPLATE='{:>' + str(INDEX_WIDTH) + '} '
HTEMPLATE='{:>' + str(INDEX_WIDTH) + '} '

dataformat={}
leadzero={}

for header in HEADERS[1:]:
  if ":" in header:
    dataformat[header]=""
    leadzero[header]=""
  else:
    dataformat[header]=""
    leadzero[header]=""
  TEMPLATE=str(TEMPLATE + ('{:>' + str(leadzero[header]) + str(len(header)+1) + dataformat[header] + '} ' ))
  HTEMPLATE=str(HTEMPLATE + ('{:>' + str(len(header)+1) + '} ' ))

print(HTEMPLATE.format(*HEADERS))

for idx in range(DATA_INDEX_START,len(DATA)):
  FIELDVALUES=[]
  COL=0
  for field in DATA[idx].split():
    if ":" in HEADERS[COL]:
      hbit= HEADERS[COL].split(":")
      hbit_left= int(hbit[0].split("[")[1])
      hbit_right= int(hbit[1].split("]")[0])
      if hbit_left > hbit_right:
        hbit_delta=(hbit_left - hbit_right) + 1
      else:
        hbit_delta=(hbit_right - hbit_left) + 1
      if "x" in field:
        hexvalue="x"
      else:
        hexvalue = int(str("0x" + str(field) ),16)
        strvalue = '{:>0' + str(hbit_delta) + 'b}'
        hexvalue = strvalue.format( hexvalue)
      FIELDVALUES.append( hexvalue )
    else:
      FIELDVALUES.append( field )
    COL=COL +1
  print(TEMPLATE.format(*FIELDVALUES))
