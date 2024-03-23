#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  #IF $1 IS A NUMBER RELATED TO ATOMIC_NUMBER
  if [[ $1 =~ ^[0-9]$ ]]
  then
    ATOMIC=$1
    NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ATOMIC")
    if [[ $ATOMIC = $NUMBER ]]
    then
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC")
      TYPE=$($PSQL "SELECT type FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id)WHERE atomic_number=$ATOMIC")
      MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id)WHERE atomic_number=$ATOMIC")
      MELTING=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id)WHERE atomic_number=$ATOMIC")
      BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id)WHERE atomic_number=$ATOMIC")
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    else
     echo "I could not find that element in the database."
    fi
  else
  #IF $1 IS A TEXT RELATED TO SYMBOL OR NAME
    ELEMENT=$1
    NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ELEMENT' or symbol='$ELEMENT'")
    if  [[ $NUMBER ]]
    then
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$NUMBER")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$NUMBER")
      TYPE=$($PSQL "SELECT type FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id)WHERE atomic_number=$NUMBER")
      MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id)WHERE atomic_number=$NUMBER")
      MELTING=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id)WHERE atomic_number=$NUMBER")
      BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id)WHERE atomic_number=$NUMBER")
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    else
      echo "I could not find that element in the database."
    fi
  fi
else
  echo -e "Please provide an element as an argument."
fi
