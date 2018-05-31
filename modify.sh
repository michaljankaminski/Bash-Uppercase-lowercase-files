#!/bin/bash

if [ "$#" -lt 2 ]
then
	if [ "$#" == 1 ] && [ "$1" == "-h" ]
	then
		echo ">Possible parameters:"
		echo "-u"
		echo ">Uppercase file name, example:"
		echo ".modify -u filename.txt"
		echo "-l"
		echo ">Lowercase file name, example:"
		echo "modify -l filename.txt"
		echo "-sed"
		echo ">Change filename/directory according to sed parameters"
		echo ">Sed parameters must be just after the -sed, for example"
		echo "modify -sed s/t/T/g filename.txt"
		echo "-r"
		echo ">Stands for recursive usage, only usable with other parameter like -u" 			
		exit
	fi

	echo "Not enough arguments passed to the script - $#"
	exit 1
fi
sedflag=0
rec=0
upper=0
lower=0
# checking for parameters
for ((i = 1; i <= $# ; i++ )) 
do
	if [ "${!i}" == "-r" ]
	then
		rec=1
		echo "Recursive parameter detected"
	elif [ "${!i}" == "-u" ]
	then
		upper=1
		echo "Uppercase parameter detected"
	elif [ "${!i}" == "-l" ]
	then
		lower=1
		echo "Lowercase parameter detected"
	elif [ "${!i}" == "-sed" ]
	then
		sedflag=1
		echo "Sed parameter detected"
		i=$((i+1))
		sedpattern="${!i}"
	fi 
done
current=$PWD
#looking for files
for ((i = 1; i <= $# ; i++ )) 
do
	if [ -f ${!i} ] || [ -d ${!i} ]
	then
		echo "The path to the file for parameter $i is correct"
		NameOfFile=$(basename "${!i}")
		directory=$(dirname "${!i}")
		if [ $rec == 0 ]
		then
		n="${NameOfFile%.*}"
			if [ $upper == 1 ]
			then		
				n=$(tr '[:lower:]' '[:upper:]' <<< "$n")
				if [ "${NameOfFile#*.}" = "${NameOfFile%.*}" ]
				then
					if [ -f $directory/${NameOfFile^^} ] || [ -d $directory/${NameOfFile^^} ]
					then
						echo "Such file exist"
					else
						mv "${!i}" "$directory/${NameOfFile^^}"
					fi
					
				else
					f="$n.${NameOfFile#*.}"
					if [ -f $directory/$f ] || [ -d $directory/$f ]
					then
						echo "Such file exist"
					else
						mv "${!i}" "$directory/$f"
					fi
					
				fi

			elif [ $lower == 1 ]
			then
				n=$(tr '[:upper:]' '[:lower:]' <<< "$n")
				if [ "${NameOfFile#*.}" = "${NameOfFile%.*}" ]
				then
					if [ -f $directory/${NameOfFile,,} ] || [ -d $directory/${NameOfFile,,} ]
					then
						echo "Such file exist"
					else
						mv "${!i}" "$directory/${NameOfFile,,}"
					fi
					
				else
					f="$n.${NameOfFile#*.}"
					if [ -f $directory/$f ] || [ -d $directory/$f ]
					then
						echo "Such file exist"
					else
						mv "${!i}" "$directory/$f"
					fi
					
				fi
			elif [ $sedflag == 1 ]
			then
				n=$(sed "$sedpattern" <<< $n)
				if [ "${NameOfFile#*.}" = "${NameOfFile%.*}" ]
				then
					if [ -f $directory/$n ] || [ -d $directory/$n ]
					then
						echo "Such file exist"
					else
						mv "${!i}" "$directory/$n"
					fi
					
				else
					f="$n.${NameOfFile#*.}"
					if [ -f $directory/$f ] || [ -d $directory/$f ]
					then
						echo "Such file exist"
					else
						mv "${!i}" "$directory/$f"
					fi
				fi				
			else
				echo "Wrong arguments"
			fi

		elif [ $rec == 1 ]
		then
			ex="$directory"
			n="${NameOfFile%.*}"
			if [ $upper == 1 ]
				then	
				n=$(tr '[:lower:]' '[:upper:]' <<< "$n")
				if [ "${NameOfFile#*.}" = "${NameOfFile%.*}" ]
				then
					if [ -f $directory/${NameOfFile^^} ] 
					then
						echo "Such file exist"
					elif [ -f $directory/$NameOfFile ] 
					then
						mv "${!i}" "$directory/${NameOfFile^^}"	
					elif [ -d $directory/${NameOfFile^^} ] && [ "$NameOfFile" != "${NameOfFile^^}" ]
					then	
						echo "Such folder exist"						
					else
						if [ "$NameOfFile" != "${NameOfFile^^}" ]
						then
							mv "${!i}" "$directory/${NameOfFile^^}"	
						fi
						cd "$directory/${NameOfFile^^}"	
						find . -depth | \
						while read LONG 
						do
							NameOfFile=$( basename "$LONG")
							n="${NameOfFile%.*}"
							n=$(tr '[:lower:]' '[:upper:]' <<< "$n")
							if [ "${NameOfFile#*.}" = "${NameOfFile%.*}" ]
							then
								NameOfFile="${NameOfFile^^}"
							else
								f="$n.${NameOfFile#*.}"
								NameOfFile="$f"
							fi
							DIR=$( dirname "$LONG" )
							if [ "${LONG}" != "${DIR}/${NameOfFile}" ]  && [ "${LONG}" != "${DIR}/$0" ] && [ "${DIR}/${NameOfFile}" != "./." ]
							then
								mv "${LONG}" "${DIR}/${NameOfFile}"
							fi
						done
						cd $current
						
					fi

				else
					f="$n.${NameOfFile#*.}"
					if [ -f $directory/$f ] || [ -d $directory/$f ]
					then
						echo "Such file exist"
					else
						mv "${!i}" "$directory/$f"
					fi					
				fi


			elif [ $lower == 1 ]
				then
				n=$(tr '[:upper:]' '[:lower:]' <<< "$n")
				if [ "${NameOfFile#*.}" = "${NameOfFile%.*}" ]
				then
					if [ -f $directory/${NameOfFile,,} ] 
					then
						echo "Such file exist"
					elif [ -f $directory/$NameOfFile ] 
					then
						mv "${!i}" "$directory/${NameOfFile,,}"	
					elif [ -d $directory/${NameOfFile,,} ] && [ "$NameOfFile" != "${NameOfFile,,}" ]
					then	
						echo "Such folder exist"						
					else
						if [ "$NameOfFile" != "${NameOfFile,,}" ]
						then
							mv "${!i}" "$directory/${NameOfFile,,}"	
						fi
						cd "$directory/${NameOfFile,,}"	
						find . -depth | \
						while read LONG 
						do
							NameOfFile=$( basename "$LONG")
							n="${NameOfFile%.*}"
							n=$(tr '[:upper:]' '[:lower:]' <<< "$n")
							if [ "${NameOfFile#*.}" = "${NameOfFile%.*}" ]
							then
								NameOfFile="${NameOfFile,,}"
							else
								f="$n.${NameOfFile#*.}"
								NameOfFile="$f"
							fi
							DIR=$( dirname "$LONG" )
							if [ "${LONG}" != "${DIR}/${NameOfFile}" ]  && [ "${LONG}" != "${DIR}/$0" ] && [ "${DIR}/${NameOfFile}" != "./." ]
							then
								mv "${LONG}" "${DIR}/${NameOfFile}"
							fi
						done
						cd $current
						
					fi
				else
					f="$n.${NameOfFile#*.}"
					if [ -f $directory/$f ] || [ -d $directory/$f ]
					then
						echo "Such file exist"
					else
						mv "${!i}" "$directory/$f"
					fi
					
				fi


			elif [ $sedflag == 1 ]
				then
				n=$(sed "$sedpattern" <<< $n) 
				if [ "${NameOfFile#*.}" = "${NameOfFile%.*}" ]
				then
					if [ -f $directory/$n ] 
					then
						echo "Such file exist"
					elif [ -f $directory/$NameOfFile ] 
					then
						mv "${!i}" "$directory/$n"	
					elif [ -d $directory/$n ] && [ "$NameOfFile" != "$n" ]
					then	
						echo "Such folder exist"						
					else
						if [ "$NameOfFile" != "$n" ]
						then
							mv "${!i}" "$directory/$n"	
						fi
						cd "$directory/$n"	
						find . -depth | \
						while read LONG 
						do
							NameOfFile=$( basename "$LONG")
							n="${NameOfFile%.*}"
							n=$(sed "$sedpattern" <<< $n) 
							if [ "${NameOfFile#*.}" = "${NameOfFile%.*}" ]
							then
								NameOfFile="$n"
							else
								f="$n.${NameOfFile#*.}"
								NameOfFile="$f"
							fi
							DIR=$( dirname "$LONG" )
							if [ "${LONG}" != "${DIR}/${NameOfFile}" ]  && [ "${LONG}" != "${DIR}/$0" ] && [ "${DIR}/${NameOfFile}" != "./." ]
							then
								mv "${LONG}" "${DIR}/${NameOfFile}"
							fi
						done
						cd $current
						
					fi
				else
					f="$n.${NameOfFile#*.}"
					if [ -f $directory/$f ] || [ -d $directory/$f ]
					then
						echo "Such file exist"
					else
						mv "${!i}" "$directory/$f"
					fi
					
				fi				
			else
				echo "Wrong arguments"
			fi

		fi
	else 
		if [ "${!i}" != "-r" ] && [ "${!i}" != "-u" ] && [ "${!i}" != "-l" ] && [ "${!i}" != "-sed" ] && [ "${!i}" != "$sedpattern" ]
			then
			echo "The Path to the file is not correct"
		fi
	fi
done
exit
