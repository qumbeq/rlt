extends TileMap

var pathfind
var ai

var shared = {}
var listen = {}

var grid = {}

var moving_active = false
var vol = 0
var overpath = []

func _ready():
	
	ext_loader()
	grid_init()
	
func ext_loader():
	
	var pathfind_source = load("res://scripts/pathfinder.gd")
	pathfind = pathfind_source.new()
	pathfind.grid = grid
	
	var ai_source = load("res://scripts/ai.gd")
	ai = ai_source.new()
	ai.grid = grid
	ai.shared = shared
	ai.battlefield = self
	
func _process(delta):
	
	var cur = get_global_mouse_position()
	shared.sel_cell = world_to_map(cur)
	
	draw_listener()
	move_process(delta)
	
func _physics_process(delta):
	#print(shared)
	pass

func place_units():
	
	for unit in shared.player_characters:
		unit.position = map_to_world(unit.pos)
		grid[unit.pos] = 5
		
	for unit in shared.enemy_characters:
		unit.position = map_to_world(unit.pos)
		grid[unit.pos] = 6
	

func grid_init():
	
	var tiles = get_used_cells()
	for tile in tiles:
		grid[tile] = get_cell(tile.x, tile.y)

func ability_active():
	
	if shared.active_ability != null:
		shared.targets = shared.active_ability.activated(shared.sel_char, grid)
	else:
		shared.targets.clear()
	clear_path()

func move_process(delta):
	
	if moving_active:
		var from = map_to_world(get_wp(1))
		var to = map_to_world(get_wp(2))
		
		if shared.sel_char.position != to:
			vol = clamp(shared.sel_char.speed * delta + vol, 0, 1)
			shared.sel_char.position = from.linear_interpolate(to, vol)
		else: 
			vol = 0
			shared.sel_char.stamina -= shared.path[get_wp(2)]
			if shared.path.size() > 2:
				shared.path.erase(get_wp(1))
			else:
				shared.path.clear()
				overpath.clear()
				moving_active = false
		
func move():
	
	grid[get_wp(1)] = 0
	grid[get_wp('last')] = 5
	shared.sel_char.pos = get_wp('last')
	moving_active = true

func get_char(vector):
	
	for pchar in shared.player_characters:
		if pchar.pos == vector:
			return pchar
	for echar in shared.enemy_characters:
		if echar.pos == vector:
			return echar

func select_char(pos):
	
	shared.sel_char = get_char(pos)
	
func get_wp(q):
	
	if str(q) == 'last':
		return shared.path.keys()[shared.path.size() - 1]
	elif q == 1:
		return shared.path.keys()[0]
	elif q == 2:
		return shared.path.keys()[1] 
		
	
func tile_move_cost(tile):
	
	if grid[tile] == 0:
		return 1
	else:
		return 0

func clear_path():
	
	shared.path.clear()
	overpath.clear()

func calc_path(path):
	
	var result = {}
	var tilecost
	var stamina = shared.sel_char.stamina
	overpath.clear()
	for wp in path:
		tilecost = tile_move_cost(wp) * shared.sel_char.move_cost
		if stamina >= tilecost:
			stamina -= tilecost
			result[wp] = tilecost
		else:
			overpath.append(wp)
	if result.size() > 1:
		shared.path = result.duplicate()

func draw_listener():
	
	if listen.size() == 0:
		listen = shared.duplicate()
	if listen.sel_char != shared.sel_char:
		shared.active_ability = null
		clear_path()
		listen.sel_char = shared.sel_char
	if listen.active_ability != shared.active_ability:
		shared.targets.clear()
		ability_active()
		listen.active_ability = shared.active_ability

func _input(event):
	if !moving_active and shared.turn:
		if grid.has(shared.sel_cell):
			if event.is_action_pressed("mouse_left"):
				if shared.active_ability == null:
					if grid[shared.sel_cell] == 5 or grid[shared.sel_cell] == 6:
							select_char(shared.sel_cell)
					elif shared.sel_char != null and shared.sel_char.ally:
						if shared.path.size() > 0 and shared.sel_cell == get_wp('last'):
							move()
						elif grid[shared.sel_cell] == 0 and shared.active_ability == null:
							calc_path(pathfind.search(shared.sel_char.pos, shared.sel_cell))
				
				elif shared.targets.has(shared.sel_cell) and shared.targets[shared.sel_cell] == 1:
					shared.active_ability.use(shared.sel_char, get_char(shared.sel_cell))
					
		if event.is_action_pressed("mouse_right"):
			shared.active_ability = null
