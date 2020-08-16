extends Node

export(int) var max_health = 1 setget set_max_health
var health = max_health setget set_health

export(int) var max_mana = 1 setget set_max_mana
var mana = max_mana setget set_mana

export(int) var max_xp = 1 setget set_max_xp
var xp = max_xp setget set_xp

var level = 1

signal no_health
signal health_changed(value)
signal max_health_changed(value)
signal full_mana
signal out_of_mana
signal mana_changed(value)
signal max_mana_changed(value)
signal next_level
signal xp_changed(value)
signal max_xp_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
	
func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		
func set_max_mana(value):
	max_mana = value
	self.mana = min(mana, max_mana)
	emit_signal("max_mana_changed", max_mana)
	
func set_mana(value):
	mana = clamp(value, 0, max_mana)
	emit_signal("mana_changed", mana)
	if mana == max_mana:
		emit_signal("full_mana")
	else:
		emit_signal("out_of_mana")

func set_max_xp(value):
	max_xp = value
	self.xp = min(xp, max_xp)
	emit_signal("max_xp_changed", max_xp)
	
func set_xp(value):
	xp = clamp(value, 0, max_xp)
	emit_signal("xp_changed", xp)
	if xp == max_xp:
		emit_signal("next_level")

func _ready():
	self.health = max_health
	self.mana = 0
	self.xp = 0
