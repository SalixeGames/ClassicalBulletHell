extends Node2D

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D

@export var speed = 300.0
@export var projectile : PackedScene

var can_shoot := true

func _physics_process(delta: float) -> void:
	path_follow.progress += speed * delta

func _process(delta: float) -> void:
	spawn_bullet()
	
func spawn_bullet():
	if can_shoot:
		var bullet_instance = projectile.instantiate()
		bullet_instance.global_transform = $Path2D/PathFollow2D/CharacterBody2D.global_transform
		bullet_instance.rotation = PI / 2
		get_parent().add_child(bullet_instance)
		can_shoot = false
		await  get_tree().create_timer(0.1).timeout
		can_shoot = true
