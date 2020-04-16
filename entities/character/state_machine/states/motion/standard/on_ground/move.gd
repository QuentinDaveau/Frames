extends "on_ground.gd"

var _idle_flag: bool = false


func enter() -> void:
	set_velocity_limitations(MAX_VELOCITY, ACCELERATION)
	if not get_input_direction():
		_idle_flag = true
	update_look_direction(get_walking_direction())
	owner.get_node("AnimationPlayer").play("walk")
	.enter()


func handle_input(event) -> void:
	.handle_input(event)
	if not get_input_direction():
		_idle_flag = true


func update(delta) -> void:
	.update(delta)
	update_look_direction(get_walking_direction())
	if _idle_flag:
		_idle_flag = false
		emit_signal("finished", "idle")
		return
