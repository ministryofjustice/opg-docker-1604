#!/bin/bash

for i in * ;do
  if [ -d $i ]; then
    echo "Testing $i"; 
		(
		  cd $i
      make rebuild
		  make test | tee -a /tmp/test.log
		)
  fi
done
