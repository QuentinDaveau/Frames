extends "in_air.gd"


func enter() -> void:
	set_velocity_limitations(MAX_VELOCITY, ACCELERATION)
	.enter()


func handle_input(event) -> void:
	.handle_input(event)


func update(delta) -> void:
	.update(delta)
