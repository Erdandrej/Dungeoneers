extends Control

var mana = 4 setget set_mana
var max_mana = 4 setget set_max_mana

onready var fill = $Fill

func set_mana(value):
	mana = clamp(value, 0, max_mana)
	if fill != null:
		fill.rect_size.x = 57 * mana/max_mana
	
func set_max_mana(value):
	max_mana = max(value, 1)
	self.mana = min(mana, max_mana)
	
func _ready():
	self.max_mana = PlayerStats.max_mana
	self.mana = PlayerStats.mana
# warning-ignore:return_value_discarded
	PlayerStats.connect("mana_changed", self, "set_mana")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_mana_changed", self, "set_max_mana")
