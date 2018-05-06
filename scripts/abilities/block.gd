extends "res://scripts/abilities/ability.gd"


func _init():
	id = 1
	name = "Basic Attack"
	icon = "res://sprites/icons/E_Metal07.png"
	type = "attack"

func activated(unit, grid):
	
	target_self(unit)
	
