![HelloGrasscutter](https://socialify.git.ci/MuirProject/HelloGrasscutter/image?description=1&forks=1&issues=1&language=1&logo=https%3A%2F%2Fs2.loli.net%2F2022%2F04%2F25%2FxOiJn7lCdcT5Mw1.png&name=1&owner=1&pulls=1&stargazers=1&theme=Light)

# Quick Start
```
wget https://raw.githubusercontent.com/MuirProject/HelloGrasscutter/main/docker-compose.yml

docker-compose up -d

# Wait a while for it to automatically generate the configuration and then end it
docker-compose down

# Now, you need to change the values of GameServer>PublicIp and DispatchServer>PublicIp in config.json to the ip of the server where you are running HelloGrasscutter
nano ./app/config.json

docker-compose up -d
```

# Manually

To be added...

# Access to console

As easy as drinking water.

```
docker attach --sig-proxy=false HelloGrasscutter
```
