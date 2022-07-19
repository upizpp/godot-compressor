extends Control


onready var file_dialog = $FileDialog


var directory : String = ""
var file : String = ""




func compress(from : String, to : String):
	var compressor := FolderCompressor.new()
	compressor.open(from)
	compressor.compress(to)


func decompress(from : String, to : String):
	var decompressor := FolderDecompressor.new()
	decompressor.open(from)
	decompressor.decompress(to)




func _on_Directory_pressed():
	file_dialog.mode = FileDialog.MODE_OPEN_DIR
	file_dialog.popup_centered_ratio()


func _on_File_pressed():
	file_dialog.mode = FileDialog.MODE_SAVE_FILE
	file_dialog.popup_centered_ratio()



func _on_FileDialog_file_selected(path):
	file = path


func _on_FileDialog_dir_selected(dir):
	directory = dir


func _on_Compress_pressed():
	compress(directory, file)


func _on_Decompress_pressed():
	decompress(file, directory)
