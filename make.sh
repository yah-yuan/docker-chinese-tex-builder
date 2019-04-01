#! /bin/bash
# it's too large for install fonts
# let's creat a container and compile tex there
# brilliant!
# author: Yuan:0505yahweh@gmail.com

root="."
title="sgx-side-channel"
container_name="tex2pdf"
working_dir="/root/playground"
base="docker container"
docker_cp="${base} cp"
docker_exec="${base} exec -w ${working_dir} ${container_name}"

if [ $# -gt 0 ]
then

    if [ "$1" = "cp" ]
    then 
        echo "[COPY]: copy ${root} to ${container_name}"
        ${docker_cp} ${root} ${container_name}:${working_dir}
    elif [ "$1" = "rm" ]
    then
        ${docker_exec} rm -rf *
    elif [ "$1" = "-s" -o "$1" = "--sample" ]
    then
        title="Sample"
    fi


else
    ${docker_exec} sh -c "rm -rf *"
    rm -f ${title}.pdf
    echo "[COPY]: copy ${root} to ${container_name}"
    ${docker_cp} ${root} ${container_name}:${working_dir}
    touch ./latex.log
    echo "[COMPILING]: 1st xelatex ......"
    ${docker_exec} xelatex ${title} > ./latex.log
    grep --text -A 1 "! Emergency stop." ./latex.log
    if [ $? -eq 0 ] #there are Emergency stops occurs
    then
        echo "[FAILED] There are probably Syntax Error"
        exit 1
    fi
    echo "[COMPILING]: bibtex8 ..."
    ${docker_exec} bibtex8 ${title} > /dev/null
    echo "[COMPILING]: 2nd xelatex ......"
    ${docker_exec} xelatex ${title} > /dev/null
    echo "[COMPILING]: 3rd xelatex ......"
    ${docker_exec} xelatex ${title} > ./latex.log
    grep -A 1  "LaTeX Warning: Reference" ./latex.log
    res=$(${docker_exec} ls | grep ${title}.pdf)
    if [ ! -z ${res} ]
    then
        ${docker_cp} ${container_name}:${working_dir}/${title}.pdf ${root}
        echo "[SUCCEED]: ${title}.pdf has been copied to current directory"
    else
        echo "[FAILED]: generate ${title}.pdf failed"
    fi
fi