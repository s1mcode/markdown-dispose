#!/bin/bash

echo ""
echo "######################################"
echo "请确保先上传好所有本地图片后再使用该脚本！"
echo "######################################"
echo ""

#markdown_tool.py的路径
MARKDOWN_TOOL_PY="d:\develop\python310\scripts\markdown_tool.py"
#文件输出路径
OUTPUT_PATH="./output/"
#参数1：md文件路径
FILE_PATH=${1}

#判断参数是否为空
if [ -n "$1" ] ;then
    echo "文件原路径: $1"
else
    echo "请将md文件路径作为参数输入"
    exit
fi

#创建输出目录
if [ ! -d "$OUTPUT_PATH" ];then
    mkdir $OUTPUT_PATH
fi

#获取当前时间作为文件名称
filename_without_suffix=$(date +%Y%m%d-%H%M%S) 
echo "文件输出名称: $filename_without_suffix.md"

#获取当前路径
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
#文件输出路径
outputFilePath="${SHELL_FOLDER}${OUTPUT_PATH: 1}$filename_without_suffix.md"
echo "文件输出路径: ${outputFilePath}"

#复制原文件到输出路径并更改文件名
cp ${FILE_PATH} ${outputFilePath}

#处理后的文件存放路径
outputFilePathWithoutSuffix="${SHELL_FOLDER}${OUTPUT_PATH: 1}$filename_without_suffix"

#进入输出路径的文件夹
cd $OUTPUT_PATH

#创建文件夹，存放下载的图片
if [ ! -d "$outputFilePathWithoutSuffix" ];then
    mkdir $outputFilePathWithoutSuffix
    echo "创建文件夹成功: $outputFilePathWithoutSuffix"
else
    echo "文件夹已经存在: $outputFilePathWithoutSuffix"
fi

echo "开始下载markdown中的图片"

#使用markdown_articles_tool下载markdown中的图片到指定文件夹
python $MARKDOWN_TOOL_PY $outputFilePath -d $outputFilePathWithoutSuffix -O "0.md"

#判断md文件是否生成成功
if [ ! -f 0.md ];then
    echo "md文件生成失败！程序终止"
    exit
fi

#移动文件到指定目录
mv 0.md $outputFilePathWithoutSuffix
mv $outputFilePathWithoutSuffix.md $outputFilePathWithoutSuffix/1.md


