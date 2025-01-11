 lppwd521: Available Virtual Storage is low. The percentage
of available virtual storage is 12 percent. 3186.00 page
outs to disk per second.

Essa  de swap:

 We've been conducting an extensive investigation on this problem and we are discussing what measures will be taken to stop this problem from happening. 
The gathered info so far: 
- The cached memory from OS is allocated pretty much to the db writer processes wich indicates a high volume of cached I/O. 
- The allocated memory is not preventing any feature n the hosts from the normal functions.
- App team have stated it was not affecting their application on all 20 last recurrences, hence we have started a DPP for this.
- We have already multiple service lines engaged on this investigation, for the update on this please contact oraclebr@br.ibm.com we will answer in 24 hours.
- In case of ANY emergency you can 

fechar dessa forma
==================================================================================================================
PROFILE DO ANDR NA AMEX:

$ more .profile
#       This is the default standard profile provided to a user.
#       They are expected to edit it to meet their own needs.

MAIL=/usr/mail/${LOGNAME:?}

# LDAP-PROF: .profile update for Linux users using ksh and having .profile
# This adds /bin to the environment PATH as ksh on Linux breaks if there is a .profile
if [ `uname -s` = "Linux" ]
then
  PATH=/bin:$PATH:/data/gleodbd/admin/scripts/
  export PATH
fi

stty columns 120
alias oracle='/usr/local/bin/pbrun /bin/su - oracle'
=================================================================================================

find . -mtime +90 -exec /bin/rm {} \;

