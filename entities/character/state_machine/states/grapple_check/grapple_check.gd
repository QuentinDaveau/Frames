extends "../state.gd"

var _grappled: bool = false
var _rotation_point: Vector2
var _distance_left: float


func _grapple_updated(rotation_point: Vector2, distance_left: float) -> void:
	if _grappled:
		if distance_left == -1.0:
			_grappled = false
			return
	else:
		_grappled = true
	_rotation_point = rotation_point
	_distance_left = distance_left


func _has_grapple_length(predict_velocity: Vector2) -> bool:
	if !_grappled:
		return true
	if (owner.global_position + (predict_velocity * get_physics_process_delta_time())).distance_to(_rotation_point) < _distance_left:
		return true
	return false
