extends Actor
class_name Box

var _active_override: bool = false
var _active_buff: bool = false

func push(direction: Vector2) -> Vector2:
	_active_buff = _active
	set_active(true)
	_active_override = true
	return $StateMachine.set_to_pushed_state(direction)


func stop_push() -> void:
	_active_override = false
	set_active(_active_buff)
	$StateMachine.stop_push()


func set_active(value: bool = true) -> void:
	if _active_override:
		_active_buff = value
	else:
		.set_active(value)
