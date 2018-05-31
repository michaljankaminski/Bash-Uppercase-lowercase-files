#!/bin/bash

#making files
current=$PWD

mkdir Small1Folder
mkdir BIGfOLDER2
mkdir lotofTtttT

mkdir abc
mkdir xyz
mkdir ddE

touch ttTttMm.txt
touch testfile.txt
touch testfile2.txt
touch testfile3.txt
touch TEST.txt
touch anothersmallfile.txt
cd Small1Folder
	touch anotherfile.txt
	mkdir AndsmallAgain1
	cd AndsmallAgain1
		touch Test.txt
		cd $current
	cd BIGfOLDER2
	mkdir ANDBIG
	cd ANDBIG
	touch BIG.txt
	cd $current
cd lotofTtttT
	touch anothert.txt
	cd $current
cd abc
	touch file1.txt
	cd $current
cd xyz	
	touch file2.txt

