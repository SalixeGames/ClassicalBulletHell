extends Label


@export var enemy: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_text("Life: %s" % enemy.life) # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(enemy):
		set_text("Life: %s" % enemy.life)
	else:
		set_text("Dead")
