extends "bull_state.gd"


onready var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func enter() -> void:
	owner.set_velocity(owner.get_velocity() * Vector2(0.0, 1.0))
	.enter()
