extends Area2D

var spawn_timer : float
@export var life_expectancy: float = 5
@export var speed : int = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta
	spawn_timer += delta
	if spawn_timer > life_expectancy:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	body.emit_signal("on_hit", 1)
	queue_free()
