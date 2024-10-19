extends CharacterBody2D

@export var paths : Array[PackedScene]
@export var path_index: int = 0

@export var speed = 300.0
@export var rotation_speed := PI/4
@export var projectile : PackedScene
@export var path_follow : PathFollow2D
@export var top_node : Node2D

var can_shoot := true
var angle : float = PI / 2
var life : int = 7


func _ready() -> void:
	change_path()

func _physics_process(delta: float) -> void:
	path_follow.progress += speed * delta

func _process(delta: float) -> void:
	spawn_bullet()
	if Input.is_action_just_pressed("change_path"):
		change_path()
	
func spawn_bullet():
	if can_shoot:
		var bullet_instance = projectile.instantiate()
		bullet_instance.global_transform = global_transform 
		bullet_instance.rotation = angle
		if angle >= PI:
			angle = rotation_speed
		top_node.get_parent().add_child(bullet_instance)
		can_shoot = false
		await  get_tree().create_timer(0.5).timeout
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
