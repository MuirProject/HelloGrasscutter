#!/bin/bash

command="$@"

config(){
    echo "$0: Generating configuration..."
    nohup bash -c 'sleep 3s;pkill java' > /dev/null 2>&1 &
    java -jar grasscutter.jar > /dev/null 2>&1 &
    sleep 3s
    if [ -z "$MongoIP" ]; then
        cat config.json|jq '.DatabaseUrl="mongodb://mongo:27017"' > config.json.change
        cat config.json.change|jq '.GameServer.DispatchServerDatabaseUrl="mongodb://mongo:27017"' > config.json
        cat config.json|jq '.databaseInfo.server.connectionUri="mongodb://mongo:27017"' > config.json.change
        cat config.json.change|jq '.databaseInfo.game.connectionUri="mongodb://mongo:27017"' > config.json
    else
        cat config.json|jq ".DatabaseUrl=\"mongodb:/"$MongoIP":27017\"" > config.json.change
        cat config.json.change|jq ".GameServer.DispatchServerDatabaseUrl=\"mongodb:/"$MongoIP":27017\"" > config.json
        cat config.json|jq ".databaseInfo.server.connectionUri=\"mongodb:/"$MongoIP":27017\"" > config.json.change
        cat config.json.change|jq ".databaseInfo.game.connectionUri=\"mongodb:/"$MongoIP":27017\"" > config.json
    fi
    mv config.json config.json.change
    cat config.json.change|jq '.GameServer.Name="HelloGrasscutter"' > config.json
    rm -rf config.json.change
}

init(){
    echo "$0: Start initialization."
    cp -rf /keys /app/keys
    cp -rf /data /app/data
    cp -rf /keystore.p12 /app/keystore.p12
    if [[ ! -d "/app/resources" ]]; then
        echo "$0: Downloading resources..."
        if ! (git clone --depth 1 https://github.com/Koko-boya/Grasscutter_Resources.git /tmp/Resources  > /dev/null 2>&1) then
            git clone --depth 1 https://github.com/HelloGrasscutter/Resources.git /tmp/Resources  > /dev/null 2>&1
		fi
        rm -rf /tmp/Resources/.git
        echo "$0: Copying resources..."
        mkdir -p /app/resources/
        mv -f /tmp/Resources/Resources/* /app/resources
    fi
    cp -rf /grasscutter.jar /app/grasscutter.jar
    config
    echo "$0: Initialization complete!"
    exec $command
}

if [[ ! -d "/app" ]]; then
    echo -e "$0: Please mount the data directory to /app.\n$0: Exiting..."
elif [[ ! -f "/app/grasscutter.jar" ]]; then
    cd /app
    init
elif [[ $1 = "reset" ]]; then
    echo "$0: [!!] All files except config.json will be reset, including the data folder."
    read -r -p "$0: Are You Sure? [y/N] " input
    case $input in
        [yY][eE][sS]|[yY])
            echo "$0: Deleting old resources..."
            rm -rf /app/resources
            init
            ;;
        *)
            echo "$0: Exiting..."
            exit 1
            ;;
    esac
elif [[ $1 = "resetconfig" ]]; then
    read -r -p "$0: [!!] Are you sure you want to reset the config.json? [y/N] " input
    case $input in
        [yY][eE][sS]|[yY])
            echo "$0: Deleting config.json..."
            rm -rf /app/config.json
            config
            ;;
        *)
            echo "$0: Exiting..."
            exit 1
            ;;
    esac
else
    cd /app
    echo -e "$0: Welcome to HelloGrasscutter, this is a docker open source project based on Grasscutter, you can check it out at https://github.com/HelloGrasscutter."
    exec $command
fi
