__author__ = 'charlie'

import socket

def get_hostname():
    """Gets the system FQHN"""
    return socket.gethostname()