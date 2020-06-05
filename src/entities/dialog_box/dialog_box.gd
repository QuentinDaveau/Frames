extends Node2D

const MIN_PLAYER_DIST: float = 200.0
const MOVE_SMOOTH: float = 0.25

export(NodePath) var _player_path
export(float) var _aimed_scale: float = 1.0
export(Vector2) var _aimed_position: Vector2 = Vector2.ZERO

onready var _player: Actor = get_node(_player_path)

var _followed_entity: Node2D = null

var _offset: Vector2 = Vector2.ZERO
var _min_dist: float = 0.0


func _ready() -> void:
	follow_player()


func _physics_process(delta: float) -> void:
	if _followed_entity:
		var _followed_entity_position = _followed_entity.global_position
		if _offset:
			_aimed_position = _followed_entity_position + _offset
		else:
			_aimed_position = _followed_entity_position + (Vector2.RIGHT * _min_dist).rotated(
				global_position.angle_to_point(_followed_entity_position))
	
	global_position = lerp(global_position, _aimed_position, delta / (delta + MOVE_SMOOTH))
	scale = Vector2.ONE * _aimed_scale


func go_to_absolute_pos(position: Vector2) -> void:
	if _followed_entity:
		_set_followed_entity(null)
	_aimed_position = position


func go_to_relative_pos(position: Vector2, entity: Node2D = null) -> void:
	if _followed_entity:
		_set_followed_entity(null)
	_aimed_position = position + entity.global_position


func go_to_relative_pos_follow(position: Vector2, entity: Node2D) -> void:
	if _followed_entity:
		print_debug("Already following an entity!")
		return
	_set_followed_entity(entity)
	_offset = position


func follow(entity: Node2D, min_dist: float) -> void:
	if _followed_entity != entity:
		_set_followed_entity(entity)
	_offset = Vector2.ZERO
	_min_dist = min_dist


func translate_pos(translation: Vector2) -> void:
	if _followed_entity:
		_offset += translation
	else:
		_aimed_position += translation


func change_size(size: float) -> void:
	if size > 0:
		_aimed_scale = size


func follow_player() -> void:
	_set_followed_entity(_player)
	_min_dist = MIN_PLAYER_DIST
	_offset = Vector2.ZERO


func _set_followed_entity(value: Node2D) -> void:
	_followed_entity = value
	$Eyes.set_target(value)
