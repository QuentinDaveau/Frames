extends Node


var _game_camera: GameCamera


func _ready() -> void:
	_game_camera = _find_camera(get_tree().get_root())


func get_camera() -> GameCamera:
	return _game_camera


func _find_camera(parent_node: Node) -> GameCamera:
	for children in parent_node.get_children():
		if children.get_name() == "GameCamera":
			return children
		else:
			var camera := _find_camera(children)
			if camera:
				return camera
	return null

