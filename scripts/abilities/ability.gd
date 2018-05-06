extends Object

var id
var name
var type
var icon

var abilities = ['basicAttack', 'block'] 

#func _ready():


func get_ability(id):
	var ability = load("res://scripts/abilities/" + abilities[id] + ".gd").new()
	return ability

func target_self(unit):
	
	return unit
	
func target_melee_single(unit, grid):
	
	var targets = {}
	var enemy
	var tar
	
	if unit.ally:
		enemy = 6
	else:
		enemy = 5
	
	var directions = [
		Vector2(0, -1),
		Vector2(0, 1),
		Vector2(1, 0),
		Vector2(-1, 0)
		]
	
	for dir in directions:
		tar = unit.pos + dir
		if grid.has(tar):
			if grid[tar] == enemy:
				targets[tar] = 1
			elif grid[tar] == 0:
				targets[tar] = 0
	return targets
	