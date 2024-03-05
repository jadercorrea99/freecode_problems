#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WIN OPP WIN_G OPP_G

do
  # GET DISTINCT WIN TEAM
  if [[ $WIN != winner ]]
  then
  INSERT_WIN_TEAM=$($PSQL "INSERT INTO teams (name) SELECT DISTINCT '$WIN' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$WIN' )")
  echo $INSERT_WIN_TEAM
  fi
  # INSERT OPP TEAM
  if [[ $OPP != opponent ]]
  then
  INSERT_OPP_TEAM=$($PSQL "INSERT INTO teams (name) SELECT DISTINCT '$OPP' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$OPP' )")
  echo $INSERT_OPP_TEAM
  fi
  #insertar valores en games
  if [[ $YEAR != year ]] 
  then
    #get_winner_id AND opponetn_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
    #INSERT DATA
    INSERT_DATA_GAME=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR,'$ROUND','$WINNER_ID','$OPPONENT_ID',$WIN_G,$OPP_G)")
    echo $INSERT_DATA_GAME
    if [[ $INSERT_DATA_GAME == "INSERT 0 1" ]]
    then 
      echo "INSERT INTO GAMES year, round, winner_id, opponent_id, winner_goals, opponent_goals"
    fi
  fi

done

