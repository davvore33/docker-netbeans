arg=$1

passarg="-ti --rm \
           -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v $HOME/.netbeans:/home/developer/.netbeans \
           -v $HOME/.cache/netbeans:/home/developer/.cache/netbeans \
           -v $HOME/workspace:/workspace \
           -v $HOME/NetBeans:/home/developer/NetBeans \
           -v $HOME/Documenti/Sviluppo:/opt/Sviluppo \
           -v /etc/hosts:/etc/hosts \
           fgrehm/netbeans:v8.0.1 "

if [[ $arg == '' ]]
then
xhost +;
docker run $passarg
exit
elif [[ $arg == 'term' ]]
then
docker run $passarg /bin/bash
exit
fi

