#!/bin/bash

#create file junit.csv
echo "st1,st2,st3,st4,st5,st6,st7" >junit.csv

# loop 30 times
for i in {1..5}; do
  rm -r results
  npm run cy:run-junit
  npm run cy:merge-junit
  line=$(sed -n '/register new user/p' results/junit.xml)
  st1=$(echo $line | sed -n 's/.*time="\([^"]*\).*/\1/p')
  line=$(sed -n '/login to account/p' results/junit.xml)
  st2=$(echo $line | sed -n 's/.*time="\([^"]*\).*/\1/p')
  line=$(sed -n '/create new post/p' results/junit.xml)
  st3=$(echo $line | sed -n 's/.*time="\([^"]*\).*/\1/p')
  line=$(sed -n '/edit existing post/p' results/junit.xml)
  st4=$(echo $line | sed -n 's/.*time="\([^"]*\).*/\1/p')
  line=$(sed -n '/delete existing post/p' results/junit.xml)
  st5=$(echo $line | sed -n 's/.*time="\([^"]*\).*/\1/p')
  line=$(sed -n '/like existing post/p' results/junit.xml)
  st6=$(echo $line | sed -n 's/.*time="\([^"]*\).*/\1/p')
  line=$(sed -n '/logout from session/p' results/junit.xml)
  st7=$(echo $line | sed -n 's/.*time="\([^"]*\).*/\1/p')
  echo -e "$st1,$st2,$st3,$st4,$st5,$st6,$st7" >>junit.csv
done
