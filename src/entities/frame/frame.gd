extends Entity
class_name Frame

enum PHYSIC_STATE{idle = 0, static = 1, kinematic = 2, animated = 3}

const UP: Vector2 = Vector2.UP

export(PHYSIC_STATE) var _physic_state: int = PHYSIC_STATE.static
export(float) var LINEAR_DAMP: float = 20.0
export(float) var ANGULAR_DAMP: float = 20.0

onready var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _linear_velocity: Vector2 = Vector2.ZERO
var _angular_velocity: float = 0.0
var _applied_force: Vector2 = Vector2.RIGHT * 100
var _applied_force_origin: Vector2 = Vector2.ZERO


# Temporary override of the get_class function which normally would return the base KinematicBody2D class
func get_class() -> String:
	return "Frame"


func _ready() -> void:
	$TileMap/ActorChecker.connect("actor_entered", self, "_on_actor_enter")
	$TileMap/ActorChecker.connect("actor_exited", self, "_on_actor_exit")


func _physics_process(delta: float) -> void:
		match _physic_state:

			PHYSIC_STATE.static:
				_apply_damp(delta)
				_apply_force(delta)
				# Needs to add gravity
				_apply_move_as_static(delta)

			PHYSIC_STATE.kinematic:
				_apply_damp(delta)
				_apply_force(delta)
				if not is_on_floor():
					_linear_velocity.y += _gravity * delta
				_linear_velocity = move_and_slide(_linear_velocity, Vector2.UP)

			# PHYSIC_STATE.animated:


func define_physic_state(physic_state: int) -> void:
	if physic_state == _physic_state:
		return
	if not physic_state in PHYSIC_STATE:
		return
	_physic_state = physic_state


func add_impulse(impulse: Vector2, impulse_origin: Vector2) -> void:
		if impulse_origin != Vector2.ZERO:
			var temp_impulse = impulse.rotated(impulse.angle_to_point(Vector2.RIGHT))
			_linear_velocity += temp_impulse.x * impulse.normalized()
			_angular_velocity += temp_impulse.y
		else:
			_linear_velocity += impulse


func add_force(force: Vector2, force_origin: Vector2 = Vector2.ZERO) -> void:
	pass


func get_force() -> Vector2:
	return _applied_force


func initialize() -> void:
	return


func enter() -> void:
	return


func exit() -> void:
	return


func _on_actor_enter(actor: Actor) -> void:
	if actor.is_reparenting():
		return
	if actor.get_class() == "Character":
		$TileMap/CameraController.take_camera_control()
		for sleeping_actor in $TileMap/Actors.get_children():
			if sleeping_actor.get_class() == "Character":
				continue
			sleeping_actor.set_active(true)
	call_deferred("_reparent", actor, $TileMap/Actors)


func _on_actor_exit(actor: Actor) -> void:
	if actor.is_reparenting():
		return
	if actor.get_class() == "Character":
		$TileMap/CameraController.leave_camera_control()
		for awoke_actor in $TileMap/Actors.get_children():
			if awoke_actor.get_class() == "Character":
				continue
			awoke_actor.set_active(false)
	call_deferred("_reparent", actor, get_parent())


func _reparent(actor: Actor, target: Node2D) -> void:
	actor.set_reparenting(true)
	var actor_global_position = actor.global_position
	var actor_global_rotation = actor.global_rotation
	actor.get_parent().remove_child(actor)
	target.add_child(actor)
	actor.set_owner(target)
	actor.global_position = actor_global_position
	actor.global_rotation = actor_global_rotation
	actor.set_reparenting(false)


func _on_trigger_activated(trigger_identifier: String) -> void:
	$SignalManager.signal_recieved(trigger_identifier)


func _apply_move_as_static(delta: float) -> void:
	# add_collision_exception_with($TileMap.get_node("Character"))
	# var collision: KinematicCollision2D = move_and_collide(_linear_velocity * delta, true, true, true)
	# remove_collision_exception_with($TileMap.get_node("Character"))

	# if collision:
	# 	# var projected = collision.normal * collision.remainder.dot(collision.normal)
	# 	_linear_velocity = collision.remainder.slide(collision.normal) / delta
	# 	global_position += collision.travel + (_linear_velocity * delta)
	# else:
		global_position += _linear_velocity * delta


# Needs to be completed
func _apply_force(delta: float) -> void:
	_linear_velocity += _applied_force * delta


func _apply_damp(delta: float) -> void:
	var ld = LINEAR_DAMP * delta
	var ad = ANGULAR_DAMP * delta
	if _linear_velocity != Vector2.ZERO:
		_linear_velocity -= _linear_velocity.normalized() * ld if _linear_velocity.length() > ld else _linear_velocity
	if _angular_velocity != 0.0:
		_angular_velocity -= ad if abs(_angular_velocity) > ad else _angular_velocity



	# global_rotation += 0.01
	# global_position += Vector2(2, -2)
	# if Input.is_action_just_pressed("ui_down"):
	# 	_linear_velocity += Vector2(100.0, -1000.0)



	# if !is_on_floor():
	# 	_linear_velocity.y += _gravity * delta
	# ._physics_process(delta)


	# _linear_velocity = move_and_slide(_linear_velocity, UP)	_linear_velocity = move_and_slide_linear_velocity, UP)


# func apply_impulse(impulse_force: Vector2, impulse_position: Vector2 = Vector2.ZERO) -> void:
# 	if rotation_locked:
# 		_linear_velocity += impulse_force
# 		return
