extends Area2D

var spawn_timer : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * 200 * delta
	spawn_timer += delta
	if spawn_timer > 2:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	body.call_deferred("got_hit")
	print(body.name)
	queue_free()
