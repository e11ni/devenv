DISTR=$(uname -s)
IP="127.0.0.1"
if [[ $DISTR == MINGW* ]] ; then
    IP=$(ipconfig | grep -A5 "WSL" | grep IPv4 | grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
elif [[ $DISTR == "Linux" ]] ; then
    IP=$(ip addr show eth0 | grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/")
    IP=${IP%?}
fi
docker run -it "$@" --net="host" -v //var/run/docker.sock:/var/run/docker.sock -e DISPLAY=$IP:0.0 devenv_arch:latest