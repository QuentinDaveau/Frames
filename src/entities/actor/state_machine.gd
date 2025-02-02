extends Node
class_name ActorStateMachine

signal state_changed(current_state)

export(NodePath) var START_STATE

onready var DEVICE_ID: int = 0

var states_map = {}

var states_stack = []
var current_state = null
var _active = false setget set_active


func _ready():
	for child in get_children():
		child.connect("finished", self, "_change_state")
	_initialize(START_STATE)


func _unhandled_input(event):
	if event.device == DEVICE_ID:
		current_state.handle_input(event)


func _initialize(start_state):
	set_active(true)
	states_stack.push_front(get_node(start_state))
	current_state = states_stack[0]
	current_state.enter()


func set_active(value):
	_active = value
	set_physics_process(value)
	set_process_input(value)
	set_process(value)
#	if not _active:
#		states_stack = []
#		current_state = null


func _physics_process(delta: float) -> void:
	current_state.update(delta)


func _on_animation_finished(anim_name):
	if not _active:
		return
	current_state._on_animation_finished(anim_name)


func _initialize_state() -> void:
	pass


func _change_state(state_name):
	if not _active:
		return
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]
	
	_initialize_state()
	
	current_state = states_stack[0]
	
	emit_signal("state_changed", current_state)
	
	current_state.enter()
