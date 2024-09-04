#!/bin/bash

echo "### Gathering GPU Information ###"

# Check GPU details
echo "GPU Details:"
sudo lshw -C display

# Check GPU driver version
echo "GPU Driver Version:"
glxinfo | grep "OpenGL version"

# Check GPU performance (run glxgears for a quick test)
echo "Running glxgears for a quick performance test..."
glxgears

echo "### GPU Information Gathering Completed ###"

