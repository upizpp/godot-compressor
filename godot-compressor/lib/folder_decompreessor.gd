extends Reference
class_name FolderDecompressor, "../icon.png"


var _path := ""
var _password := ""


func decompress_buffer(buffer : PoolByteArray, compression_mode := 0) -> PoolByteArray:
	if buffer.empty():
		return buffer
	
	var size_buffer := buffer.subarray(buffer.size() - 12, buffer.size() - 1)
	var size : int = bytes2var(size_buffer)
	var new := buffer.subarray(0, buffer.size() - 13)
	new = new.decompress(size, compression_mode)
	return new


func decompress_tree(tree, compression_mode := 0) -> void:
	var keys
	if tree is Array:
		keys = tree.size()
	elif tree is Dictionary:
		keys = tree.keys()
	else:
		return
	
	for i in keys:
		if tree[i] is PoolByteArray and not tree[i].empty():
			tree[i] = decompress_buffer(tree[i], compression_mode)
		elif tree[i] is Array or tree[i] is Dictionary:
			decompress_tree(tree[i], compression_mode)


func store_tree(tree : Dictionary, to : String):
	if not to.ends_with("/"):
		to += "/"
	
	for i in tree:
		var path = to + i
		if tree[i] is Dictionary:
			var dir := Directory.new()
			dir.make_dir(path)
			store_tree(tree[i], path)
		else:
			var file := File.new()
			file.open(path, File.WRITE)
			file.store_buffer(tree[i])


func decompress(to : String, compression_mode := 0) -> int:
	if _path.empty():
		return FAILED
	
	var file := File.new()
	
	var error : int
	if not _password.empty():
		error = file.open_encrypted_with_pass(_path, File.READ, _password)
	else:
		error = file.open(_path, File.READ)
	
	if error != OK:
		return error
	
	var buffer := file.get_buffer(file.get_len())
	buffer = decompress_buffer(buffer, compression_mode)
	
	var tree : Dictionary = bytes2var(buffer)
	decompress_tree(tree, compression_mode)
	
	var dir := Directory.new()
	dir.make_dir_recursive(to)
	
	store_tree(tree, to)
	
	return OK


func open(path : String, password := "") -> bool:
	var file := File.new()
	if not file.file_exists(path):
		return false
	
	_path = path
	if not password.empty():
		_password = password
	
	return true


func clear_password() -> void:
	_password = ""
