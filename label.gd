extends Label


@export var enemy: CharacterBody2D
var text_base = "{id}: {life}"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_text(text_base.format({"id": enemy.id, "life": enemy.life})) # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(enemy):
		set_text(text_base.format({"id": enemy.id, "life": enemy.life}))
	else:
		set_text("Dead")
