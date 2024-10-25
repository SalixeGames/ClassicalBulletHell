class_name BulletPattern
extends Resource


@export var init_angle : float
@export var n_angles : int
@export var latency : float
@export var n_simult : int
@export var projectile : PackedScene
@export var projectile_speed : float = 300

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

func get_projectiles(parent_global_transform, mask=1, layer=1):
	var bullets : Array = []
	for i in n_angles:
		for j in n_simult:
			bullets.append(get_projectile(parent_global_transform, mask, layer, i, j))
	return bullets

func get_projectile(parent_global_transform, mask, layer, i, j):
	var bullet_instance =  projectile.instantiate()
	bullet_instance.global_transform = parent_global_transform 
	bullet_instance.rotation = get_angle(i, j)
	bullet_instance.collision_mask = mask
	bullet_instance.collision_layer = layer
	bullet_instance.speed = projectile_speed
	return bullet_instance
