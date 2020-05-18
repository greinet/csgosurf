#!/bin/sh

# Update csgo
./steamcmd.sh +login anonymous +force_install_dir ../csgo +app_update 740 validate +quit

# Install plugins
if [ ! -f "/steam/pluginmarker" ]; then
  touch /steam/pluginmarker
  echo "Installing plugins"
  cd /steam/csgo/csgo
  #SM und MM
  echo "Installing Sourcemod and Metamod"
  curl -sqL "https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz"  | tar xz -C /steam/csgo/csgo
  curl -sqL "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6488-linux.tar.gz"  | tar xz -C /steam/csgo/csgo
  #DHooks
  echo "Installing DHooks"
  wget -O dhooks.zip  https://github.com/peace-maker/DHooks2/releases/download/v2.2.0-detours10/dhooks-2.2.0-detours10-sm110.zip && unzip dhooks.zip && rm dhooks.zip
  #SMJansson
  echo "Installing SMJansson"
  wget -O /steam/csgo/csgo/addons/sourcemod/extensions/smjansson.ext.so https://github.com/JoinedSenses/SMJansson/raw/master/bin/smjansson.ext.so
  #SteamWorks
  echo "Installing SteamWorks"
  curl -sqL "http://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git132-linux.tar.gz"  | tar xz -C /steam/csgo/csgo
  #Discord Api
  echo "Installing Discord Api"
  wget -O /steam/csgo/csgo/addons/sourcemod/plugins/discord_api.smx https://github.com/surftimer/Surftimer-olokos/releases/download/285/discord_api.smx
  #Surftimer
  echo "Installing Surftimer"
  wget -O /steam/csgo/csgo/addons/sourcemod/plugins/discord_api.smx https://github.com/surftimer/Surftimer-olokos/releases/download/285/discord_api.smx
  #Cleaner
  echo "Installing Cleaner"
  wget -O /steam/csgo/csgo/addons/sourcemod/extensions/cleaner.ext.2.csgo.so https://github.com/Accelerator74/Cleaner/raw/master/Release/cleaner.ext.2.csgo.so
  #Database configuration
  echo "Installing Database configuration"
  wget -O /steam/csgo/csgo/addons/soourcemod/configs/databases.cfg https://raw.githubusercontent.com/greinet/csgosurf/master/databases.cfg
  
  cd /steam/csgo/
  echo "Finished installing plugins"
fi

# Start csgo
/steam/csgo/srcds_run -game csgo -console -usercon -strictportbind -port 27015 +clientport 27005 +tv_port 27020 -tickrate 128 +log on +game_type 0 +game_mode 0 +mapgroup mg_bomb +map de_dust -authkey -unsecure -insecure +rcon_password rconpw123 +sv_setsteamaccount $GSLT -net_port_try 1 +hostname hostname
