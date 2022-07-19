extends Reference
class_name FolderCompressor, "../icon.png"


var _path := ""
var _password := ""


func compress(to : String, compression_mode := 0) -> int:
	if _path.empty():
		return FAILED
	
	var file := File.new()
	
	var error : int
	if not _password.empty():
		error = file.open_encrypted_with_pass(to, File.WRITE, _password)
	else:
		error = file.open(to, File.WRITE)
	
	if error != OK:
		return error
	
	file.store_buffer(_get_buffer(compression_mode))
	
	return OK


func open(path : String, password := "") -> bool:
	var dir := Directory.new()
	if not dir.dir_exists(path):
		return false
	
	_path = path
	if not password.empty():
		_password = password
	
	return true


func clear_password() -> void:
	_password = ""


func _get_tree(parent := _path) -> Dictionary:
	if not parent.ends_with("/"):
		parent += "/"
	
	var dir := Directory.new()
	
	var error := dir.open(parent)
	if error != OK:
		push_error("尝试访问路径时出错。错误代码：{%s}" % error)
		return {"errored" : true, "code" : error}
	
	
	var tree := {}
	
	dir.list_dir_begin(true)
	var filename = dir.get_next()
	while filename != "":
		if dir.current_is_dir():
			tree[filename] = _get_tree(parent + filename)
		else:
			var file := File.new()
			file.open(parent + filename, File.READ)
			tree[filename] = file.get_buffer(file.get_len())
			file.close()
		filename = dir.get_next()
	
	return tree


func _compress_buffer(buffer : PoolByteArray, compression_mode := 0) -> PoolByteArray:
	if buffer.empty():
		return buffer
	
	var size = buffer.size()
	var new = buffer.compress(compression_mode)
	var size_buffer = var2bytes(size)
	size_buffer.resize(12)
	new.append_array(size_buffer)
	return new


func _compress_tree(tree, compression_mode := 0) -> void:
	var keys
	if tree is Array:
		keys = tree.size()
	elif tree is Dictionary:
		keys = tree.keys()
	else:
		return
	
	for i in keys:
		if tree[i] is PoolByteArray:
			tree[i] = _compress_buffer(tree[i], compression_mode)
		elif tree[i] is Array or tree[i] is Dictionary:
			_compress_tree(tree[i], compression_mode)


func _get_buffer(compression_mode := 0) -> PoolByteArray:
	if _path.empty():
		return var2bytes("Error")
	
	var tree := _get_tree()
	_compress_tree(tree, compression_mode)
	var buffer := var2bytes(tree, true)
	buffer = _compress_buffer(buffer, compression_mode)
	
	return buffer
