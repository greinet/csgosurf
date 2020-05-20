#!/bin/sh

# Update csgo
./steamcmd.sh +login anonymous +force_install_dir ../csgo +app_update 740 validate +quit

# Install plugins
if [ ! -f "/steam/pluginmarker" ]; then
  touch /steam/pluginmarker
  mkdir /steam/plugins
  echo "Installing plugins"
  cd /steam/plugins
  
    #server.cfg
  mkdir cfg
  echo "sv_maxrate 0
sv_minrate 80000
sv_mincmdrate 128
sv_maxupdaterate 128
sv_minupdaterate 128" >> cfg/server.cfg
  
  #Set Sourcemod admin
  echo $ADMIN"      99:z" >> /steam/plugins/addons/sourcemod/configs/admins_simple.ini
  
  #SM und MM
  echo "Installing Sourcemod and Metamod"
  curl -sqL "https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz"  | tar xz -C /steam/plugins/
  curl -sqL "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6488-linux.tar.gz"  | tar xz -C /steam/plugins/
  
  #Stripper
  echo "Installing Stripper"
  curl -sqL "http://www.bailopan.net/stripper/files/stripper-1.2.2-linux.tar.gz"  | tar xz -C /steam/plugins/
  
  #DHooks
  echo "Installing DHooks"
  wget -O dhooks.zip  https://github.com/peace-maker/DHooks2/releases/download/v2.2.0-detours10/dhooks-2.2.0-detours10-sm110.zip
  echo "wget done"
  unzip dhooks.zip
  echo "unzip done"
  rm dhooks.zip
  
  #ColorLib
  echo "Installing ColorLib"
  wget -O colorlib.zip  https://github.com/c0rp3n/colorlib-sm/releases/download/v0.2.0/colorlib-sm-0.2.0.zip
  echo "wget done"
  unzip colorlib.zip
  echo "unzip done"
  rm colorlib.zip
  
  #SMLib
  echo "Installing SMLib"
  wget -O smlib.zip  https://github.com/bcserv/smlib/archive/0.11.zip
  echo "wget done"
  unzip smlib.zip
  echo "unzip done"
  cp -r smlib-0.11/* .
  rm smlib.zip
  rm -rf smlib-0.11/
  
  #SMJansson
  echo "Installing SMJansson"
  wget -O /steam/plugins/addons/sourcemod/extensions/smjansson.ext.so https://github.com/JoinedSenses/SMJansson/raw/master/bin/smjansson.ext.so
  
  #SteamWorks
  echo "Installing SteamWorks"
  curl -sqL "http://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git132-linux.tar.gz"  | tar xz -C /steam/plugins/
  
  #Discord Api
  echo "Installing Discord Api"
  wget -O /steam/plugins/addons/sourcemod/plugins/discord_api.smx https://github.com/surftimer/Surftimer-olokos/releases/download/285/discord_api.smx
  
  #Cleaner
  echo "Installing Cleaner"
  wget -O /steam/plugins/addons/sourcemod/extensions/cleaner.ext.2.csgo.so https://github.com/Accelerator74/Cleaner/raw/master/Release/cleaner.ext.2.csgo.so
  
  #Database configuration
  echo "Installing Database configuration"
  wget -O /steam/plugins/addons/sourcemod/configs/databases.cfg https://raw.githubusercontent.com/greinet/csgosurf/master/databases.cfg
  
  #Surftimer
  echo "Installing SurfTimer"
  wget -O timer.zip  https://github.com/surftimer/Surftimer-olokos/archive/285.zip
  echo "wget done"
  unzip -o timer.zip
  echo "unzip done"
  rm timer.zip
  echo "copy files"
  cp -r Surftimer-olokos-285/addons Surftimer-olokos-285/cfg Surftimer-olokos-285/maps Surftimer-olokos-285/scripts Surftimer-olokos-285/sound Surftimer-olokos-285/tools .
  rm -rf Surftimer-olokos-285
  wget -O /steam/plugins/addons/sourcemod/plugins/SurfTimer.smx https://github.com/surftimer/Surftimer-olokos/releases/download/285/SurfTimer.smx
  
  
  
  #Downloading Maps
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B-gvqLVXDjSVX3ZnLXJ4YkdJX2c' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=0B-gvqLVXDjSVX3ZnLXJ4YkdJX2c" -O tier-1.tar.gz && rm -rf /tmp/cookies.txt && tar -xzvf tier-1.tar.gz && bunzip2 tier_1/* && cp tier_1/* maps && rm tier-1.tar.gz
  
  #Creating maplist and mapcycle
  ls -1 tier_1 | sed -e 's/\.bsp$//' > /steam/plugins/mapcycle.txt
  ls -1 tier_1 | sed -e 's/\.bsp$//' > /steam/plugins/maplist.txt
  rm -rf tier_1
  
  #Creating mapgroup
  wget -O gamemodes_server.txt https://raw.githubusercontent.com/greinet/csgosurf-influx/master/gamemodes_server.txt
  input="/steam/plugins/maplist.txt"
  number=0
  while IFS= read -r line
  do
    echo "                \"$line\" \"$number\"" >> gamemodes_server.txt
    number=$(( number + 1 ))
  done < "$input"

  echo "            }
        }
    }
}" >> gamemodes_server.txt
  chmod 755 gamemodes_server.txt
  
  
  
  
  chmod -R 777 /steam/plugins
  cp -r /steam/plugins/. /steam/csgo/csgo
  rm -rf /steam/plugins/
  cd /steam/csgo/
  echo "Finished installing plugins"
fi

# Start csgo
#/steam/csgo/srcds_run -game csgo -console -usercon -strictportbind -port 27015 +clientport 27005 +tv_port 27020 -tickrate 128 +log on +game_type 0 +game_mode 0 +mapgroup mg_bomb +map de_dust -authkey -unsecure -insecure +rcon_password rconpw123 +sv_setsteamaccount $GSLT -net_port_try 1 +hostname hostname
/steam/csgo/srcds_run -game csgo -console -usercon -strictportbind -port 27015 +clientport 27005 +tv_port 27020 -tickrate 128 +log on +game_type 0 +game_mode 0 +mapgroup surfmaps +map surf_mesa -authkey -unsecure -insecure +rcon_password rconpw123 +sv_setsteamaccount $GSLT -net_port_try 1 +hostname hostname
