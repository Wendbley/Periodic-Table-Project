#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"


if [[ $1 ]]
then
  # if a number - use atomic_number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
      ELEMENT_DETAILS=$($PSQL "SELECT atomic_number,name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
  # if not a single letter or 2 letters
  elif [[ ! $1 =~ ^[a-z|A-Z]{1,2}$ ]]
  then
      ELEMENT_DETAILS=$($PSQL "SELECT atomic_number,name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name=INITCAP('$1')")
  else
    ELEMENT_DETAILS=$($PSQL "SELECT atomic_number,name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='${1^}'")
  fi

  # Output: The element with atomic number # is name (symbol). It's a type with mass of atomic_mass amu. Name has a melting point of melting_point_celsius Celsius and a boiling point of boiling_point_celsius Celsius.
  if [[ -z $ELEMENT_DETAILS ]]
  then
      echo "I could not find that element in the database."
  else
      echo "$ELEMENT_DETAILS" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
  fi
  
else
  echo "Please provide an element as an argument."
fi