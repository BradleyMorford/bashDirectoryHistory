# Many years ago I was working in the Korn Shell, circa 1990, and used a cd history function, which kept a list of working directories.
# I am not sure of the original author.
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
#       cd -l    # ("minus L" lower case) show a list your directory history, the first time it will be empty otherwise it will show a numbered list of directories.
#       cd -3    # cd to one of the numbered directories
