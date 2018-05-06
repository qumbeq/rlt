extends Node

onready var player = preload("res://scenes/player.tscn")
onready var enemy = preload("res://scenes/enemy.tscn")

var spawns = [Vector2(0,0), Vector2(0,1), Vector2(0,2), Vector2(1,0), Vector2(1,1), Vector2(1,2), Vector2(2,0), Vector2(2,1)]

var shared = {
	'sel_char': null, 
	'sel_cell': Vector2(), 
	'targets': {}, 
	'active_ability': null,
	'player_characters': [],
	'enemy_characters': [],
	'path': {},
	'turn': true
	}

var listen = {
	'sel_char': null
	}


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
		listen.sel_char = shared.sel_char
	if shared.sel_char != null:
		$UI/Character.call('update_character_panel', shared.sel_char)
	

func _input(event):
	
	if event.is_action_pressed('end_turn') and shared.turn == true:
		end_turn()

func end_turn():
	
	if shared.turn == true:
		shared.turn = false
		get_tree().call_group('PlayerCharacters', 'end_turn')
		get_tree().call_group('EnemyCharacters', 'start_turn')
		$BattleField.ai.ai_turn()
		end_turn()
		
		
	elif shared.turn == false:
		shared.turn = true
		get_tree().call_group('PlayerCharacters', 'start_turn')
		get_tree().call_group('EnemyCharacters', 'end_turn')
		