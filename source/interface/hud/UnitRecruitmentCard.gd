extends Control

signal unit_recruitment_card_clicked

onready var avatar := $UnitRecruitmentCardHbox/Avatar as TextureRect

var unit_type : Node

func initialize(unit_type : UnitType) -> void:
	avatar.texture = unit_type.find_node("Sprite").texture
	self.unit_type = unit_type
	

func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("unit_recruitment_card_clicked", unit_type)
