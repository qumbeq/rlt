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
