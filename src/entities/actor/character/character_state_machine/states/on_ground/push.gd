extends "on_ground.gd"

onready var cast = owner.get_node("SpritePivot/PushCast")

var _pushable: Actor = null
var _push_velocity: Vector2 = Vector2.ZERO

func enter() -> void:
	if not _input_direction.x:
		emit_signal("finished", "idle")
		return
	cast.check_pushable()
	if not cast.get_pushable():
		emit_signal("finished", "move")
		return
	cast.connect("pushable_collides", self, "_on_pushable_collision")
	cast.connect("pushable_left", self, "_on_pushable_left")
	_pushable = cast.get_pushable()
	_push_velocity = _pushable.push(Vector2(_input_direction.x, 0))
	owner.get_node("SpritePivot/Sprite").modulate = Color(0.5, 0.1, 0.1)
#	update_look_direction(get_walking_direction())
	owner.get_node("AnimationPlayer").play("push")
	.enter()


func handle_input(event) -> void:
	.handle_input(event)
	if not _input_direction.x:
		emit_signal("finished", "idle")
	if sign(_input_direction.x) != sign(_push_velocity.x):
		emit_signal("finished", "idle")


func update(delta: float) -> void:
	.update(delta)
	cast.check_pushable()


func apply_movement(delta) -> void:
	var _current_velocity = owner.get_velocity()
	_current_velocity.y += GRAVITY * _gravity_multiplier * delta
	_current_velocity.x = _push_velocity.x
	owner.set_velocity(_current_velocity)
	owner.move(delta)


func exit() -> void:
	owner.get_node("SpritePivot/Sprite").modulate = Color(1, 1, 1)
	if _pushable:
		_pushable.stop_push()
		_pushable = null
		cast.disconnect("pushable_collides", self, "_on_pushable_collision")
		cast.disconnect("pushable_left", self, "_on_pushable_left")


func _on_pushable_collides() -> void:
	_pushable = cast.get_pushable()


func _on_pushable_left() -> void:
	emit_signal("finished", "move")
