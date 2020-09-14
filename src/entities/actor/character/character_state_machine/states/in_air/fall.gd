extends "in_air.gd"


func enter() -> void:
	ANIMATION_STATE.travel("fall")
	.enter()
#
#
#func handle_input(event) -> void:
#	.handle_input(event)
#
#
#func update(delta) -> void:
#	.update(delta)
