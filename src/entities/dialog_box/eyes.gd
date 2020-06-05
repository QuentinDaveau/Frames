extends Node2D

const MAX_DISPLACEMENT: float = 10.0

onready var _left_iris: Node2D = get_node("LeftEye/Iris")
onready var _right_iris: Node2D = get_node("RightEye/Iris")

var _target: Node2D = null

func _process(delta: float) -> void:
	if _target:
		var look_dir:= (_target.global_position - global_position).clamped(MAX_DISPLACEMENT)
		_left_iris.position = look_dir
		_right_iris.position = look_dir


func set_target(target: Node2D) -> void:
	_target = target
