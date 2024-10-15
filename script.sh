#!/bin/bash
set -e


# Hi! Please do not modify the above lines.
# 
# remember that lines starting with a # are *comments*
#
# Here is a list of tasks for you.

# 0. Tell me who worked on this together
echo Henrik Berger
echo Paula Burbano

# 1. Go to your home directory: 
# (enter your command below)
#cd ~/Documents/SP_M1/PROGRAM/

# 2. from your home, creating a directory structure: new folder `scpoprogramming`, and inside that folder create folder `hw1`
# (enter your command below)
#mkdir scpoprogramming
#cd ~/Documents/SP_M1/PROGRAM/scpoprogramming/
#mkdir hw1


# 3. go into that new directory, i.e. into ~/scpoprogramming/hw1
# (enter your command below)
cd ~/Documents/SP_M1/PROGRAM/scpoprogramming/hw1/

# 4. download with wget if file does not exist yet
# if wget does not work for you, manually download from the below URL and place into `~/scpoprogramming/hw1` as `movies.dat`
# (don't touch the following!)
if [ ! -f  ~/Documents/SP_M1/PROGRAM/scpoprogramming/hw1/ ]; then
    echo ""
    echo "File not found in ~/scpoprogramming/hw1 !"
    echo "will download now to ~/scpoprogramming/hw1 directory now\n"
    echo ""
    wget https://raw.githubusercontent.com/sidooms/MovieTweetings/44c525d0c766944910686c60697203cda39305d6/snapshots/10K/movies.dat -O ./movies.dat
fi

# check file exists now
# (don't touch)
if [ ! -f  movies.dat ]; then
    echo "File not found! Error."
    exit 1
fi

# 5. look at first 4 rows of downloaded data in `movies.dat`
# (enter your command below)
head -n 4 movies.dat

# actual analysis task: A pipeline
# we want to know how many genres each movie is classified into
# `genre1|genre2` means it's in genre1 and genre2: we would count `2` for such an entry
# the end product of our pipeline is a contingency table, like in class, informing us
# about how many movies are part of how many genres. it would look similar to
#  2 0
#  5 1
# 10 2
# meaning we have 2 movies without any genre, 5 movies with 1, 10 with 2, etc
 
# I want you to construct a pipeline. let's build it up from the start

# 1. use the `awk` command to separt each row at the `::` delimters
# fill in for _filename_ the correct file you want to operate on. 
# then remove the # character from the start of the line and look at the result
#awk '{split($0, a, "::"); for(i=1; i<=length(a); i++) printf a[i] " "; print ""}' movies.dat > movies_new.dat

awk -F '::' '{print $3}' movies.dat
# Crime|Drama
# Comedy|Short
# Short|Comedy|Drama|Romance
# Comedy|Drama|Family
# Documentary

# 2. observe that the `{print $3}` part prints the third field. 
# that looks like: genre1|genre2
# that is, there is *another* separator in this column, `|`. 
# Let's separate again. copy your command from above and 
# add a pipe as follows: here, the second statement will split at `|` and print into *how many parts* it has split.
# i.e. it will tell us *how many genres* that movie belonged to. No need to understand the `awk` part.
# again, remove the # below, fill in for _filename_ and run


# awk -F '::' '{print $3}' _filename_ | awk '{print split($0, a, "\\|")}'
awk -F '::' '{print $3}' movies.dat | awk '{print split($0, a, "\\|")}'


# or
#awk '{split($0, a, "::"); for(i=1; i<=length(a); i++) printf a[i] " "; print ""}' movies.dat | awk '{id=$1; title=$2 " " $3; year=$4; split($5, genres, "|"); printf "%s %s %s ", id, title, year; for(i=1; i<=length(genres); i++) printf "%s ", genres[i]; print ""}' > movies_new2.dat

# head -n 10 movies_new2.dat
# 0002844 Fantômas - À l'ombre 
# 0007264 The Rink (1916) Comedy Short 
# 0008133 The Immigrant (1917) Short Comedy Drama Romance 
# 0012349 The Kid (1921) Comedy Drama Family 
# 0013427 Nanook of the North 
# 0014142 The Hunchback of Notre 
# 0014538 Three Ages (1923) Comedy 
# 0014872 Entr'acte (1924) Short 


# or
#awk -F '::' '{id=$1; title=$2; split($3, genres, "\\|"); printf "%s %s %d\n", id, title, length(genres)}' movies.dat > movies_new3.dat


# head -n 10 movies_new3.dat
# 0002844 Fantômas - À l'ombre de la guillotine (1913) 2
# 0007264 The Rink (1916) 2
# 0008133 The Immigrant (1917) 4
# 0012349 The Kid (1921) 3
# 0013427 Nanook of the North (1922) 1
# 0014142 The Hunchback of Notre Dame (1923) 2
# 0014538 Three Ages (1923) 1
# 0014872 Entr'acte (1924) 1



# 3. finish the pipeline by adding 2 commands, exactly like in class, that will produce a contingency table
# we want to know how many movies belong to 0,1,2,... etc genres. 

# awk -F '::' '{print $3}' _filename_ | awk '{print split($0, a, "\\|")}' | sort | uniq -c
awk -F '::' '{print $3}' movies.dat | awk '{print split($0, a, "\\|")}' | sort | uniq -c movies.dat


#   14 0
#  551 1
#  928 2
#  929 3
#  493 4
#  150 5
#   26 6
#    5 7

# 4. redirect (>) the output of your pipeline to a file `outtable.txt` in the current directory
# (enter your command below: just copy from 3. above and add the redirect)
awk -F '::' '{print $3}' movies.dat | awk '{print split($0, a, "\\|")}' | sort | uniq -c > outtable.txt   



# 5. print your table to screen
echo ""   # don't touch
echo "here is my table:"   # don't touch

cat outtable.txt


#### End of your tasks
# please do not modify the below lines
echo ""
echo ""
echo "checking results...."
res=$(tail -n 1 outtable.txt | awk -F' ' '{print $1}')
if [ ${res} == 5 ] 
then
    echo "correct! :-)"
    exit 0
else
    echo "wrong result :-("
    exit 1
fi









