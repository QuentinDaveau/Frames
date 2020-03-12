extends "state_machine.gd"

func _ready():
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"jump": $Jump,
		"fall": $Fall,
		"grapple_ground": $GrappleGround,
		"grapple_air": $GrappleAir
	}


func _change_state(state_name):
	print(state_name)
	if not _active:
		return
	if state_name in ["fall", "jump", "grapple_ground", "grapple_air"]:
		if not(current_state in [states_map["grapple_ground"], states_map["grapple_air"], states_map["fall"], states_map["jump"]]):
			states_stack.push_front(states_map[state_name])
	._change_state(state_name)
