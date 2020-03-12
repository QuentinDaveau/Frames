extends Node2D

signal grapple_updated(rotation_point, distance_left)

var _rope_scene: PackedScene = load("res://entities/rope/RopeManager.tscn")
var _grappled_rope: RopeManager


func _ready() -> void:
	for state in owner.get_node("StateMachine").get_children():
		if not state is Motion:
			continue
		connect("grapple_updated", state, "_grapple_updated")



func _unhandled_input(event) -> void:
	if (event.is_action_pressed("game_left_click")):
		_cast_rope()
	if (event.is_action_released("game_left_click")):
		if _grappled_rope:
			_release_rope()


func _cast_rope() -> void:
	$GrappleCast.rotation = owner.global_position.angle_to_point(get_global_mouse_position()) + (PI / 2)
	$GrappleCast.force_raycast_update()
	
	if $GrappleCast.is_colliding():
		var rope: RopeManager = _rope_scene.instance()
#		rope.connect("rope_spawned", self, "_on_rope_spawned")
		var raycast_offset = $GrappleCast.get_collision_normal()
		rope.setup($GrappleCast.get_collision_point(), raycast_offset, owner.global_position.distance_to($GrappleCast.get_collision_point()), owner)
		rope.connect("rope_points_updated", self, "_rope_points_updated")
		get_tree().get_root().add_child(rope)
		_grappled_rope = rope


func _release_rope() -> void:
	_grappled_rope.destroy()
	_grappled_rope = null
	emit_signal("grapple_updated", Vector2.ZERO, -1.0)


func _rope_points_updated(rotation_point: Vector2, distance_left: float) -> void:
	emit_signal("grapple_updated", rotation_point, distance_left)
