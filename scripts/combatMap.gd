extends TileMap

var pathfind

var shared = {}

var grid = {}

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
	shared.sel_cell = world_to_map(cur)
	
	move_process(delta)
	
func _physics_process(delta):
	
	pass
	
func place_units():
	
	for unit in shared.player_characters + shared.enemy_characters:
		unit.position = map_to_world(unit.pos)
		grid[unit.pos] = 5
	

func grid_init():
	
	var tiles = get_used_cells()
	for tile in tiles:
		grid[tile] = get_cell(tile.x, tile.y)

func move_process(delta):
	
	if moving_active:
		var from = map_to_world(shared.path[0])
		var to = map_to_world(shared.path[1])
		
		if shared.sel_char.position != to:
			vol = clamp(shared.sel_char.speed * delta + vol, 0, 1)
			shared.sel_char.position = from.linear_interpolate(to, vol)
		else: 
			vol = 0
			if shared.path.size() > 2:
				shared.path.pop_front()
			else:
				shared.path.clear()
				moving_active = false
		
func move():
	
	grid[shared.path.front()] = 0
	grid[shared.path.back()] = 5
	shared.sel_char.pos = shared.path.back()
	moving_active = true

func get_char(vector):
	
	for pchar in shared.player_characters:
		if pchar.pos == vector:
			return pchar

func ability_active(status, id):
	#print(id, status)
	pass
	

func _input(event):
	if !moving_active:
		if grid.has(shared.sel_cell):
			if event.is_action_pressed("mouse_left"):
				if grid[shared.sel_cell] == 5:
						shared.sel_char = get_char(shared.sel_cell)
						$'../UI/AbilityPanel'.call('panel_update')
						shared.path.clear()
				elif shared.sel_char != null:
					if shared.path.size() > 0 and shared.sel_cell == shared.path.back():
						move()
					elif grid[shared.sel_cell] == 0:
						shared.path.clear()
						shared.path = pathfind.search(shared.sel_char.pos, shared.sel_cell)
						
					
			if event.is_action_pressed("mouse_right"):
				pass
				