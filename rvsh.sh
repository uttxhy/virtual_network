#!/bin/bash


# Function


function printSyntaxError {
	echo 'Syntax Error:'
	echo 'rvsh -c [--connect] machine_name user_name: connect an user to a machine'
	echo 'rvsh -a [--admin]: connect to admin'
}


function printFileError {
	echo 'File Error:'
	echo 'Make sure files admin, connect, log, users, machine are in the respertory!'
}


function adminLogin {
# $1: userName $2:machine to connect
	flag=flase

	while read login level password;
	do
		if [[ $login == $1 ]] && [[ $level == 0 ]] && [[ $password == $2 ]]
		then
			flag=true
			break
		fi
	done < users


	if [ $flag == true ]
	then
		echo 'Login admin successful'
		echo 'Hello admin'
		sleep 2
		clear
		./admin $1
	else
		echo 'login error or password error!'
		exit
	fi

}


# Main

if [ ! -f admin ] || [ ! -f connect ] || [ ! -f ./tables/User ] 
then
	printFileError
else
	if [[ $1 == '--admin' ]] || [[ $1 == '-a' ]]; then

		#statements
		echo 'Mode Admin:'
		echo 'Password of admin:'
		read -s password
		echo 'Wait...'
		adminLogin 'admin' $password

	elif [[ $1 == '--help' ]] || [[ $1 == '-h' ]]; then
		echo 'help....'
	elif [[ $1 == '--connect' ]] || [[ $1 == '-c' ]] && [[ $# -eq 3 ]]; then

		#statements
		while read userName machineName
		do
			if [[ $userName == $3 ]] && [[ $machineName != $2 ]]; then
				flag=true
				echo "User $3 has already connected to $machineName, one user cannot connect two machines at the same time!"
				exit			
			fi
		done < ./tables/User_Machine

		echo "Mode Connect: connect to $2"
		echo "Password of $3:"
		read -s password
		echo 'Wait...'
		./connect $3 $2 $password
	else
		printSyntaxError
	fi

fi
