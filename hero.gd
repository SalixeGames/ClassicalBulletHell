extends CharacterBody2D


var can_shoot = true

@export_category("Scallable Stats")
@export var patterns : Array[BulletPattern]
@export var life : int = 7
@export var speed = 750.0


func _enter_tree() -> void:
	Callable.create(0, "test")

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_pressed("shoot") and can_shoot:
		for bullet_instance in patterns[0].get_projectiles(global_transform, 2, 1):
			get_parent().add_child(bullet_instance)
		
		can_shoot = false
		await  get_tree().create_timer(patterns[0].latency).timeout
		can_shoot = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()

func got_hit(value: int):
	life -= value
	if life <= 0:
		die()

func die():
	emit_signal("on_death")
	queue_free()

func update_speed(modificator : int):
	speed += modificator

func update_life(modificator : int):
	life += modificator

func update_cadency(modificator : int):
	for pattern in patterns:
		pattern.latency += float(modificator)/100

func update_bullet_speed(modificator : int):
	for pattern in patterns:
		pattern.projectile_speed += modificator

signal on_hit(life : int)
signal on_death()
