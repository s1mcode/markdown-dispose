#!/bin/bash

#markdown_tool.py的路径
MARKDOWN_TOOL_PY="d:\develop\python310\scripts\markdown_tool.py"
#文件输出路径
OUTPUT_PATH="./output/"
#参数1：要提取的博客的url
BLOG_URL=${1}

#判断参数是否为空
if [ -n "$1" ] ;then
    echo "开始从url提取markdown文件: $1"
else
    echo "请将要提取的博客url作为参数输入"
    exit
fi

#创建输出目录
if [ ! -d "$OUTPUT_PATH" ];then
    mkdir $OUTPUT_PATH
fi

#获取当前时间作为文件名称
filename_without_suffix=$(date +%Y%m%d-%H%M%S) 
echo "文件名称: $filename_without_suffix.md"

#拼接文件路径 不带后缀:
filepath_without_suffix=$OUTPUT_PATH$filename_without_suffix
echo "文件路径: $filepath_without_suffix.md"

#使用clean-mark提取md文件
clean-mark $BLOG_URL -o $filepath_without_suffix

#判断是否提取成功
if [ -f $filepath_without_suffix.md ] 
then 
     echo "文件提取成功！"
else
     echo "文件提取失败！程序终止"
     exit
fi

echo "现在可以打开 $filename_without_suffix.md 手动处理文件"
read -s -n1 -p "处理完成后按任意键继续 ... "
echo ""

#进入输出路径的文件夹
cd $OUTPUT_PATH

#创建文件夹，存放下载的图片
if [ ! -d "$filename_without_suffix" ];then
	mkdir $filename_without_suffix
	echo "创建文件夹成功: $filename_without_suffix"
else
	echo "文件夹已经存在: $filename_without_suffix"
fi

echo "开始下载markdown中的图片"

#使用markdown_articles_tool下载markdown中的图片到指定文件夹
python $MARKDOWN_TOOL_PY $filename_without_suffix.md -d $filename_without_suffix -O "0.md"

#判断md文件是否生成成功
if [ ! -f 0.md ];then
    echo "md文件生成失败！程序终止"
    exit
fi

#移动文件到指定目录
mv 0.md $filename_without_suffix
mv $filename_without_suffix.md $filename_without_suffix/1.md