extends Node

var to = Vector2()
var result = []
var grid = {}

func _ready():
	pass
	
func _process(delta):
	pass
	
func pathfind(from, to):
	self.to = to
	search([from])
	#result.pop_front()
	return result
	
func search(route):
	#print(route)
	var rt
	var waypoints = []
	var cp = route.back()
	
	if cp != to:
		if route.size() < result.size() or result.size() == 0:
			waypoints = find_nearest(cp)
			if waypoints.size() > 0:
				for wp in waypoints:
					if !route.has(wp):
						rt = route.duplicate()
						rt.append(wp)
						search(rt)
	else:
		result = route.duplicate()

func diff(pos):
	
	var diff = to - pos
	return diff

func find_nearest(pos):
	
	var bp = []  #backward waypoints
	var try
	var fp = []  #forward waypoints
	try = Vector2(pos.x + 1, pos.y)
	if grid.has(try) and grid[try] == 0:
		if diff(pos).x > 0:
			fp.append(try)
		else:
			bp.append(try)
	try = Vector2(pos.x - 1, pos.y)
	if grid.has(try) and grid[try] == 0:
		if diff(pos).x < 0:
			fp.append(try)
		else:
			bp.append(try)
	try = Vector2(pos.x, pos.y + 1)
	if grid.has(try) and grid[try] == 0:
		if diff(pos).y > 0:
			fp.append(try)
		else:
			bp.append(try)
	try = Vector2(pos.x, pos.y - 1)
	if grid.has(try) and grid[try] == 0:
		if diff(pos).y < 0:
			fp.append(try)
		else:
			bp.append(try)
	return fp+bp
	