#! /bin/bash
# author: Yuan:0505yahweh@gmail.com

root="."
title="" # Input your main tex file title here
container_name="tex2pdf" # Defaults to tex2pdf
texfiles="${title}.tex" # Add additional tex files if you split your project to multiple files

working_dir="/root/playground"
base="docker container"
docker_cp="${base} cp"
docker_exec="${base} exec -w ${working_dir} ${container_name}"

# TODO get image
# TODO check if container exist

while getopts d:lb:ch OPT;do
    case $OPT in
        d)
            file_to_trash=$OPTARG
            trash $file_to_trash # trash is a function
            ;;
        l)
            print_trashed_file  # print_trashed_file is a function
            ;;
        b)
            file_to_untrash=$OPTARG
            untrash $file_to_untrash # untrash is a function
            ;;
        c)
            clean_all           # clean all is a function
            ;;
        h)
            usage
            exit 0
            ;;
        \?)
            usage
            exit 1
            ;;
    esac
done

${docker_exec} sh -c "rm -rf *"
rm -f ${title}.pdf
echo "[COPY]: copy ${root} to ${container_name}"
${docker_cp} ${root} ${container_name}:${working_dir}
touch ./latex.log
echo "[COMPILING]: 1st xelatex ......"
${docker_exec} xelatex ${title} > ./latex.log
grep --text -A 3 "! Emergency stop." ./latex.log
if [ $? -eq 0 ] #there are Emergency stops occurs
then
    rm latex.log
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
    rm latex.log
    ${docker_exec} texcount ${texfiles} | grep -A 1 "Total" | sed ':a;N;$!ba;s/\n/ /g'
    echo "[SUCCEED]: ${title}.pdf has been copied to current directory"
else
    echo "[FAILED]: generate ${title}.pdf failed"
fi