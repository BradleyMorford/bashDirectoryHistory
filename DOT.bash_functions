# Many years ago I was working in the Korn Shell and used a cd history function, which kept a list of working directories.
# I have changed it to work in the bash shell, December 2023, enjoy Bradley Morford
#
# 1) Put this file (DOT.bash_functions) in your home directory. Then rename it to ${HOME}/.bash_functions
# 2) Put the following in the bottom of your $HOME/.bashrc file:
#       # Set up directory for history file, the function will create the file if it does not exist
#           export CDHISTFILE=${HOME}/.cdhist       # uncomment this line
#       # source bash functions
#           if [ -f ~/.bash_functions ]; then       # uncomment this line
#               . ~/.bash_functions                 # uncomment this line
#           fi                                      # uncomment this line    
#       # alias the cd command to run the cdh function
#           alias cd=cdh                            # uncomment this line 
#
# 3)USAGE:
#       cd -l    # show a list your directory history, the first time it will be empty otherwise it will show a numbered list of directories
#       cd -3    # cd to one of the numbered directories

function cdh
{
	typeset -i cdlen i
	typeset t
	if [ $# -eq 0 ]
	then
		set -- $HOME
	fi


    # if the CDHISTFILE file does not exist create it.
    if [ ! -f "$CDHISTFILE" ]; 
    then
        touch "$CDHISTFILE"
    fi

    # create a numbered list of all the directories in the CDHISTFILE file
	if [ "$CDHISTFILE" ]
	then
		typeset CDHIST
		i=-1
		while read -r t
		  do
   			CDHIST[i=i+1]=$t
		  done <$CDHISTFILE
	fi

    # if the current directory does not appear in the list, insert it into the list.
	if [ "${CDHIST[0]}" != "$PWD" -a "$PWD" != "" ]
	then
		_cdins
	fi

    # set the length of the history list
	cdlen=${#CDHIST[*]}

    # check command line arguments

	case "$@" in
	-)
	 	if [ "$OLDPWD" = "" ] && ((cdlen>1))
		then
			'printf' "${CDHIST[1]}\n"
			'cd' ${CDHIST[1]}
			_pwd
		fi
		;;
	-l)
        #list the history to the terminial
		typeset -i num  
		((i=cdlen))
		while (((i=i-1)>=0))
		do
			num=$i
			'printf' "$num ${CDHIST[i]}\n"
		done
		return
		;;
	-[0-9]|-[0-9][0-9])	
        # change directory to the one represented by a number from the history list on the terminal...
		if (((i=${1#-})<cdlen))
		then
			'printf' "${CDHIST[i]}\n"
			'cd' ${CDHIST[i]}
			_pwd
		else
			'cd' $@
			_pwd
		fi
		;;
	*)
		'cd' $@
		_pwd
		;;
	esac

    # insert dir into list
	_cdins

    # write unique directory list to history file
	if [ "$CDHISTFILE" ]
	then
		cdlen=${#CDHIST[*]}
		i=0
		while ((i<cdlen))
		do
			# changed to printf from print
			'printf'  "${CDHIST[i]}\n"
			((i=i+1))
		done >$CDHISTFILE
	fi
}

# --------------------  Insert unique directory into CDHIST list --------------------
function _cdins
{
	typeset -i i
	((i=0))
	while ((i<${#CDHIST[*]}))
	do
		if [ "${CDHIST[$i]}" = "$PWD" ]
		then
			break
		fi
		((i=i+1))
	done

    # hard coded max length for number of history lines to 22 to fit most terminals...
	if ((i>22))
	then
		i=22
	fi

	while (((i=i-1)>=0))
	do
		CDHIST[i+1]=${CDHIST[i]}
	done

	CDHIST[0]=$PWD
}

# --------------------------- Check if the the error code for the cd command, currently have not changed this but it still works....
function _pwd
{
    ### if [ $? -gt 0 ] then echo "bad cmd: $?\n"
	if [ -n "$ECD" ]
	then
		pwd 1>&6
	fi
}
