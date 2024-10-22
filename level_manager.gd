extends Node2D

@export var bosses : Array[PackedScene]
var current_boss
var current_id := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instantiate_boss()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_boss_death():
	current_boss.queue_free()
	current_id += 1
	if current_id < len(bosses):
		instantiate_boss()
	else:
		get_tree().quit()

func instantiate_boss():
	current_boss = bosses[current_id].instantiate()
	current_boss.global_transform = Transform2D(0, Vector2(0, -840))
	add_child(current_boss)
	current_boss.get_child(0).get_child(0).get_child(0).connect("on_death", on_boss_death)  # Cringe (:
