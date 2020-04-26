extends Area2D


export(float, 0, 1) var _camera_smoothing = 0.2
export(float, 0.1, 10) var _zoom = 1.2


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body: Node) -> void:
	if not body.get_class() == "Character":
		return
	CameraManager.get_camera().set_target($CameraTarget, Vector2.ZERO, _zoom, 0.2, _camera_smoothing)


func _on_body_exited(body: Node) -> void:
	if not body.get_class() == "Character":
		return
	CameraManager.get_camera().remove_target($CameraTarget)
