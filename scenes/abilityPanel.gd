extends GridContainer

onready var abilities = {0: null, 1: null}
var ability



func _ready():
	
	ext_loader()
	for id in abilities.keys():
		abilities[id] = ability.get_ability(id)
		add_button(abilities[id])
		
		#call_deferred("add_button", abilities[id])
		#ability.connect('toggled', get_node("../../BattleField"), "ability_active", [ability])
		
func _gui_input(event):
	
	if event.is_pressed():
		printt(event)
		

func ext_loader():
	
	ability = preload("res://scripts/abilities/ability.gd").new()

func add_button(a):
	
	var button = $Ability.duplicate(8)
	print(a.icon)
	button.texture_normal = load(a.icon)
	button.connect("toggled", self, 'ability_toggle', [a.id])
	add_child(button)
	
func ability_toggle(status, id):
	printt(a, id)