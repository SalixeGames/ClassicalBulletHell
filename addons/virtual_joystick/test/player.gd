extends Sprite2D

@export var speed : float = 100

var move_vector := Vector2.ZERO

func _process(delta: float) -> void:
	
	## Movement using Input functions:
	move_vector = Vector2.ZERO
	move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	position += move_vector * speed * delta
