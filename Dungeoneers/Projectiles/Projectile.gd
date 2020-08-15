extends Node2D

const Explosion = preload("res://Effects/Explosion.tscn")

var speed = 200

onready var sprite = $Sprite
onready var hitbox = $Hitbox
onready var particle = $Fireball
onready var spawnTimer = $SpawnTimer

func shoot(start_pos):
	self.global_position = start_pos
	var direction = (start_pos.direction_to(get_global_mouse_position())).normalized()
	var angle = start_pos.angle_to_point(get_global_mouse_position())
	particle.rotate(angle)
	hitbox.knockback_vector = direction
	self.linear_velocity = direction * speed
	sprite.rotate(get_global_mouse_position().angle_to_point(global_position))
	hitbox.rotate((global_position).angle_to_point(get_global_mouse_position()))
	hitbox.monitoring = false
	spawnTimer.start(0.01)

func create_explosion():
	var explosion = Explosion.instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position

func _on_Hitbox_area_entered(_area):
	create_explosion()
	queue_free()

func _on_Hitbox_body_entered(body):
	if body is TileMap or KinematicBody2D:
		create_explosion()
		queue_free()

func _on_SpawnTimer_timeout():
	hitbox.monitoring = true
