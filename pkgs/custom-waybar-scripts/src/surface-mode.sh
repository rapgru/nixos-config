#!/bin/bash

pmode=$(surface performance get -q)

if [[ -z "$1" ]]; then

if [[ "$pmode" -eq "1" ]]; then
  echo -n "{\"text\": \"$pmode\", \"alt\": \"$pmode\", \"tooltip\": \"Normal\", \"class\": \"surface-1\",\"percentage\": 25}"
elif [[ "$pmode" -eq "2" ]]; then
  echo -n "{\"text\": \"$pmode\", \"alt\": \"$pmode\", \"tooltip\": \"Battery Saving\", \"class\": \"surface-2\",\"percentage\": 50}"
elif [[ "$pmode" -eq "3" ]]; then
  echo -n "{\"text\": \"$pmode\", \"alt\": \"$pmode\", \"tooltip\": \"Better Performance\", \"class\": \"surface-3\",\"percentage\": 75}"
elif [[ "$pmode" -eq "4" ]]; then
  echo -n "{\"text\": \"$pmode\", \"alt\": \"$pmode\", \"tooltip\": \"Best Performance\", \"class\": \"surface-4\",\"percentage\": 100}"
fi

elif [[ "$1" == "increase" ]]; then

if [[ "$pmode" -eq "1" ]]; then
  sudo surface performance set 3
elif [[ "$pmode" -eq "2" ]]; then
  sudo surface performance set 1
elif [[ "$pmode" -eq "3" ]]; then
  sudo surface performance set 4
elif [[ "$pmode" -eq "4" ]]; then
  sudo surface performance set 2
fi

elif [[ "$1" == "decrease" ]]; then

if [[ "$pmode" -eq "1" ]]; then
  sudo surface performance set 2
elif [[ "$pmode" -eq "2" ]]; then
  sudo surface performance set 4
elif [[ "$pmode" -eq "3" ]]; then
  sudo surface performance set 1
elif [[ "$pmode" -eq "4" ]]; then
  sudo surface performance set 3
fi
#sleep 0.1

fi
