#!/usr/bin/env bash

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=3.4.0
fi
PYTHON_SRC=Python-$VERSION.tgz
PYTHON_DIR=${PYTHON_SRC%.tgz}
INSTALL_DIR=$HOME/python3

if [ ! -f $PYTHON_SRC ]
then
  wget http://www.python.org/ftp/python/$VERSION/$PYTHON_SRC
fi

sudo yum -y install readline readline-devel expat expat-devel openssl openssl-devel bzip2 bzip2-devel libcurl libcurl-devel gdbm gdbm-devel sqlite sqlite-devel mysql mysql-devel

if [ -d $PYTHON_DIR ]
then
  rm -rf $PYTHON_DIR
fi
tar zxf $PYTHON_SRC

cd $PYTHON_DIR
./configure --prefix=$INSTALL_DIR
make
make install

wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -O - | $INSTALL_DIR/bin/python3
wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py -O - | $INSTALL_DIR/bin/python3

mkdir -p $HOME/bin
cd $HOME/bin
ln -sf ../python3/bin/python3 ./
ln -sf ../python3/bin/pip3 ./
