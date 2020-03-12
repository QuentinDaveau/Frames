extends "in_air.gd"

export(float) var JUMP_VELOCITY = 700.0
export(float) var RELEASE_GRAVITY_MULTIPLIER = 1.8
#export(float) var GROUND_CHECK_DISABLED_DURATION = 0.1

var _is_falling: bool = false


func enter() -> void:
	set_velocity_limitations(MAX_VELOCITY, ACCELERATION)
	_velocity.y = -JUMP_VELOCITY
#	GROUNDED_CHECK.jumping_disable(GROUND_CHECK_DISABLED_DURATION)
	_is_falling = false
	.enter()


func handle_input(event) -> void:
	.handle_input(event)
	if event.is_action_released("game_jump"):
		if get_velocity().y < 0:
			set_gravity_multiplier(RELEASE_GRAVITY_MULTIPLIER)


func update(delta) -> void:
	if !_is_falling:
		if get_velocity().y >= 0:
			set_gravity_multiplier(1.0)
			_is_falling = true
	
	.update(delta)


func exit() -> void:
	set_gravity_multiplier(1.0)
