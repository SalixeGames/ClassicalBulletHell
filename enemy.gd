extends CharacterBody2D

@export var paths : Array[PackedScene]
@export var path_index: int = 0

@export var speed = 300.0
@export var rotation_speed := PI/4
@export var projectile : PackedScene
@export var path_follow : PathFollow2D
@export var top_node : Node2D

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
	spawn_bullet(BulletPattern.new(0, 32, 0.1, 10))
	if Input.is_action_just_pressed("change_path"):
		change_path()
	
func spawn_bullet(pattern: BulletPattern):
	if can_shoot:
		for i in pattern.n_angles:
			for j in pattern.n_simult:
				var bullet_instance = projectile.instantiate()
				var angle = pattern.get_angle(i, j)
				bullet_instance.global_transform = global_transform 
				bullet_instance.rotation = pattern.get_angle(i, j)
				if angle >= PI:
					angle = rotation_speed
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

class BulletPattern:
	var init_angle : float
	var n_angles : int
	var latency : float
	var n_simult : int
	
	func _init(p_init_angle: float = 0, p_n_angles: int = 1, p_latency: float = 0.1, p_n_simult: int = 1) -> void:
		init_angle = p_init_angle
		n_angles = p_n_angles
		latency = p_latency
		n_simult = p_n_simult
	
	func get_angle(angle_index, angle_number):
		var offset_index := calculate_angle_offset(angle_index, n_angles)
		var offset_number := calculate_angle_offset(angle_number, n_simult)
		return init_angle + offset_index + offset_number
		
	func calculate_angle_offset(angle_id, n_angles) -> float:
		return (angle_id * ((2 * PI)/n_angles))
		
