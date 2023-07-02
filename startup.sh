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

# Server GameMode
if [ "$GAME_TYPE" == "Barricaded Suspects" ]; then
	sed -i "s/GameType=.*$/GameType=MPM_BarricadedSuspects/g" $SwatGUIState
elif [ "$GAME_TYPE" == "VIP Escort" ]; then
	sed -i "s/GameType=.*$/GameType=MPM_VIPEscort/g" $SwatGUIState
elif [ "$GAME_TYPE" == "Rapid Deployment" ]; then
	sed -i "s/GameType=.*$/GameType=MPM_RapidDeployment/g" $SwatGUIState
elif [ "$GAME_TYPE" == "CO-OP" ]; then
	sed -i "s/GameType=.*$/GameType=MPM_COOP/g" $SwatGUIState
else [ "$GAME_TYPE" == "Smash And Grab (The Stetchkov Syndicate only)" ];
	sed -i "s/GameType=.*$/GameType=MPM_SmashAndGrab/g" $SwatGUIState
fi

: <<'REMOVEME'
# This is so stupid
if [ "$CONTENT_VERSION" == "SWAT 4" ]; then
    # We need to change MapIndex= in SwatGUIState.ini for SWAT 4 as it does not allow loading maps from startup parameters
    # This is going to cause a lot of problems and needs thorough testing
    echo "User is playing SWAT 4, finding MapIndex!"
    echo "Current map is: $SERVER_MAP"
    #sed -i "s/\b[$GAME_TYPE]\b=.*$/MapIndex=$MAP_INDEX/g" $SwatGUIState
    #sed -i "s/\bMapIndex\b=.*$/MapIndex=$MAP_INDEX/g" $SwatGUIState
fi
REMOVEME

sed -i "s/\bAdminPassword\b=.*$/AdminPassword=$ADMIN_PASSWORD/g" $SwatGUIState
sed -i "s/ServerName=.*$/ServerName=$SERVER_NAME/g" $SwatGUIState
sed -i "s/MaxPlayers=.*$/MaxPlayers=$MAX_PLAYERS/g" $SwatGUIState
sed -i "s/\bPassword\b=.*$/Password=$SERVER_PASSWORD/g" $SwatGUIState
sed -i "s/NumRounds=.*$/NumRounds=$NUM_ROUNDS/g" $SwatGUIState
sed -i "s/DeathLimit=.*$/DeathLimit=$DEATH_LIMIT/g" $SwatGUIState
sed -i "s/RoundTimeLimit=.*$/RoundTimeLimit=$ROUND_TIME_LIMIT/g" $SwatGUIState
sed -i "s/PostGameTimeLimit=.*$/PostGameTimeLimit=$POST_GAME_TIME_LIMIT/g" $SwatGUIState
sed -i "s/MPMissionReadyTime=.*$/MPMissionReadyTime=$MP_MISSION_READY_TIME/g" $SwatGUIState

if [ "$DESIRED_MP_ENTRY_POINT" == "Primary" ]; then
	sed -i "s/DesiredMPEntryPoint=.*$/DesiredMPEntryPoint=ET_Primary/g" $SwatGUIState
else
	sed -i "s/DesiredMPEntryPoint=.*$/DesiredMPEntryPoint=ET_Secondary/g" $SwatGUIState
fi

if [ ! -z "$SERVER_PASSWORD" ]; then
	sed -i 's/bPassworded=.*$/bPassworded=True/g' $SwatGUIState
else
	sed -i 's/bPassworded=.*$/bPassworded=False/g' $SwatGUIState
fi

if [ $LAN_SERVER -eq 0 ]; then
	sed -i 's/bLAN=.*$/\bLAN=False/g' $SwatGUIState
else
	sed -i 's/bLAN=.*$/\bLAN=True/g' $SwatGUIState
fi

if [ $ALLOW_DOWNLOADS -eq 1 ]; then
	sed -i "s/AllowDownloads=.*$/AllowDownloads=True/g" $DedicatedServerIni
else
	sed -i "s/AllowDownloads=.*$/AllowDownloads=False/g" $DedicatedServerIni
fi

cd ~/swat4/$CONTENT_PATH/System/
wine $SERVER_BINARY.exe "$SERVER_MAP?Port=$SERVER_PORT" && sleep 5 & tail -F $SERVER_BINARY.log
