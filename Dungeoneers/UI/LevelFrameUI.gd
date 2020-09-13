extends Control

var element = Spellbook.current_element setget set_element

onready var frameElement = $Element

func set_element(value):
	frameElement.texture = load(Spellbook.textures[value])

func _ready():
	self.element = Spellbook.current_element
# warning-ignore:return_value_discarded
	Spellbook.connect("element_changed", self, "set_element")
