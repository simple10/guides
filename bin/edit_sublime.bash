#!/bin/bash

# INSTALL: put this file in ~/bin/edit and add ~/bin to PATH
# DESCRIPTION: edit intelligently opens files or dirs in Sublime Text 

# if no arguments, look for .sublime-project and open it
if [ "$#" -eq "0" ] ; then
  for file in *.sublime-project
  do
    if [ -f $file ] ; then
      # if no arguments, find if there is a project file in the current directory
      filename="${file%.*}"
      echo "Opening project: $filename"
      subl -n $file &
    else
      # if no project file, just open the current directory
      echo "Opening current directory"
      subl -n . &
    fi
  done
else
  # if arguments given, run as normal
  echo "Opening with 'subl $@'"
  subl "$@"
fi

exit 0
