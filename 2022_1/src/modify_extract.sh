#!/bin/bash
########################################################################################
# modify_extract.sh
# 
# 変更を抽出する処理
# -p : ポーズ（本オプションを付けて起動すると、変更を見つけたら処理を一時停止し、変更ファイルを画面出力する）
# modify_extract.sh [変更前フォルダ] [変更後フォルダ] [結果出力ファイル名]
# modify_extract.sh -p [変更前フォルダ] [変更後フォルダ] [結果出力ファイル名]
# 
# 結果出力ファイルに出力されるファイルの条件
# ・[変更後フォルダ]内のファイルを1件づつチェックし
# 	・[変更前フォルダ]にない場合→出力
# 	・[変更前フォルダ]にある場合、ファイルサイズが異なり、更新日が[変更前フォルダ]の方が古い場合→出力
# 
# ※[変更前フォルダ]にのみあるファイルはチェックされない
# ※-pオプションはreadで入力中にreadで画面入力の受付が困難だったことから未実装
# ※rsyncを使った方がいい。
# 
# usage:
# ./modify_extract.sh /home/simo/work/2022_1/test/a/ /home/simo/work/2022_1/test/b/
# ./modify_extract.sh /home/simo/work/2022_1/test/a/ /home/simo/work/2022_1/test/b/ result.txt
# ./modify_extract.sh /home/simo/work/2022_1/test/a/ /home/simo/work/2022_1/test/b/ >> result.txt
# 
########################################################################################

before_dir="/home/simo/work/2022_1/test/a/"
after_dir="/home/simo/work/2022_1/test/b/"

new_files=()
edit_files=()

before_files=()
after_files=()


# 実行時に指定された引数の数、つまり変数 $# の値が 3 でなければエラー終了。
if [ ! $# -eq 3 ] && [ ! $# -eq 2 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには2個 または 3個の引数が必要です。" 1>&2
  exit 1
fi

before_dir=$1
after_dir=$2

while read -d $'\0' after_file; do

        before_file=`echo ${after_file} | sed -e s%${after_dir}%${before_dir}%g`

        if [ -e ${before_file} ] ; then
            # [変更前フォルダ]にある場合、ファイルサイズが異なり、更新日が[変更前フォルダ]の方が古い場合→出力
            before_info=$(ls -l --time-style='+%s' ${before_file})
            before_size=$(echo $before_info | awk '{print $5}')
            before_timestamp=$(echo $before_info | awk '{print $6}')

            after_info=$(ls -l --time-style='+%s' ${after_file})
            after_size=$(echo $after_info | awk '{print $5}')
            after_timestamp=$(echo $after_info | awk '{print $6}')


#            echo "[変更前]"
#            echo $before_info
#            echo $before_size
#            echo $before_timestamp
#            
#            echo "[変更後]"
#            echo $after_info
#            echo $after_size
#            echo $after_timestamp

            if [ $before_size -ne $after_size -a $before_timestamp -lt $after_timestamp ]; then
                # [変更前フォルダ]にある場合、ファイルサイズが異なり、更新日が[変更前フォルダ]の方が古い場合→出力
#                echo "[変更前フォルダ]にある場合、ファイルサイズが異なり、更新日が[変更前フォルダ]の方が古い場合→出力"
#                echo ${after_file}
                
                edit_files+=("${after_file}")
                
            fi

        else
            # [変更前フォルダ]にない場合→出力
#            echo "[変更前フォルダ]にファイルがありません"
#            echo ${after_file}

            new_files+=("${after_file}")

        fi

# for debug
#        after_files+=("${after_file}")
#        before_files+=("${before_file}")


done < <(find ${after_dir} -type f -print0)

if [ $# -eq 3 ]; then
    {
    echo `date`
    echo "追加ファイル一覧"
    for i in ${new_files[@]}; do
        echo $i
    done

    echo "更新ファイル一覧"
    for i in ${edit_files[@]}; do
        echo $i
    done
    } >$3 2>&1
else
    echo "追加ファイル一覧"
    for i in ${new_files[@]}; do
        echo $i
    done

    echo "更新ファイル一覧"
    for i in ${edit_files[@]}; do
        echo $i
    done
fi

