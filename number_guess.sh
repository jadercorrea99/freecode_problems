#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

while [[ -z $NAME ]]; do
    echo "Enter your username:"
    read NAME
done

# Remove spaces and convert to lowercase
NAME_CLEAN=$(echo "$NAME" | sed 's/ //g' )

# Check if the username exists in the database
USERNAME=$($PSQL "SELECT username FROM users WHERE username='$NAME_CLEAN'")

if [[ $NAME_CLEAN != $USERNAME ]]; then
    echo "Welcome, $NAME_CLEAN! It looks like this is your first time here."
    INSERT_USERNAME_USERTABLE=$($PSQL "INSERT INTO users (username) VALUES ('$NAME_CLEAN')")
else
    # Display stats for returning users
    USERNAME_ID=$($PSQL "SELECT user_id FROM users WHERE username='$NAME_CLEAN'")
    GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM user_number WHERE user_id=$USERNAME_ID")
    BEST_GAME=$($PSQL "SELECT MIN(number_guess) FROM user_number WHERE user_id=$USERNAME_ID")
    echo "Welcome back, $NAME_CLEAN! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"
RANDOM_NUMBER=$((RANDOM % 1000 + 1))
INSERT_RANDOM_NUMBER=$($PSQL "INSERT INTO numbers (number_generated) VALUES ($RANDOM_NUMBER)")
USERNAME_ID=$($PSQL "SELECT user_id FROM users WHERE username='$NAME_CLEAN'")
NUMBER_ID=$($PSQL "SELECT number_id FROM numbers WHERE number_generated=$RANDOM_NUMBER")
TRIES=0

while [[ true ]]; do
    read USER_NUMBER

    if [[ ! $USER_NUMBER =~ ^[0-9]+$ ]]; then
        echo "That is not an integer, guess again:"
    else 
        TRIES=$(($TRIES + 1))

        if [[ $USER_NUMBER -lt $RANDOM_NUMBER ]]; then
            echo "It's higher than that, guess again:"
        elif [[ $USER_NUMBER -gt $RANDOM_NUMBER ]]; then
            echo "It's lower than that, guess again:"
        else 
            echo "You guessed it in $TRIES tries. The secret number was $RANDOM_NUMBER. Nice job!"
            INSERT_INFO_GAME=$($PSQL "INSERT INTO user_number (number_guess, user_id, number_id) VALUES ($TRIES, $USERNAME_ID, $NUMBER_ID)")
            break
        fi
    fi  
done
