extends "on_ground.gd"

var _move_flag: bool = false


func enter() -> void:
	set_velocity_limitations(MAX_VELOCITY, ACCELERATION)
	if get_input_direction():
		_move_flag = true
	.enter()


func handle_input(event) -> void:
	.handle_input(event)
	if get_input_direction():
		_move_flag = true


func update(delta) -> void:
	.update(delta)
	if _move_flag:
		_move_flag = false
		emit_signal("finished", "move")
