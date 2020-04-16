extends Entity

enum LOOK_DIRECTION{left= -1, right= 1}

var _current_look_direction: int = LOOK_DIRECTION.right


func _physics_process(delta: float) -> void:
	global_rotation = 0.0


func set_look_direction(look_direction: int) -> void:
	if look_direction == _current_look_direction:
		return
	if abs(look_direction) != 1:
		return
	_current_look_direction = look_direction
	$SpritePivot.scale.x = _current_look_direction