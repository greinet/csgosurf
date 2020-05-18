#!/bin/sh

# Update csgo
./steamcmd.sh +login anonymous +force_install_dir ../csgo +app_update 740 validate +quit

# Install plugins
if [ ! -f "/steam/pluginmarker" ]; then
  touch /steam/pluginmarker
  echo "Installing plugins"
  cd /steam/csgo/csgo
  curl -sqL "https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz"  | tar xz -C /steam/csgo/csgo
  curl -sqL "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6488-linux.tar.gz"  | tar xz -C /steam/csgo/csgo
  curl -sqL "https://github.com/peace-maker/DHooks2/releases/download/v2.2.0-detours10/dhooks-2.2.0-detours10-sm110.zip" | jar xv
  cd /steam/csgo/
fi

# Start csgo
/steam/csgo/srcds_run -game csgo -console -usercon -strictportbind -port 27015 +clientport 27005 +tv_port 27020 -tickrate 128 +log on +game_type 0 +game_mode 0 +mapgroup mg_bomb +map de_dust -authkey -unsecure -insecure +rcon_password rconpw123 +sv_setsteamaccount $GSLT -net_port_try 1 +hostname hostname
