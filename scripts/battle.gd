extends Node

onready var player = preload("res://scenes/player.tscn")
onready var enemy = preload("res://scenes/enemy.tscn")

onready var player_characters = $BattleField.player_characters
onready var enemy_characters = $BattleField.enemy_characters

var spawns = [Vector2(0,0), Vector2(0,1), Vector2(0,2), Vector2(1,0), Vector2(1,1), Vector2(1,2), Vector2(2,0), Vector2(2,1)]


func _ready():
	randomize()
	spawn(2, player, player_characters)
	spawn(2, enemy, enemy_characters)
	
func _process(delta):
	pass

func spawn(count, type, array):
	
	for i in range(count):
		var spawn_loc = spawns[randi() % (spawns.size() - 1)]
		spawns.erase(spawn_loc)
		array.append(type.instance().spawn(spawn_loc, self))
	$BattleField.place_units()
	