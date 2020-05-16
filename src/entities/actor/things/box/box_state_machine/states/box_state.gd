extends State

export(bool) var _can_push: bool = false

onready var GRAVITY: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func can_push() -> bool:
	return _can_push


func update(delta) -> void:
	apply_movement(delta)


func apply_movement(delta) -> void:
	owner.add_velocity(Vector2.DOWN * GRAVITY * delta)
	owner.move(delta)
