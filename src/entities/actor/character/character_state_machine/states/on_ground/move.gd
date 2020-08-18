extends "on_ground.gd"

onready var cast = owner.get_node("SpritePivot/PushCast")


func enter() -> void:
	if not _input_direction.x:
		emit_signal("finished", "idle")
		return
	cast.check_pushable()
	if cast.get_pushable():
		emit_signal("finished", "push")
		return
#	update_look_direction(get_walking_direction())
	owner.get_node("AnimationPlayer").play("run")
	cast.connect("pushable_collides", self, "_on_pushable_collision")
	.enter()


func handle_input(event) -> void:
	.handle_input(event)
	if not _input_direction.x:
		emit_signal("finished", "idle")


func update(delta) -> void:
	.update(delta)
	cast.check_pushable()
#	update_look_direction(get_walking_direction())


func exit() -> void:
	if cast.is_connected("pushable_collides", self, "_on_pushable_collision"):
		cast.disconnect("pushable_collides", self, "_on_pushable_collision")


func _on_pushable_collision() -> void:
	emit_signal("finished", "push")
