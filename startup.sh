#!/bin/bash
# Test script for SWAT4 Server
# Findings:
# SWAT 4 does not respect the mapname in the startup parameter. TSS will respect it.
# As a result, SWAT 4 will load the first map (Maps[0]) under the chosen GameMode from SwatGUIState.ini
# If MapIndex= in SwatGUIState.ini is set, it will load the map assigned to that index

# ?GamePassword= is respected in SWAT 4 startup parameters. It is not respected in TSS.
# Game Passwords are NOT checked if bPassworded=False, even if you have Password= set
# Therefore, in order to password protect a server, you must set the Password variable AND bPassworded to True

if [ "$CONTENT_VERSION" == "SWAT 4" ]; then
	CONTENT_PATH=Content
    SERVER_BINARY=Swat4DedicatedServer
else
	CONTENT_PATH=ContentExpansion
    SERVER_BINARY=Swat4XDedicatedServer
fi

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

if [ $ALLOW_DOWNLOADS -eq 1 ]; then
	sed -i "s/AllowDownloads=.*$/AllowDownloads=True/g" $DedicatedServerIni
else
	sed -i "s/AllowDownloads=.*$/AllowDownloads=False/g" $DedicatedServerIni
fi

cd ~/swat4/$CONTENT_PATH/System/
wine $SERVER_BINARY.exe "$SERVER_MAP?Port=$SERVER_PORT" && sleep 5 & tail -F $SERVER_BINARY.log
