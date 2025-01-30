extends CharacterBody2D


var can_shoot = true
var intagible = false

@export_category("Scallable Stats")
@export var id : String = "Player"
@export var patterns : Array[BulletPattern]
@export var life : int = 7
@export var speed = 750.0
@export var slow_speed = 250

@export_category("Noises")
@export var hurt_noise : AudioStreamMP3
@export var  shoot_noise : AudioStreamMP3
@export var death_noise :  AudioStreamMP3


func _enter_tree() -> void:
	Callable.create(0, "test")

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_pressed("shoot") and can_shoot and not intagible:
		$AnimationTree.set("parameters/Transition/transition_request", "shooting")
		$SoundPlayer.stream = death_noise
		$SoundPlayer.play()
		for bullet_instance in patterns[0].get_projectiles(global_transform, 2, 1):
			get_parent().add_child(bullet_instance)
		
		can_shoot = false
		await  get_tree().create_timer(patterns[0].latency).timeout
		can_shoot = true
		if not intagible:
			$AnimationTree.set("parameters/Transition/transition_request", "idle")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var active_speed = speed
	if Input.is_action_pressed("slow"):
		active_speed = slow_speed
	if direction:
		velocity.x = direction.x * active_speed
		velocity.y = direction.y * active_speed
	else:
		velocity.x = move_toward(velocity.x, 0, active_speed)
		velocity.y = move_toward(velocity.y, 0, active_speed)

	move_and_slide()

func got_hit(value: int):
	if not intagible and get_tree():
		$AnimationTree.set("parameters/Transition/transition_request", "hurt")
		life -= value
		
		if life <= 0:
			die()
			
		var old_speed = speed
		speed = old_speed * 2
		
		$SoundPlayer.stream = hurt_noise
		$SoundPlayer.play()
		
		intagible = true
		if get_tree():
			await  get_tree().create_timer(3).timeout
		intagible = false
		$AnimationTree.set("parameters/Transition/transition_request", "idle")
		speed = old_speed

func die():
	$SoundPlayer.stream = death_noise
	$SoundPlayer.play()
	await get_tree().create_timer(0.5).timeout
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
