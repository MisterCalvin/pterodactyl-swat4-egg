#!/bin/bash
## File: Pterodactyl SWAT 4 Egg - startup.sh
## Author: MrCalvin <admin@sbotnas.io>
## Date: 2023/07/08
## License: MIT License
GAMEDIR=/home/container/swat4

case $CONTENT_VERSION in
	"SWAT 4")
    	CONTENT_PATH=Content
    	SERVER_BINARY=Swat4DedicatedServer
		;;
    	"The Stetchkov Syndicate")
	CONTENT_PATH=ContentExpansion
    	SERVER_BINARY=Swat4XDedicatedServer
		;;

	"Mod")
	CONTENT_PATH=$MOD_NAME
    	CONTENT_VERSION=$MOD_NAME
	MOD_SYSTEM_FOLDER=$(find "$GAMEDIR/$CONTENT_VERSION" -type d -name System) 2> /dev/null || { echo "Cannot find Mod folder $GAMEDIR/$CONTENT_VERSION! Check that it exists, and that CONTENT_VERSION is set correctly!"; exit 1; }
	MOD_GAME_VERSION=$(find "$MOD_SYSTEM_FOLDER" -regex '.*Swat4X?.ini' -type f -printf "%f")
	
	case $MOD_GAME_VERSION in	
        		"Swat4.ini")
        		CONTENT_PATH_MOD=Content/System/
        		SERVER_BINARY=Swat4DedicatedServer
        		;;
        		
        		"Swat4X.ini")
        		CONTENT_PATH_MOD=ContentExpansion/System/
        		SERVER_BINARY=Swat4XDedicatedServer
        		;;
        	
        		"")
        		echo "Cannot determine SWAT4 Protocol version! Check that Swat4.ini exists in $GAMEDIR/$CONTENT_VERSION/System!"
        		exit 1;
        		;;
	esac
		;;
esac

SwatGUIState=$(find "$GAMEDIR/$CONTENT_PATH/System" -type f -iname SwatGUIState.ini -printf "%f" -quit | grep .) && SwatGUIState="$GAMEDIR/$CONTENT_PATH/System/$SwatGUIState" 

if [ "$SwatGUIState" = "" ]; then
        echo "Cannot find $GAMEDIR/$CONTENT_VERSION/System/SwatGUIState.ini, check that it exists!"
        exit 1
fi

case $GAME_TYPE in
    "Barricade Suspects")
        sed -i "s/^GameType=.*$/GameType=MPM_BarricadedSuspects/g" "$SwatGUIState"
        ;;
    "VIP Escort")
        sed -i "s/^GameType=.*$/GameType=MPM_VIPEscort/g" "$SwatGUIState"
        ;;
    "Rapid Deployment")
        sed -i "s/^GameType=.*$/GameType=MPM_RapidDeployment/g" "$SwatGUIState"
        ;;
    "CO-OP")
        sed -i "s/^GameType=.*$/GameType=MPM_COOP/g" "$SwatGUIState"
        ;;
    "Smash And Grab")
        sed -i "s/^GameType=.*$/GameType=MPM_SmashAndGrab/g" "$SwatGUIState"
        ;;
esac

sed -i -e "s/^AdminPassword=.*$/AdminPassword=$ADMIN_PASSWORD/g;
	s/^ServerName=.*$/ServerName=$SERVER_NAME/g;
	s/^MaxPlayers=.*$/MaxPlayers=$MAX_PLAYERS/g;
	s/^Password=.*$/Password=$SERVER_PASSWORD/g;
	s/^NumRounds=.*$/NumRounds=$NUM_ROUNDS/g;
	s/^DeathLimit=.*$/DeathLimit=$DEATH_LIMIT/g;
	s/^RoundTimeLimit=.*$/RoundTimeLimit=$ROUND_TIME_LIMIT/g;
	s/^PostGameTimeLimit=.*$/PostGameTimeLimit=$POST_GAME_TIME_LIMIT/g;
	s/^MPMissionReadyTime=.*$/MPMissionReadyTime=$MP_MISSION_READY_TIME/g" "$SwatGUIState"

if [ -n "$SERVER_PASSWORD" ]; then
        sed -i 's/^bPassworded=.*$/bPassworded=True/g' "$SwatGUIState"
else
        sed -i 's/^bPassworded=.*$/bPassworded=False/g' "$SwatGUIState"
fi

# Update Swat4(X)DedicatedServer.ini with current game port
sed -i -e "s/^Port=.*$/Port=$SERVER_PORT/g" "$GAMEDIR/$CONTENT_PATH/System/$SERVER_BINARY.ini"

# Hacky map fix for SWAT 4 + Base SWAT 4 mods
if [ "$CONTENT_VERSION" = "SWAT4" ] || [ "$MOD_GAME_VERSION" = "Swat4.ini" ]; then
	sed -i -e "s/^MapIndex=.*$/MapIndex=0/g;
        s/^Maps\[0\]=.*$/Maps\[0\]=$SERVER_MAP/g" "$SwatGUIState"
fi

cd "$GAMEDIR/$CONTENT_PATH/System/" || { echo "Could not change directory to $GAMEDIR/$CONTENT_PATH/System"; exit 1; }

if [ -f "$SERVER_BINARY.log" ]; then 
	mv "$SERVER_BINARY.log" "$SERVER_BINARY.old.log" 
fi

echo "Starting $CONTENT_VERSION Server, it may take up to 10 seconds before you see any logs"

xvfb-run wine "$GAMEDIR/${CONTENT_PATH_MOD:-$CONTENT_PATH/System/}$SERVER_BINARY.exe" "$SERVER_MAP" & tail -F "$SERVER_BINARY.log" 2> /dev/null
