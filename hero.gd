extends CharacterBody2D


const SPEED = 750.0
@export var projectile : PackedScene


func _enter_tree() -> void:
	Callable.create(0, "test")
	
func got_hit():
	queue_free()

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("shoot"):
		var bullet_instance = projectile.instantiate()
		bullet_instance.global_transform = global_transform 
		bullet_instance.rotation = -PI/2
		bullet_instance.collision_mask = 2
		bullet_instance.collision_layer = 1
		get_parent().add_child(bullet_instance)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
