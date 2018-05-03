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
	'path': []
	}

func _ready():
	init_share()
	randomize()
	spawn(2, player, shared.player_characters)
	spawn(2, enemy, shared.enemy_characters)
	
func _process(delta):
	pass

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
	