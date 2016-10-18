#!/bin/sh

git pull
swift build --configuration release
sudo stop UncleLucioServer
sudo start UncleLucioServer
