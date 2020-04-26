extends Entity

enum LOOK_DIRECTION{left= -1, right= 1}

export(String) var _class_name: String = "Actor"

var _current_look_direction: int = LOOK_DIRECTION.right


# Temporary override of the get_class function which normally would return the base KinematicBody2D class
func get_class() -> String:
    return _class_name


func _physics_process(delta: float) -> void:
	global_rotation = 0.0


func set_look_direction(look_direction: int) -> void:
	if look_direction == _current_look_direction:
		return
	if abs(look_direction) != 1:
		return
	_current_look_direction = look_direction
	$SpritePivot.scale.x = _current_look_direction