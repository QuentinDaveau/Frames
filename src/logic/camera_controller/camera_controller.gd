extends Position2D
class_name CameraController


export(float, 0, 1) var _smooth: float = 0.2 setget _smooth_set
export(float, 0.1, 10) var _zoom: float = 1.2 setget _zoom_set
export(float, 0, 1) var _zoom_smooth: float = 0.2 setget _zoom_smooth_set
export(Vector2) var _position_offset: Vector2 = Vector2.ZERO setget _position_offset_set
export(Vector2) var _drag_margin: Vector2 = Vector2.ZERO setget _drag_margin_set


func take_camera_control(lock_control: bool = false) -> void:
	CameraManager.get_camera().set_target(self, lock_control, _position_offset, _zoom, _zoom_smooth, _smooth, _drag_margin)


func leave_camera_control() -> void:
	CameraManager.get_camera().remove_target(self)


func shake_camera(amount: Vector2, angle: float = 0.0) -> void:
	CameraManager.get_camera().add_shake(amount, angle)


func set_camera_shake(speed: float = -1.0, damp: float = -1.0, noise: float = -1.0, angular_noise: float = -1.0) -> void:
	CameraManager.get_camera().set_shake(speed, damp, noise, angular_noise)


func _position_offset_set(value: Vector2) -> void:
	_position_offset = value
	if not CameraManager.get_camera():
		return
	if not _camera_target_is_self():
		return
	if value != Vector2(-1, -1):
		CameraManager.get_camera().update_target_properties({"position_offset": value})


func _zoom_set(value: float) -> void:
	_zoom = value
	if not CameraManager.get_camera():
		return
	if not _camera_target_is_self():
		return
	if value != -1.0:
		CameraManager.get_camera().update_target_properties({"zoom": value})


func _zoom_smooth_set(value: float) -> void:
	_zoom_smooth = value
	if not CameraManager.get_camera():
		return
	if not _camera_target_is_self():
		return
	if value != -1.0:
		CameraManager.get_camera().update_target_properties({"zoom_smooth": value})


func _smooth_set(value: float) -> void:
	_smooth = value
	if not CameraManager.get_camera():
		return
	if not _camera_target_is_self():
		return
	if value != -1.0:
		CameraManager.get_camera().update_target_properties({"smooth": value})


func _drag_margin_set(value: Vector2) -> void:
	_drag_margin = value
	if not CameraManager.get_camera():
		return
	if not _camera_target_is_self():
		return
	if value != Vector2(-1, -1):
		CameraManager.get_camera().update_target_properties({"drag_margin": value})


func _camera_target_is_self() -> bool:
	if CameraManager.get_camera().get_current_target() == self:
		return true
	return false
