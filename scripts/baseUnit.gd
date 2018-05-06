extends Node2D

var pos = Vector2()
var groupname
var max_health = 100
var health = 100
var max_stamina = 100
var stamina = 100
var speed = 10
var ally
var move_cost
var portrait = preload("res://sprites/portrait.png")

func _ready():
	pass
	
func init():
	
	add_to_group(groupname)
	move_cost = 100 / speed
	z_index = 1
	
func _physics_process(delta):

	pass

func get_unit_childrens():
	
	var childrens = get_tree().get_nodes_in_group(groupname)
	return childrens
	
func spawn(pos, node):
	
	node.add_child(self, true)
	self.pos = pos
	return self

func take_damage(dmg):
	
	health -= dmg

func start_turn():
	
	stamina = clamp(stamina + 35, 0, max_stamina) 
	 
func end_turn():
	pass