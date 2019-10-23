#! /bin/bash

virtualenv venv

source venv/bin/activate

pip3 install -r requirements.txt

printf "To run:\nsource venv/bin/activate\n"
