extends GridContainer

var ability # Base ability class
var shared = {}

var abilities = {}
var buttons = {}


func _ready():
	
	ext_loader()
	
	

func _process(delta):
	
	pass
	
func ext_loader():
	
	ability = preload("res://scripts/abilities/ability.gd").new()

func panel_update():
		
		remove_buttons()
		if shared.sel_char.ally:
			parse_abilities(shared.sel_char)


func parse_abilities(sc):
	
	for id in sc.abilities:
		abilities[id] = ability.get_ability(id)
		add_button(abilities[id])

func add_button(a):
	
	var button = $Ability.duplicate(8)
	buttons[a.id] = button
	button.texture_normal = load(a.icon)
	button.visible = true
	button.connect("toggled", self, 'ability_toggle', [a.id])
	add_child(button)

func remove_buttons():
	
	for button in buttons.values():
		button.queue_free()
	abilities.clear()
	buttons.clear()
	shared.active_ability = null
	

func ability_toggle(status, id):
	
	if status:
		for button_id in buttons.keys():
			if button_id != id:
				buttons[button_id].pressed = false
		shared.active_ability = abilities[id]
	else:
		shared.active_ability = null
	
	
