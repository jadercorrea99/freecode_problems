#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ SALON $ STYLE ~~~~~"
echo -e "\nWelcome to SALON $ STYLE, It's a plesure for us to having you.\nHow can we help you today? Select one of the following options:"

SELECT_SERVICE () {
  LIST_SERVICES () {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  # Show services
    SERVICES=$($PSQL "SELECT service_id, name FROM services") 
    echo "$SERVICES" | while read SERVICE_ID BAR NAME
    do
      echo  "$SERVICE_ID) $NAME"
    done
  }
  LIST_SERVICES
    read SERVICE_ID_SELECTED
    if [[ -z $SERVICE_ID_SELECTED || ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then 
      echo "It's not a valid option"
      SELECT_SERVICE
    else
    # if it's a valid option
    SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    ID_FORMATTED=$(echo $SERVICE_ID | sed -E 's/^ *| *$//g')
      if [[ $SERVICE_ID_SELECTED == $ID_FORMATTED ]]
      then
        SERVICE_SELECTED=$($PSQL "SELECT name from services WHERE service_id = $ID_FORMATTED")
        SERVICES_FORMATTED=$(echo $SERVICE_SELECTED | sed -E 's/^ *| *$//g')
        echo -e "\nYou have selected the option *$SERVICES_FORMATTED* from the menu"
      else
        echo "It's not a valid option"
        SELECT_SERVICE
      fi
    # identify the client with the phone number
      echo -e "\nWhats' your phone number?"
    # Read selected option
      read CUSTOMER_PHONE
    # if phone is empty
      if [[ -z $CUSTOMER_PHONE ]]
      then 
        echo -e "\nenter a valid number" 
        SELECT_SERVICE 
      else
        CUSTOMER_NAME_DATABASE=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        # Verify if the client existe in the database with the phone Number
        if [[ -z $CUSTOMER_NAME_DATABASE ]]
        then  
          echo -e "\nWhat's your name?"
          read CUSTOMER_NAME
        # If name is empty
          if [[ -z $CUSTOMER_NAME ]]
          then
            echo -e"\nYou have no enter a valid input"
            SELECT_SERVICE 
          else
            echo -e "\nWhat time would you like your $SERVICES_FORMATTED, $CUSTOMER_NAME?" 
            read SERVICE_TIME 
            # If service time is empty
            if [[ -z $SERVICE_TIME ]]
            then
              echo -e"\nYou have no enter a valid input"
              SELECT_SERVICE
            else
            # Insert info in customers table
              INSERT_INTO_CUSTOMERS=$($PSQL "INSERT INTO customers (phone,name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
            # get customer id
              CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
            # Insert appointment info
              INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id,service_id,time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
              echo -e "\nI have put you down for a $SERVICES_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME."
            fi     
          fi
        else
        # get customer id
          CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
          CONSULT_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
          NAME_FORMATTED=$(echo "$CONSULT_CUSTOMER_NAME" | sed -E 's/^ *| *$//g')
          echo -e "\nWhat time would you like your $SERVICES_FORMATTED, $NAME_FORMATTED?"
          read SERVICE_TIME
        # If service time is empty
          if [[ -z $SERVICE_TIME ]]
          then
            echo -e"\nYou have no enter a valid input"
            SELECT_SERVICE
          else
          # Insert appointment info
            INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id,service_id,time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
            echo -e "\nI have put you down for a $SERVICES_FORMATTED at $SERVICE_TIME, $NAME_FORMATTED."
          fi
        fi
      fi
    fi
}

SELECT_SERVICE
    
  

  