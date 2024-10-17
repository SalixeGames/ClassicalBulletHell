extends Node2D

@export var paths : Array[PackedScene]
@export var path_index: int = 0

@export var speed = 300.0
@export var rotation_speed := PI/4
@export var projectile : PackedScene
@export var path_follow : PathFollow2D
@export var character_body : CharacterBody2D

var can_shoot := true
var angle : float = PI / 2


func _ready() -> void:
	change_path()

func _physics_process(delta: float) -> void:
	path_follow.progress += speed * delta

func _process(delta: float) -> void:
	spawn_bullet()
	if Input.is_action_just_pressed("ui_accept"):
		change_path()
	
func spawn_bullet():
	if can_shoot:
		var bullet_instance = projectile.instantiate()
		bullet_instance.global_transform = character_body.global_transform 
		bullet_instance.rotation = angle
		print("Avant: ", angle / PI)
		angle += rotation_speed
		if angle >= PI:
			angle = rotation_speed
		print("Apres: ", angle / PI)
		get_parent().add_child(bullet_instance)
		can_shoot = false
		await  get_tree().create_timer(0.5).timeout
		can_shoot = true

func change_path():
	var path = paths[path_index].instantiate()
	add_child(path)
	path_follow.reparent(path)
	path_index += 1
	if path_index == len(paths):
		path_index = 0
