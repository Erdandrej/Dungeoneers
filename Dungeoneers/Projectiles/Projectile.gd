extends Node2D

const Explosion = preload("res://Effects/Explosion.tscn")

var speed = 200

onready var sprite = $Sprite
onready var hitbox = $Hitbox
onready var particle = $Particles2D

func shoot(start_pos):
	self.global_position = start_pos
	var direction = (start_pos.direction_to(get_global_mouse_position())).normalized()
	var angle = start_pos.angle_to_point(get_global_mouse_position())
	particle.rotate(angle)
	hitbox.knockback_vector = direction
	self.linear_velocity = direction * speed
	sprite.rotate(get_global_mouse_position().angle_to_point(global_position))

func _on_Hitbox_area_entered(area):
	create_explosion()
	queue_free()

func _on_Hitbox_body_entered(body):
	if body is TileMap or KinematicBody2D:
		create_explosion()
		queue_free()
		
func create_explosion():
	var explosion = Explosion.instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
