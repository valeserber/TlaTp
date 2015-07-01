#!/bin/bash
COMPILER=$1
FILE=$2

if [ -f $FILE ];
then
	$COMPILER < $FILE > VSClass.java
	javac VSClass.java
else
	echo "File $FILE does not exist."
fi
