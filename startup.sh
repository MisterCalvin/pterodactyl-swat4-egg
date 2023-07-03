#!/bin/bash
## File: Pterodactyl SWAT 4 Egg - startup.sh
## Author: MrCalvin <admin@sbotnas.io>
## Date: 2023/7/02
## License: MIT License

case $CONTENT_VERSION in
	"SWAT 4")
    	CONTENT_PATH=Content
    	SERVER_BINARY=Swat4DedicatedServer
		;;
    "The Stetchkov Syndicate")
		CONTENT_PATH=ContentExpansion
    	SERVER_BINARY=Swat4XDedicatedServer
		;;
esac

SwatGUIState=$HOME/swat4/$CONTENT_PATH/System/SwatGUIState.ini
DedicatedServerIni=$HOME/swat4/$CONTENT_PATH/System/$SERVER_BINARY.ini

case $GAME_TYPE in
	"Barricade Suspects")
		sed -i "s/GameType=.*$/GameType=MPM_BarricadedSuspects/g" $SwatGUIState
    	;;
    "VIP Escort")
    	sed -i "s/GameType=.*$/GameType=MPM_VIPEscort/g" $SwatGUIState
        ;;
    "Rapid Deployment")
    	sed -i "s/GameType=.*$/GameType=MPM_RapidDeployment/g" $SwatGUIState
        ;;
    "CO-OP")
    	sed -i "s/GameType=.*$/GameType=MPM_COOP/g" $SwatGUIState
        ;;
    "Smash And Grab (The Stetchkov Syndicate only)")
    	sed -i "s/GameType=.*$/GameType=MPM_SmashAndGrab/g" $SwatGUIState
        ;;
esac

sed -i -e "s/\bAdminPassword\b=.*$/AdminPassword=$ADMIN_PASSWORD/g;
s/ServerName=.*$/ServerName=$SERVER_NAME/g;
s/MaxPlayers=.*$/MaxPlayers=$MAX_PLAYERS/g;
s/\bPassword\b=.*$/Password=$SERVER_PASSWORD/g;
s/NumRounds=.*$/NumRounds=$NUM_ROUNDS/g;
s/DeathLimit=.*$/DeathLimit=$DEATH_LIMIT/g;
s/RoundTimeLimit=.*$/RoundTimeLimit=$ROUND_TIME_LIMIT/g;
s/PostGameTimeLimit=.*$/PostGameTimeLimit=$POST_GAME_TIME_LIMIT/g;
s/MPMissionReadyTime=.*$/MPMissionReadyTime=$MP_MISSION_READY_TIME/g" $SwatGUIState

if [ ! -z "$SERVER_PASSWORD" ]; then
	sed -i 's/bPassworded=.*$/bPassworded=True/g' $SwatGUIState
else
	sed -i 's/bPassworded=.*$/bPassworded=False/g' $SwatGUIState
fi

# Hacky map fix for SWAT 4
if [ "$CONTENT_VERSION" == "SWAT 4" ]; then
    sed -i -e "s/MapIndex=.*$/MapIndex=0/g;
	s/Maps\[0\]=.*$/Maps\[0\]=$SERVER_MAP/g" $SwatGUIState
fi

cd ~/swat4/$CONTENT_PATH/System/
wine $SERVER_BINARY.exe "$SERVER_MAP?Port=$SERVER_PORT" & tail -F $SERVER_BINARY.log
