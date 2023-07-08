# Pterodactyl SWAT 4 Egg
This is a Pterodactyl egg for running a SWAT 4 dedicated server under Wine. It also supports its expansion, The Stetchkov Syndicate, as well as third-party mods (please see [Notes](https://github.com/MisterCalvin/pterodactyl-swat4-egg#notes--bugs) for more details). The installer assumes you have SWAT 4 Gold Editon or the GOG Edition and may fail if you try to provide it any other versions. You will need to provide a URL to an archived copy of the game files during the egg setup. Currently, the supported archive filetypes are: `.zip`, `.gzip`, and `.xz`. If you have an exe of the game you will need to install it on another computer and archive the contents before uploading them. You must have the files in the root directory of your archive or the installer will fail. The installer expects the archive layout to be as such:

    .
    ├── ...
    ├── Content
    ├── ContentExpansion
    ├── YourMod1
    └── YourMod2

The installer will automatically download and install the Master Server Patch necessary for listing your game on the community server list. You can find the project page [here](https://github.com/sergeii/swat-patches/tree/master/swat4stats-masterserver/). I am currently having an issue displaying the download progress of the game files, so it may appear as if the panel has frozen, give it a bit of time and you should see it begin unarchiving the files once it has finished downloading. I am working on fixing this, please let me know if have any issues installing the egg because of this.

## Server Ports
SWAT 4 requires Base Port + 3 (Default port is 10480, so 10480-10483/udp)

| Port      | Default  |
|-----------|----------|
| Join 		| 10480/udp|
| Query     | 10481/udp|
|        	| 10482/udp|
|       	| 10483/udp|

## Notes / Bugs
- The panel console will not send any input to the server. If you need to send any commands I recommend setting the Admin Password and sending them in-game. The panel will also sporadically update as I have no good way to capture SWAT 4's stdout or stderr. Currently I have the startup script tail the contents of the Dedicated Server .log, which is the only way I can get anything in to the panel. SWAT 4 updates its log file in large chunks, usually whenever new information is written (player connecting, server changing level, responding to master server queries, etc.) so you will see large jumps in panel. I cannot do anything about this right now.

- The startup script is run each time the server is restarted through the panel, be careful when editing your SwatGUIState.ini or Swat4(X)DedicatedServer.ini files in `/System` as it may overwrite any changes or outright break the config file.

- You can switch between SWAT 4 or The Stetchkov Syndicate through the startup panel. Be careful not to have an unsupported map loaded when doing so (TSS can play all of SWAT 4's maps, however SWAT 4 cannot access maps in the expansion and will refuse to boot)

- Mods are supported, however they will not respect the `ADMIN_PASSWORD` env variable. For setting up in-game administration on a server running a mod you will need to consult with the developers documentation.

- Mods may also have additional features or options you can configure, you will need to manually edit the SwatGUIState.ini file found within your mods `System/` folder if you wish to modify anything. The startup script is designed to only overwrite the env variables listed in the Dockerfile, everything else will be untouched.

- I have tested the egg with the following mods:

| Mod       			| Version  																							|
|-----------------------|---------------------------------------------------------------------------------------------------|
| SWAT: Elite Force     | [7](https://www.moddb.com/mods/swat-elite-force/downloads/swat-elite-force-v7)					|
| SEF First Responders 		| [0.67 Stable](https://www.moddb.com/mods/sef-first-responders/downloads/sef-first-responders-v067-stable)	|
| SWAT: Back to LA 		| [1.6](https://www.moddb.com/mods/swat-back-to-los-angeles/downloads/sef-back-to-los-angeles-v16)	|
| Canadian Forces: Direct Action | [4.1](https://www.moddb.com/downloads/canadian-forces-direct-action-41)					|
| 11-99 Enhancement 	| [1.3](https://www.moddb.com/mods/11-99-enhancement-mod/downloads/11-99-enhancement-mod-v13)		|

- Keep an eye on your Dedicated Server log (`/Content/System/Swat4DedicatedServer.log` or `/Content/System/Swat4XDedicatedServer.log` for TSS) as it may grow in size overtime. This file is backed up to `Swat4(X)DedicatedServer.old.log` recreated each time the server is restarted.

- I have tested this as thoroughly as possible, however SWAT 4 has many bugs in its dedicated server software so I am sure there are some things I have not caught. If encounter any problems feel free to [create a new issue](https://github.com/MisterCalvin/pterodactyl-swat4-egg/issues).

- Tested with Pterodactyl Panel Version `1.11.13`, Wings Version `1.11.6`
