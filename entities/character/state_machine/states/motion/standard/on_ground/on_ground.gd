extends "../standard_motion.gd"

#export(NodePath) var GROUNDED_CHECK_PATH

export(float) var MAX_VELOCITY = 450.0
export(float) var ACCELERATION = 0.3

var _jump_flag: bool = false

#onready var GROUNDED_CHECK = get_node(GROUNDED_CHECK_PATH)


func handle_input(event) -> void:
	if event.is_action_pressed("game_jump"):
		_jump_flag = true
	
	.handle_input(event)


func update(delta) -> void:
	if _jump_flag:
		_jump_flag = false
		emit_signal("finished", "jump")
		return
	if not owner.is_on_floor():
		emit_signal("finished", "fall")
		return
	.update(delta)
