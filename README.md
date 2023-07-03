# Pterodactyl SWAT 4 Egg
This is a Pterodactyl egg running SWAT 4 Gold or GOG under Wine. The installer assumes you have either of these versions and may fail if you try to provide it any other versions. During the egg deployment, you will be asked to link a URL of the game files. Currently, the supported filetypes are: ``.zip``, ``.gzip``, and ``.tar.xz``. You must have the files in the root directory of your archive or the installer will fail. The installer expects the archive layout to be as such:

    .
    ├── ...
    ├── Content
    └── ContentExpansion

The installer will automatically download and install the Master Server Patch necessary for listing your game on the community server list. You can find the project page [here](https://github.com/sergeii/swat-patches/tree/master/swat4stats-masterserver/).

## Server Ports
SWAT requires Base Port + 3 (Default port is 10480, so 10480-10483/udp)

| Port      | Default  |
|-----------|----------|
| Join 		| 10480/udp|
| Query     | 10481/udp|
|        	| 10482/udp|
|       	| 10483/udp|

## Notes / Bugs
- The panel console will not send any input to the server. If you need to send any commands I recommend setting the Admin Password and sending them in-game. The panel will also sporadically update as I have no good way to capture SWAT 4's stdout or stderr. Currently I have the startup script tail the contents of the Dedicated Server .log, which is the only way I can get anything in to the panel. Swat 4 updates its log file in large chunks, usually whenever new information is written (player connecting, server changing level, responding to master server queries, etc.) so you will see large jumps in panel. I cannot do anything about this right now.

- The startup script is run each time the server is restarted through the panel. Be careful when editing your SwatGUIState.ini or Swat4(X)DedicatedServer.ini files in /System as the sed may overwrite any changes or outright break the config file.

- You can switch between SWAT 4 or The Stetchkov Syndicate through the startup panel. Be careful not to have an unsupported map loaded when doing so (TSS can play all of SWAT 4's maps, however SWAT 4 cannot access maps in the expansion and will refuse to boot)

- Mods should work but have not been tested and will require modifying ``startup.sh`` in the root directory of the container. 

- Keep an eye on your Dedicated Server log (/Content/System/Swat4DedicatedServer.log or /Content/System/Swat4XDedicatedServer.log for TSS) as it may grow in size overtime. This file is overwritten with fresh data each time the server is restarted.

- I have tested this as thoroughly as possible, however SWAT 4 has many bugs in its dedicated server software so I am sure there are some things I have not caught. If encounter any problems feel free to [create a new issue](https://github.com/MisterCalvin/pterodactyl-swat4-egg/issues).
