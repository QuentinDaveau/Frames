extends ActorStateMachine

func _ready():
	states_map = {
		"idle": $Idle,
		"fall": $Fall,
		"pushed": $Pushed
	}


func set_to_pushed_state(direction: Vector2) -> Vector2:
	if current_state == $Pushed:
		return $Pushed.get_push_velocity()
	if current_state.can_push():
		$Pushed.set_push_direction(direction)
		_change_state("pushed")
		return $Pushed.get_push_velocity()
	return Vector2.ZERO


func stop_push() -> void:
	if current_state == states_map["pushed"]:
		_change_state("idle")


func _change_state(state_name):
	if not _active:
		return
	._change_state(state_name)


func _initialize_state() -> void:
	states_stack[0].initialize(current_state.get_properties())
