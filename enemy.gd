extends CharacterBody2D

@export var paths : Array[PackedScene]
@export var path_index: int = 0

@export var speed = 300.0
@export var rotation_speed := PI/4
@export var path_follow : PathFollow2D
@export var top_node : Node2D
@export var patterns : Array[BulletPattern]

var can_shoot := true
var life : int = 7
var old_progress : int = 0


func _ready() -> void:
	change_path()

func _physics_process(delta: float) -> void:
	old_progress = path_follow.progress
	path_follow.progress += speed * delta
	if old_progress > path_follow.progress:
		change_path()

func _process(delta: float) -> void:
	spawn_bullet(patterns[0])
	if Input.is_action_just_pressed("change_path"):
		change_path()
	
func spawn_bullet(pattern: BulletPattern):
	if can_shoot:
		for i in pattern.n_angles:
			for j in pattern.n_simult:
				var bullet_instance = pattern.projectile.instantiate()
				var angle = pattern.get_angle(i, j)
				bullet_instance.global_transform = global_transform 
				bullet_instance.rotation = pattern.get_angle(i, j)
				top_node.get_parent().add_child(bullet_instance)
			can_shoot = false
			await  get_tree().create_timer(pattern.latency).timeout
			can_shoot = true

func change_path():
	var path = paths[path_index].instantiate()
	top_node.add_child(path)
	var old_path = path_follow.get_parent()
	path_follow.reparent(path)
	if path.name != old_path.name:  # surelly there is a better way monka
		old_path.queue_free()
	path_index += 1
	if path_index == len(paths):
		path_index = 0

func got_hit(value: int):
	life -= value
	if life <= 0:
		die()

func die():
	queue_free()

signal on_hit(life : int)
