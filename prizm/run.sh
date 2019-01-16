#!/bin/bash

# docker run -p 18001:18001 -p 18681:18681 -p 18682:18682 --rm -it --name prizm prizmdocker-ubuntu16.04:latest
# docker run -p 18001:18001 -p 18681:18681 -p 18682:18682 -it --name prizm prizm:ubuntu16.04
docker run -p -p 18001:18001 -p 18681:18681 -p 18682:18682 -it --name prizm prizm:ubuntu16.04
