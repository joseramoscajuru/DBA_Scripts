To kill all processes of a specific user, enter:

    # ps -u [user-id] -o pid | grep -v PID | xargs kill -9

Another way is to use who to check out your current users and their terminals. Kill all processes related to a specific terminal:

    # fuser -k /dev/pts[#]

Yet another method: Su to the user-id you wish to kill all processes of and enter:

    # su - [user-id] -c kill -9 -1