#!/usr/bin/env bash  

#list of hosts
pc_names=("centos7" "ubuntu" "fedora")




start_docker ()
{
for i in ${pc_names[@]}
do
    #Если в конце число
    if (echo "$i" | grep -E -q "^?[0-9]+$"); then
     version=${i: -1}
     echo version = $version
     os_name=${i:0: -1}
     echo os_name = $os_name

    #Создаем Docker-контейнер
     docker run --name kaa_$i -d pycontribs/$os_name:$version sleep 60000

    else
     version=latest
     echo version = $version
     os_name=$i

    #Создаем Docker-контейнер     
     docker run --name kaa_$i -d pycontribs/$os_name:$version sleep 60000
    fi
done
}


stop_docker ()
{
for i in ${pc_names[@]}
do
    docker stop kaa_$i
    docker rm kaa_$i
done
}

start_docker

echo netology > temp.txt
ansible-playbook -i inventory/prod.yml site.yml --vault-password-file temp.txt
rm -f temp.txt


stop_docker

