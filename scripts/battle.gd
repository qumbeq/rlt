extends Node

onready var player = preload("res://scenes/player.tscn")
onready var enemy = preload("res://scenes/enemy.tscn")

var spawns = [Vector2(0,0), Vector2(0,1), Vector2(0,2), Vector2(1,0), Vector2(1,1), Vector2(1,2), Vector2(2,0), Vector2(2,1)]

var shared = {
	'sel_char': null, 
	'sel_cell': Vector2(),  
	'active_ability': null,
	'player_characters': [],
	'enemy_characters': [],
	'path': {}
	}

var listen = {
	'sel_char': null
	}
var kek = false

func _ready():
	init_share()
	randomize()
	spawn(2, player, shared.player_characters)
	spawn(2, enemy, shared.enemy_characters)
	
func _process(delta):
	
	ui_listener()
	

func init_share():
	
	$BattleField.shared = shared
	$DrawNode.shared = shared
	$UI/AbilityPanel.shared = shared

func spawn(count, type, array):
	
	for i in range(count):
		var spawn_loc = spawns[randi() % (spawns.size() - 1)]
		spawns.erase(spawn_loc)
		array.append(type.instance().spawn(spawn_loc, self))
	$BattleField.place_units()

func ui_listener():
	
	if listen.sel_char != shared.sel_char:
		$UI/AbilityPanel.call('panel_update')
		$UI/Character.call('update_character_panel', shared.sel_char)
		listen.sel_char = shared.sel_char
	if $BattleField.moving_active:
		$UI/Character.call('update_character_panel', shared.sel_char)
		kek = true
	elif kek:
		$UI/Character.call('update_character_panel', shared.sel_char)
		kek = false