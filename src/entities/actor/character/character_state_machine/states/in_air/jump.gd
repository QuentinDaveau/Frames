extends "in_air.gd"

export(float) var JUMP_VELOCITY = 700.0
export(float) var RELEASE_GRAVITY_MULTIPLIER = 1.8
#export(float) var GROUND_CHECK_DISABLED_DURATION = 0.1

var _is_falling: bool = false


func enter() -> void:
	owner.add_velocity(Vector2.UP * JUMP_VELOCITY)
#	GROUNDED_CHECK.jumping_disable(GROUND_CHECK_DISABLED_DURATION)
	.enter()


func handle_input(event) -> void:
	.handle_input(event)
	if event.is_action_released("game_jump"):
		if owner.get_velocity().y < 0:
			_gravity_multiplier = RELEASE_GRAVITY_MULTIPLIER


func update(delta) -> void:
	if !_is_falling:
		if owner.get_velocity().y >= 0:
			_gravity_multiplier = 1.0
			_is_falling = true
	
	.update(delta)


func exit() -> void:
	_is_falling = false
	_gravity_multiplier = 1.0
