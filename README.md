# shellscript-bash-modify_extract
2つのフォルダを比較し、ファイルの追加・変更を抽出する処理


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
