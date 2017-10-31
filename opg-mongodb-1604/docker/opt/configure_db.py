#!/usr/bin/env python

import os
import time
from subprocess import call
import subprocess
from __builtin__ import any
import sys
import socket
import json
from datetime import datetime

if os.getenv('MONGO_SKIP_SETUP', 'False') is True:
    print "MONGO_SKIP_SETUP is set to True - exiting"
    exit(0)
else:
    mongod_running = "run: mongod: (pid"
    logfile = open("/var/log/mongodb/configure-mongo-db.log", "w")
    sys.stdout = logfile
    sys.stderr = logfile
    sleep_timeout = 30

def get_mongo_params():
    host_ip = os.environ['MONGO_HOST_IP']
    rs_hosts = os.environ['MONGO_RS_HOSTS'].split(',')
    admin_username = 'admin'
    admin_password = os.environ['MONGO_ADMIN_PASSWORD']

    return host_ip, rs_hosts, admin_username, admin_password


def log_message(message, message_type="info"):
    output = {
        "type": "log",
        "@timestamp": "{}".format(datetime.today().isoformat()),
        "tags": "[{}]".format(message_type),
        "message": "{}".format(message)
    }
    print "{}".format(json.dumps(output))


def init_mongo(rs_hosts, host_ip):
    if os.getenv('MONGO_ONE_NODE', 'False') == 'True':
        time.sleep(5)
        rs_initiate_js = "rs.initiate();"
    else:
        if host_ip != socket.getaddrinfo(rs_hosts[0], 80)[0][4][0]:
            log_message('Doing nothing - only the first listed node should try to initiate replicate set')
            exit(0)

        log_message("Waiting 1 minute to allow all nodes time to come up")
        time.sleep(60)

        with open("/etc/hosts", "a") as myfile:
            myfile.write("127.0.0.1 " + rs_hosts[0])

        id_number = 0
        rs_initiate_js = "rs.initiate({'_id': 'rs0' , 'members': ["
        for rs_host in rs_hosts:
            rs_initiate_js = rs_initiate_js + "{ '_id': " + str(id_number) + ", 'host': '" + rs_host + ":27017'},"
            id_number += 1
        rs_initiate_js += "]});"

    log_message('Setting up replica set')
    call(["/usr/bin/mongo", "admin", "--eval", rs_initiate_js])

    command = ["/usr/bin/mongo", "admin", "--eval", "result = db.isMaster().ismaster; printjson(result);"]
    attempt_count = 0
    response_text = ""
    while "true" not in response_text:
        log_message('Waiting to become master')
        p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        response_text = p.stdout.read()
        retcode = p.wait()
        attempt_count += 1
        time.sleep(5)
        if attempt_count > 12:
            log_message("Failed to become master after 60 seconds", 'error')
            sys.exit(1)


def create_schema(admin_username, admin_password):

    admin_create_js = "db.createUser({user: '{}', pwd: '{}', roles: " \
                      "[ 'root', 'userAdminAnyDatabase' ]});".format(
        admin_username, admin_password
    )

    log_message('Creating admin user')
    call(["/usr/bin/mongo", "admin", "--eval", admin_create_js])

    if os.getenv('MONGO_ONE_NODE', 'False') != 'True':
        readFile = open("/etc/hosts")
        lines = readFile.readlines()
        readFile.close()
        w = open("/etc/hosts", 'w')
        w.writelines([item for item in lines[:-1]])
        w.close()

    suffix = 1
    while os.getenv('MONGO_USER_' + str(suffix), 'None') != 'None':
        user_create_params = os.getenv('MONGO_USER_' + str(suffix)).split('|')
        call(["/opt/create_user.py", "-d", user_create_params[0], "-u", user_create_params[1], "-p",
              user_create_params[2], "-r", user_create_params[3]])
        suffix += 1

    suffix = 1
    while os.getenv('MONGO_INDEX_' + str(suffix), 'None') != 'None':
        index_create_params = os.getenv('MONGO_INDEX_' + str(suffix)).split('|')
        call(["/opt/reindex_database.py", "-d", index_create_params[0], "-c", index_create_params[1], "-i",
              index_create_params[2]])
        suffix += 1


# We sit and poll to see if mongod search has started, if not, wait 30 seconds and try again
while True:
    log_message("mongod has not started, waiting {} seconds."
                .format(sleep_timeout))
    time.sleep(sleep_timeout)
    res = subprocess.Popen(["/usr/bin/sv", "status", "mongod"]
                           , stdout=subprocess.PIPE
                           )

    if any(mongod_running in item for item in res.stdout.readlines()):
        log_message("Mongod is running")
        host_ip, rs_hosts, admin_username, admin_password = get_mongo_params()
        init_mongo(rs_hosts, host_ip)
        create_schema(admin_username, admin_password)
        logfile.close()
        exit(0)
