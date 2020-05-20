extends ActorStateMachine

func _ready():
	states_map = {
		"idle": $Idle,
		"preparing": $Preparing,
		"charging": $Charging,
		"surprised": $Surprised,
		"stunned": $Stunned,
		"braking": $Braking,
		"hitting": $Hitting,
	}


func force_stunned_state() -> void:
	_change_state("stunned")


func _change_state(state_name):
	if not _active:
		return
	._change_state(state_name)


func _initialize_state() -> void:
	states_stack[0].initialize(current_state.get_properties())
