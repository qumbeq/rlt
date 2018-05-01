extends Node2D

var pos = Vector2()
var groupname
var health = 100
var stamina = 100
var speed = 10


func _ready():
	pass
	
func init():
	add_to_group(groupname)
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
