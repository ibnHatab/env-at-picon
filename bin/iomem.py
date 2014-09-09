
import re


proc = open('/proc/iomem')

maps = proc.readlines()


for ln in maps:
  try:
    (start16, end16, label) = re.match('(\w+)-(\w+) : (.+)', ln.strip()).groups()
  except:
    print "ERROR: " + ln
  start, end = int(start16, 16), int(end16, 16)
  print "%10d-%10d [%d``]\t- %s" % (start, end, end - start, label)