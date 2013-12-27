#This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


__author__ = 'madPO'
__version__ = '25.12.13'

import time
import subprocess
import ctypes

def srv_start(srv):
    print('The server is started...')
    _b3dir = 'C:/b3/'
    _cod4dir = 'C:/GAME/COD4/'
    _cod4arg = '+set dedicated 2 +set net_ip localhost +exec server/cfg/'+srv+'.cfg +map_rotate'
    _b3arg = '-c '+_b3dir+'conf/'+srv+'.xml'
    cmd = _cod4dir+'iw3mp.exe '+ _cod4arg
    print('Server directory - '+ _cod4dir)
    print(cmd)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    cod4pid = p.pid
    print('Server pid - '+ str(cod4pid))
    f = open(_cod4dir+'pid/'+srv+'.pid', 'w')
    f.write(str(cod4pid))
    f.close()
    time.sleep(10)
    print('server is running')
    cmd = _b3dir+'b3_run.exe '+ _b3arg
    print('BigBrotherBot directory - '+ _b3dir)
    print(cmd)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    b3pid = p.pid
    print('BigBrotherBot pid - '+ str(b3pid))
    f = open(_cod4dir+'pid/'+srv+'_b3.pid', 'w')
    f.write(str(b3pid))
    f.close()
    time.sleep(10)
    print('BigBrotherBot is running')

def srv_stop(srv):
     print('stopping the server...')
     f = open('C:/GAME/COD4/pid/'+srv+'.pid', 'r')
     pid = f.read()
     f.close()
     print('server pid - '+ pid)
     PROCESS_TERMINATE = 1
     handle = ctypes.windll.kernel32.OpenProcess(PROCESS_TERMINATE, False, int(pid))
     ctypes.windll.kernel32.TerminateProcess(handle, -1)
     ctypes.windll.kernel32.CloseHandle(handle)
     f = open('C:/GAME/COD4/pid/'+srv+'.pid', 'w').write('')
     print('server is stopped')
     print('stopping the BigBrotherBot...')
     f = open('C:/GAME/COD4/pid/'+srv+'_b3.pid', 'r')
     pid = f.read()
     f.close()
     print('BigBrotherBot pid - '+ pid)
     PROCESS_TERMINATE = 1
     handle = ctypes.windll.kernel32.OpenProcess(PROCESS_TERMINATE, False, int(pid))
     ctypes.windll.kernel32.TerminateProcess(handle, -1)
     ctypes.windll.kernel32.CloseHandle(handle)
     f = open('C:/GAME/COD4/pid/'+srv+'_b3.pid', 'w').write('')
     print('BigBrotherBot is stopped')

def srv_restart(srv):
    srv_stop(srv)
    time.sleep(10)
    srv_start(srv)

print('#######################################################')
print('#      Abbreviations for the server                   #')
print('#      Search and Destroy - sd                        #')
print('#      Domination - dom                               #')
print('#-----------------------------------------------------#')
print('#      Abbreviations for the action                   #')
print('#      Starting the server - start                    #')
print('#      Stopping the server - stop                     #')
print('#      Restart the server - restart                   #')
print('#-----------------------------------------------------#')
print('# Enter the abbreviation of the server and the action #')
print('#               [sd start]                            #')
print('#      If you want to quit,enter - "exit"             #')
print('#######################################################')
print('')
data = input().split(' ')
#data[0] - srv, data[1] - action
while data[0] != 'exit':
    if (data[1] == 'start'):
        srv_start(data[0])
    else:
        if(data[1] == 'stop'):
            srv_stop(data[0])
        else:
            if(data[1] == 'restart'):
                srv_restart(data[0])
    data = input().split(' ')
