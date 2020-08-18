extends LogicBody


var _opened: bool = false
onready var _state_machine = $AnimationTree["parameters/playback"]


func _on_source_state_update(new_state: bool) -> void:
	if _opened == new_state:
		return
	if new_state:
		_state_machine.travel("Opening")
		_opened = true
	else:
		_state_machine.travel("Closing")
		_opened = false
