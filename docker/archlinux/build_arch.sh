PASSWD=${1}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

if [ -z "$PASSWD" ]; then
    echo "Set user password:"
    read -s PASSWD
fi
docker build --no-cache --progress=plain -f dev_arch.Dockerfile --build-arg http_proxy=$HTTP_PROXY --build-arg https_proxy=$HTTPS_PROXY --build-arg no_proxy=$NO_PROXY --build-arg username=$USERNAME --build-arg uid=$UID --build-arg pw=$PASSWD -t devenv_arch:latest  .
