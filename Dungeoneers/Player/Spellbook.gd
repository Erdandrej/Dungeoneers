extends Node

enum {
	FIRE,
	ICE
}

const primary_casts = ["res://Projectiles/Fireball.tscn", "res://Projectiles/Icelance.tscn"]
const secondary_casts = ["res://Projectiles/Fireblast.tscn", "res://Projectiles/IceFlurry.tscn"]
const textures = ["res://UI/fire.png", "res://UI/ice.png"]

var current_element = FIRE setget set_element

signal element_changed(element)

func set_element(value):
	current_element = value
	emit_signal("element_changed", current_element)
