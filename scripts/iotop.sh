#!/usr/bin/python  
# Monitoring per-process disk I/O activity  
# written by http://www.vpsee.com   
 
import sys, os, time, signal, re  
 
class DiskIO:  
    def __init__(self, pname=None, pid=None, reads=0, writes=0):  
        self.pname = pname  
        self.pid = pid  
        self.reads = 0 
        self.writes = 0 
 
def main():  
    argc = len(sys.argv)  
    if argc != 1:  
        print "usage: ./iotop" 
        sys.exit(0)  
 
    if os.getuid() != 0:  
        print "must be run as root" 
        sys.exit(0)  
 
    signal.signal(signal.SIGINT, signal_handler)  
    os.system('echo 1 > /proc/sys/vm/block_dump')  
    print "TASK              PID       READ      WRITE" 
    while True:  
        os.system('dmesg -c > /tmp/diskio.log')  
        l = []  
        f = open('/tmp/diskio.log', 'r')  
        line = f.readline()  
        while line:  
            m = re.match('^(\S+)\((\d+)\): (READ|WRITE) block (\d+) on (\S+)', line)  
            if m != None:  
                if not l:  
                    l.append(DiskIO(m.group(1), m.group(2)))  
                    line = f.readline()  
                    continue 
                found = False 
                for item in l:  
                    if item.pid == m.group(2):  
                        found = True 
                        if m.group(3) == "READ":  
                            item.reads = item.reads + 1 
                        elif m.group(3) == "WRITE":  
                            item.writes = item.writes + 1 
                if not found:  
                    l.append(DiskIO(m.group(1), m.group(2)))  
            line = f.readline()  
        time.sleep(1)  
        for item in l:  
            print "%-10s %10s %10d %10d" % (item.pname, item.pid, item.reads, item.writes)  
 
def signal_handler(signal, frame):  
    os.system('echo 0 > /proc/sys/vm/block_dump')  
    sys.exit(0)  
 
if __name__=="__main__":  
    main()  
