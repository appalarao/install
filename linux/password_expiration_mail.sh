currentdate=`date +%s`

# find expiration date of user
userexp=`chage -l postgres |grep 'Password expires' |cut -d: -f2`

# convert expiration date to seconds
passexp=`date -d "$userexp" +%s`

# find the remaining days for expiry
exp=`expr $passexp - $currentdate `

# convert remaining days from sec to days
expday=`expr $exp / 86400 `

if [ $expday -le 7 ] ; then

        #echo "hi"

	(
	echo "From: srihari@indiamart.com "
	echo "To: srihari@indiamart.com,dba@indiamart.com,anujs@indiamart.com,ankur.lakwhan@indiamart.com,prashant.singh@indiamart.com,rohitarora@indiamart.com"
	echo "MIME-Version: 1.0"
	echo "Subject: postgres-user password expiration mail of enq-pg slave node"
	echo "password will expire on $userexp "
	echo "Please do the necessary action"
	) | /sbin/sendmail -t

fi



/backup/tbd/mail.sh
