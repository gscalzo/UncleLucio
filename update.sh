#!/bin/sh

git pull
#swift build --configuration release
swift build 
sudo stop UncleLucioServer
sudo start UncleLucioServer
