import json
import random
import string
import socket

TCP_IP = '127.0.0.1'
TCP_PORT = 5000
BUFFER_SIZE = 1024
MAX_LOGS = 100000
# 100000 ~ 1min 30sec

ip_srcs = ['192.168.140.6', '192.168.140.7', '192.168.140.8']

websvs = ['apache', 'nginx']

methods = ['GET', 'POST']

gets = ['/index.html', '/checkout.html', '/logo.png', '/hero.png', '/bg.png', '/search']

posts = ['/users/create', '/users/delete', '/users/update', '/purchase', '/message']

protocols = ['HTTP/1.0', 'FTP']

responses = ['200', '404', '401']

usertypes = ['basic', 'pro', 'premium']

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((TCP_IP, TCP_PORT))

for _ in range(0, MAX_LOGS):
    method = random.choice(methods)
    jlog = {
        'ip_src' : random.choice(ip_srcs),
        'websv' : random.choice(websvs),
        'method' : method,
        'query' : random.choice(gets) if method == 'GET' else random.choice(posts),
        'protocol' : random.choice(protocols),
        'response' : random.choice(responses),
        'user' : ''.join(random.choice(string.ascii_letters + string.digits)
            for _ in range(6)),
        'usertype' : random.choice(usertypes),
        'user_ip' : ".".join(map(str, (random.randint(0, 255)
            for _ in range(4)))),
    }
    msg = json.dumps(jlog) + '\n'
    s.send(msg.encode('utf-8'))

s.close()
