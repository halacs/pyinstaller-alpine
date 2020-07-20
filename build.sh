#!/bin/bash

#export http_proxy='http://10.144.1.10:8080/'
#export https_proxy='https://10.144.1.10:8080/'
docker build --network host -t alpine-pyinstaller .

