extends RayCast2D

export(float) var GROUNDED_DELAY = 0.1

var _grounded: bool = false

func _ready():
	$GroundedDelay.connect("timeout", self, "_grounded_timeout")


func _physics_process(delta):
	if _grounded:
		if !is_colliding():
			if $GroundedDelay.is_stopped():
				$GroundedDelay.start(GROUNDED_DELAY)
	else:
		if is_colliding():
			_grounded = true


func is_grounded() -> bool:
	return _grounded


func jumping_disable(delay) -> void:
	enabled = false
	_grounded = false
	$GroundedDelay.start(delay)


func _grounded_timeout() -> void:
	if !enabled:
		enabled = true
	if !is_colliding():
		_grounded = false
	
