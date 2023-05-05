from evdev import categorize, InputDevice, UInput, AbsInfo, ecodes as ec
import socket
import time
from _thread import *
import threading
import netifaces

# device = InputDevice('/dev/input/event16')
# print(device.capabilities(verbose=True))

cap = {
    ec.EV_KEY : [ec.BTN_WEST, ec.BTN_SOUTH, ec.BTN_EAST, ec.BTN_NORTH, ec.BTN_THUMBL, ec.BTN_THUMBR,
#                ec.KEY_UP, ec.KEY_DOWN, ec.KEY_LEFT, ec.KEY_RIGHT, # this binds directional keys to keyboard keys (not very nice)
                ec.BTN_SELECT, ec.BTN_START],
    ec.EV_ABS : [
        (ec.ABS_X, AbsInfo(value=0, min=-100, max=100, fuzz=0, flat=50, resolution=0)),
        (ec.ABS_Y, AbsInfo(value=0, min=-100, max=100, fuzz=0, flat=50, resolution=0))
    ]
}

codes = {'X': ec.BTN_WEST, 'A': ec.BTN_SOUTH, 'B':ec.BTN_EAST, 'Y': ec.BTN_NORTH, 'L':ec.BTN_THUMBL, 'R': ec.BTN_THUMBR,
        'UP': ec.ABS_HAT0X, 'DOWN': ec.ABS_HAT0X, 'LEFT': ec.ABS_HAT0Y, 'RIGHT': ec.ABS_HAT0Y, 'SELECT': ec.BTN_SELECT, 'START': ec.BTN_START,
        '1':1, '0':0, '-1': -1,
        'BTN': ec.EV_KEY, 'ABS': ec.EV_ABS
}

# iface = 'wlp6s0'
interfaces = netifaces.interfaces()
for i in range(len(interfaces)):
    print(f'{i}: {interfaces[i]}')
print('Escolha a interface de internet para se conectar')
choose = input()
while (int(choose) > len(interfaces)):
    print('Escolha a interface de internet para se conectar')
    choose = input()
addresses = netifaces.ifaddresses(interfaces[int(choose)])
own_address = addresses[netifaces.AF_INET][0]['addr']
# own_address = '127.0.0.1'
PORT = 2812
CLIENT_PORT = 55555
server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR,1)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
server_socket.bind((own_address, PORT))

print(f"This machine IP: {own_address}")

response_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
response_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR,1)
response_socket.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
response_socket.bind(('<broadcast>', PORT))

devices = {}

def listener_response():
    while True:
        data, addr = response_socket.recvfrom(2048)
        print("Received: ", data.decode(), " from ", addr)
        if (data.decode() == 'HENLO'):
            print("senting to ", addr)
            response_socket.sendto(bytes('GOODAY', "utf-8"), addr)



i = 0
start_new_thread(listener_response, ())
while True:
    # print("Listening")
    data, addr = server_socket.recvfrom(2048)
    print(f"{addr} says: {data.decode()}")
    if not addr in devices:
        devices[addr] = UInput(cap, name='eai-blz')
        print(devices[addr].capabilities(verbose=True))
    info = data.decode().split('/')
    print(i)
    print(info)
    # print(int(info[0][0]))
    # print(int(info[0][1]))
    # print(int(info[0][2]))
    # print(int(info[0][3]))
    # print(int(info[0][4]))
    # print(int(info[0][5]))
    # print(int(info[0][6]))
    # print(int(info[0][7]))
    devices[addr].write(ec.EV_KEY, ec.BTN_SOUTH, int(info[0][0]))
    devices[addr].write(ec.EV_KEY, ec.BTN_EAST, int(info[0][1]))
    devices[addr].write(ec.EV_KEY, ec.BTN_NORTH, int(info[0][2]))
    devices[addr].write(ec.EV_KEY, ec.BTN_WEST, int(info[0][3]))
    devices[addr].write(ec.EV_KEY, ec.BTN_THUMBR, int(info[0][4]))
    devices[addr].write(ec.EV_KEY, ec.BTN_THUMBL, int(info[0][5]))
    devices[addr].write(ec.EV_KEY, ec.BTN_SELECT, int(info[0][6]))
    devices[addr].write(ec.EV_KEY, ec.BTN_START, int(info[0][7]))
    devices[addr].write(ec.EV_ABS, ec.ABS_X, int(info[1]))
    devices[addr].write(ec.EV_ABS, ec.ABS_Y, int(info[2]))
    devices[addr].syn()
    # if (info[0] in codes and info[1] in codes and info[2] in codes):
    #     print(f'writing event {info[1]} of type {info[0]} of value {info[2]}')        
    #     devices[addr].write(codes[info[0]], codes[info[1]], codes[info[2]])
    #     devices[addr].syn()
    # time.sleep(1)
    i += 1
