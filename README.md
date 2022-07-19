 godot-compressor
能够帮助您在godot中使用脚本压缩/解压文件

# 文档
本插件提供了两个类，分别就是压缩，解压的类。
`（注：此插件压缩的算法和正常的不同，因此，压缩出来的文件无法使用常规的解压缩软件打开，只能使用本插件的类解压）`

# FolderCompressor：

func open(path : String, password := "") -> bool:
打开一个目录，路径为path，密码为password，如果密码为""，则视为没有密码。

func clear_password() -> void:
清除密码

func compress(to : String, compression_mode := 0) -> int:
压缩open()方法打开的目录，将压缩后的文件保存至to，压缩算法为compression_mode（详见https://docs.godotengine.org/zh_CN/stable/classes/class_file.html#enum-file-compressionmode    ```CompressionMode```）



# FolderDecompressor


func open(path : String, password := "") -> bool:
打开一个压缩文件，路径为path，密码为password，如果密码为""，则视为没有密码。

func clear_password() -> void:
清除密码

func compress(to : String, compression_mode := 0) -> int:
解压open()方法打开的文件，将解压后的文件保存至to，压缩算法为compression_mode（详见https://docs.godotengine.org/zh_CN/stable/classes/class_file.html#enum-file-compressionmode    ```CompressionMode```）
