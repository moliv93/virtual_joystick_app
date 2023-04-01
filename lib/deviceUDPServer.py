from evdev import categorize, InputDevice, UInput, AbsInfo, ecodes as ec
import socket
import time


cap = {
    ec.EV_KEY : [ec.BTN_WEST, ec.BTN_SOUTH, ec.BTN_EAST, ec.BTN_NORTH, ec.BTN_THUMBL, ec.BTN_THUMBR,
#                ec.KEY_UP, ec.KEY_DOWN, ec.KEY_LEFT, ec.KEY_RIGHT, # this binds directional keys to keyboard keys (not very nice)
                ec.BTN_SELECT, ec.BTN_START],
    ec.EV_ABS : [
        (ec.ABS_HAT0X, AbsInfo(value=0, min=-1, max=1, fuzz=0, flat=0, resolution=0)),
        (ec.ABS_HAT0Y, AbsInfo(value=0, min=-1, max=1, fuzz=0, flat=0, resolution=0))
    ]
}

codes = {'X': ec.BTN_WEST, 'A': ec.BTN_SOUTH, 'B':ec.BTN_EAST, 'Y': ec.BTN_NORTH, 'L':ec.BTN_THUMBL, 'R': ec.BTN_THUMBR,
        'UP': ec.ABS_HAT0X, 'DOWN': ec.ABS_HAT0X, 'LEFT': ec.ABS_HAT0Y, 'RIGHT': ec.ABS_HAT0Y, 'SELECT': ec.BTN_SELECT, 'START': ec.BTN_START,
        '1':1, '0':0, '-1': -1,
        'BTN': ec.EV_KEY, 'ABS': ec.EV_ABS
}

HOST = '<broadcast>'
PORT = 2812
server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR,1)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
server_socket.bind((HOST, PORT))

devices = {}

i = 0
while True:
    # print("Listening")
    data, addr = server_socket.recvfrom(2048)
    print(f"{addr} says: {data.decode()}")
    if not addr in devices:
        devices[addr] = UInput(cap, name='eai-blz')
    info = data.decode().split()
    print(info)
    if (info[0] in codes and info[1] in codes and info[2] in codes):
        print(f'writing event {info[1]} of type {info[0]} of value {info[2]}')        
        devices[addr].write(codes[info[0]], codes[info[1]], codes[info[2]])
        devices[addr].syn()
    # time.sleep(1)
    i += 1