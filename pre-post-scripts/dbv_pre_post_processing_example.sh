#!/bin/bash
case ${1} in
	pre)
	echo "Start Pre Processing"
	case ${2} in
		1)
		echo "Primary Database Send"
		# custom code here 
		;;
		2)
		echo "Standby Database Apply"
		# custom code here 
		;;
		3)
		echo "Primary Server Graceful Switchover"
		# custom code here 
		;;
		4)
		echo "Standby Server Graceful Switchover"
		# custom code here 
		;;
		5)
		echo "Standby Database Activate"
		# custom code here 
		;;
		6)
		echo "Standby Database Read-Only"
		# custom code here 
		;;
	esac
;;
	post)
	echo "Start post Processing"
	case ${2} in
		1)
		echo "Primary Database Send"
		# custom code here
		;;
		2)
		echo "Standby Database Apply"
		# custom code here
		;;
		3)
		echo "Primary Server Graceful Switchover"
		# custom code here
		;;
		4)
		echo "Standby Server Graceful Switchover"
		# custom code here
		;;
		5)
		echo "Standby Database Activate"
		# custom code here
		;;
		6)
		echo "Standby Database Read-Only"
		# custom code here
		;;
	esac
	;;
esac
