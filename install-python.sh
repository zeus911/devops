#!/usr/bin/env bash

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=2.7.5
fi
PYTHON_SRC=Python-$VERSION.tgz
PYTHON_DIR=${PYTHON_SRC%.tgz}
INSTALL_DIR=$HOME/python

if [ ! -f $PYTHON_SRC ]
then
  wget http://www.python.org/ftp/python/$VERSION/$PYTHON_SRC
fi

sudo yum -y install readline readline-devel openssl openssl-devel bzip2-devel mysql-devel

if [ -d $PYTHON_DIR ]
then
  rm -rf $PYTHON_DIR
fi
tar zxf $PYTHON_SRC

cd $PYTHON_DIR
./configure --prefix=$INSTALL_DIR
make
make install

wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -O - | $INSTALL_DIR/bin/python
curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
$INSTALL_DIR/bin/python get-pip.py

$INSTALL_DIR/bin/pip install virtualenv

mkdir -p $HOME/bin
cd $HOME/bin
ln -sf ../python/bin/python python
ln -sf ../python/bin/pip pip
ln -sf ../python/bin/virtualenv virtualenv
