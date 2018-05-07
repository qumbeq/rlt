extends "res://scripts/abilities/ability.gd"

var damage = 15

func _init():
	id = 0
	name = "Basic Attack"
	icon = "res://sprites/icons/W_Sword001.png"
	type = "attack"
	cost = 15
	
func activated(unit, grid):
	
	return target_melee_single(unit, grid)
	
func use(unit, target):
	
	target.take_damage(damage)
	unit.use_stamina(cost)