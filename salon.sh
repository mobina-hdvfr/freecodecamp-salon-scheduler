#!/bin/bash
# PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

# echo -e "\n~~~~~ MY SALON ~~~~~\n"

# echo -e "Welcome to My Salon, how can I help you?\n"

# service_menu(){
#   if [[ ! -z $1 ]]
#   then
#     echo -e "\n$1"
#   fi

#   $PSQL "select * from services order by service_id" | while IFS='|' read s_id s_name
#   do
#     echo "$s_id) $s_name"
#   done
# }

# # service menu
# service_menu

# # user input
# while [[ $service != 'exit' ]]
# do 
#   read user_service_id
#   service=$($PSQL "select name from services where service_id=$user_service_id")

#   # if service doesn't exist
#   if [[ -z $service ]]
#   then
#     service_menu 'I could not find that service. What would you like today?'
#   else
#     # get phone number
#     echo -e "\nWhat's your phone number?"
#     read phone
#     customer_id=$($PSQL "select customer_id from customers where phone='$phone'")

#     # if user doesn't exist
#     if [[ -z $customer_id ]]
#     then
#       echo -e "\nI don't have a record for that phone number, what's your name?"
#       read name
#       insert_customer=$($PSQL "insert into customers (phone, name) values ('$phone', '$name')")
#       customer_id=$($PSQL "select customer_id from customers where phone='$phone'")
#     fi

#     name=$($PSQL "select name from customers where phone='$phone'")
#     echo -e "\nWhat time would you like your $service, $name?"
#     read user_time

#     echo -e "\nI have put you down for a $service at $user_time, $name."
    
#   fi

# done

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICES=$($PSQL "select service_id, name from services order by service_id")
  echo "$SERVICES" | while IFS='|' read SERVICE_ID NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "select name from services where service_id='$SERVICE_ID_SELECTED'")

  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")

    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      $PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')" > /dev/null
    fi

    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")

    echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME

    $PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')" > /dev/null

    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU