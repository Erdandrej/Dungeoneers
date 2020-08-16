extends Node2D

export(int) var speed = 200
export(int) var damage = 1
export(float) var cooldown = 0.6
export(float) var spawn = 0.1
export var Effect = preload("res://Effects/Explosion.tscn")

onready var hitbox = $Hitbox
onready var particle = $Particle
onready var spawnTimer = $SpawnTimer

func shoot(start_pos):
	self.global_position = start_pos
	var direction = (start_pos.direction_to(get_global_mouse_position())).normalized()
	var angle = start_pos.angle_to_point(get_global_mouse_position())
	particle.rotate(angle)
	hitbox.knockback_vector = direction
	hitbox.damage = damage
	self.linear_velocity = direction * speed
	hitbox.rotate((global_position).angle_to_point(get_global_mouse_position()))
	hitbox.monitoring = false
	spawnTimer.start(spawn)

func create_effect():
	var explosion = Effect.instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position

func _on_Hitbox_area_entered(_area):
	create_effect()
	queue_free()

func _on_Hitbox_body_entered(body):
	if body is TileMap or KinematicBody2D:
		create_effect()
		queue_free()

func _on_SpawnTimer_timeout():
	hitbox.monitoring = true
