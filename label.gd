extends Label


@export var enemy: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_text("Life: %s" % enemy.life) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enemy_hit(life : int):
	set_text("Life: %s" % enemy.life)
