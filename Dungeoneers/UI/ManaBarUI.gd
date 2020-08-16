extends Control

var mana = 4 setget set_mana
var max_mana = 4 setget set_max_mana

onready var fill = $Fill
onready var jewel = $Jewel

func set_mana(value):
	mana = clamp(value, 0, max_mana)
	if fill != null:
		fill.rect_size.x = 26 * mana/max_mana
	
func set_max_mana(value):
	max_mana = max(value, 1)
	self.mana = min(mana, max_mana)
	
func show_jewel():
	jewel.visible = true
	
func hide_jewel():
	jewel.visible = false
	
func _ready():
	self.max_mana = PlayerStats.max_mana
	self.mana = PlayerStats.mana
# warning-ignore:return_value_discarded
	PlayerStats.connect("mana_changed", self, "set_mana")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_mana_changed", self, "set_max_mana")
# warning-ignore:return_value_discarded
	PlayerStats.connect("full_mana", self, "show_jewel")
# warning-ignore:return_value_discarded
	PlayerStats.connect("out_of_mana", self, "hide_jewel")
