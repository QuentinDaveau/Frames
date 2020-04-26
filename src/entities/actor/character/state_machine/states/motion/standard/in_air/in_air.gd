extends "../standard_motion.gd"

#export(NodePath) var GROUNDED_CHECK_PATH

export(float) var MAX_VELOCITY = 450.0
export(float) var ACCELERATION = 0.1

#onready var GROUNDED_CHECK = get_node(GROUNDED_CHECK_PATH)


func enter() -> void:
	set_snap(false)
	.enter()


func handle_input(event) -> void:
	.handle_input(event)


func update(delta) -> void:
	.update(delta)
	if owner.is_on_floor():
		emit_signal("finished", "previous")
		return
