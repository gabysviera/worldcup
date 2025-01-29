#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
if [[ $WINNER != 'winner' ]]
then


#get winner_id
 WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
 #if not found
 if [[ -z $WINNER_ID ]]
 then
 #insert winner
 INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
 if [[ $INSERT_WINNER == "INSERT 0 1" ]]
 then
 echo Inserted into teams, $WINNER
 fi
 #get winner_id
 WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'") 
fi

#get opponent_id
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'") 
 #if not found
 if [[ -z $OPPONENT_ID ]]
 then
 #insert opponent
 INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
 if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
 then
 echo Inserted into teams, $OPPONENT
 fi
 #get opponent_id
 OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'") 
fi

#get game_id
 GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year = '$YEAR' AND round = '$ROUND' AND winner_id = '$WINNER_ID' AND opponent_id = '$OPPONENT_ID' AND winner_goals = '$WINNER_GOALS' AND opponent_goals = '$OPPONENT_GOALS'") 
#if not found
 if [[ -z $GAME_ID ]]
 then
 INSERT_DATA_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
 fi
 if [[ $INSERT_DATA_GAMES == "INSERT 0 1" ]]
 then
 echo Inserted into games, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS
 fi
 #get game_id
 GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year = '$YEAR' AND round = '$ROUND' AND winner_id = '$WINNER_ID' AND opponent_id = '$OPPONENT_ID' AND winner_goals = '$WINNER_GOALS' AND opponent_goals = '$OPPONENT_GOALS'")  

fi
done