#!/usr/bin/python
import os
import sys

# Virtualenv settings
activate_this = '/var/www/helloworld/venv/bin/activate_this.py'
with open(activate_this) as file_:
  exec(file_.read(), {'__file__': activate_this})

sys.stdout = sys.stderr

sys.path.append('var/www/helloworld')
from server import app as application