extends Actor
class_name Box

func push(direction: Vector2) -> Vector2:
	return $StateMachine.set_to_pushed_state(direction)


func stop_push() -> void:
	$StateMachine.stop_push()
