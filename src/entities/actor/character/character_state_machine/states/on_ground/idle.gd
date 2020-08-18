extends "on_ground.gd"

var _move_flag: bool = false


func enter() -> void:
	if _input_direction.x:
		emit_signal("finished", "move")
		return
	owner.get_node("AnimationPlayer").play("idle")


func handle_input(event) -> void:
	.handle_input(event)
	if _input_direction.x:
		emit_signal("finished", "move")
