extends Area2D


var _camera_controller: CameraController


func _ready() -> void:
	_camera_controller = get_node("../CameraController")
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body: Node) -> void:
	if not body.get_class() == "Character":
		return
	_camera_controller.take_camera_control()


func _on_body_exited(body: Node) -> void:
	if not body.get_class() == "Character":
		return
	_camera_controller.leave_camera_control()
	
