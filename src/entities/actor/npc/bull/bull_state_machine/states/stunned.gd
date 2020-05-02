extends "bull_state.gd"


onready var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _on_ground: bool = false


func enter() -> void:
	_velocity.x = 0.0
	.enter()


func update(delta) -> void:
	if not _on_ground:
		_velocity.y += _gravity * delta
		var collision = owner.move_and_collide(_velocity * delta)
		# if collision:
		# 	if collision.normal.y != 0:
		# 		# _on_ground = true
