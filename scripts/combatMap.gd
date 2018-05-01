extends TileMap

var pathfind

var sel_cell = Vector2()
var sel_char

var grid = {}
var ogrid = {} #original grid

var player_characters = []
var enemy_characters = []

var path = []
var moving_active = false
var vol = 0


func _ready():
	
	ext_loader()
	grid_init()
	

func ext_loader():
	
	var pathfind_source = load("res://scripts/pathfinder.gd")
	pathfind = pathfind_source.new()
	pathfind.grid = grid
	
func _process(delta):
	
	var cur = get_global_mouse_position()
	sel_cell = world_to_map(cur)
	move_process(delta)
	
func _physics_process(delta):
	
	pass
	
func place_units():
	
	for unit in player_characters + enemy_characters:
		unit.position = map_to_world(unit.pos)
		grid[unit.pos] = 5
	

func grid_init():
	
	var tiles = get_used_cells()
	for tile in tiles:
		grid[tile] = get_cell(tile.x, tile.y)
	ogrid = grid.duplicate()

func move_process(delta):
	
	if moving_active:
		var from = map_to_world(path[0])
		var to = map_to_world(path[1])
		
		if sel_char.position != to:
			vol = clamp(sel_char.speed * delta + vol, 0, 1)
			sel_char.position = from.linear_interpolate(to, vol)
		else: 
			vol = 0
			if path.size() > 2:
				path.pop_front()
			else:
				path.clear()
				moving_active = false
		
func move():
	
	grid[path.front()] = 0
	grid[path.back()] = 5
	sel_char.pos = path.back()
	moving_active = true

func get_char(vector):
	
	for pchar in player_characters:
		if pchar.pos == vector:
			return pchar

func ability_active(status, id):
	#print(id, status)
	pass
	

func _input(event):
	if !moving_active:
		if grid.has(sel_cell):
			if event.is_action_pressed("mouse_left"):
				if grid[sel_cell] == 5:
						sel_char = get_char(sel_cell)
						path.clear()
				elif sel_char != null:
					if path.size() > 0 and sel_cell == path.back():
						move()
					elif grid[sel_cell] == 0:
						path.clear()
						path = pathfind.search(sel_char.pos, sel_cell)
						
					
			if event.is_action_pressed("mouse_right"):
				pass
				