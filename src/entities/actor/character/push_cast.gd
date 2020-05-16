extends RayCast2D

signal pushable_collides()
signal pushable_left()

var _colliding_pushable: Actor = null


func _ready():
	add_exception(owner)


func check_pushable():
	force_raycast_update()
	if is_colliding():
		if get_collider() == _colliding_pushable:
			return
		if get_collider().is_in_group("pushable"):
			_colliding_pushable = get_collider()
			emit_signal("pushable_collides")
	else:
		if _colliding_pushable:
			_colliding_pushable = null
			emit_signal("pushable_left")


func get_pushable() -> Actor:
	return _colliding_pushable
