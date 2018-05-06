extends Node2D
onready var BattleField = get_node("../BattleField")

var shared = {}

var color = Color(.2,.5,.2)
var color2 = Color(.5,.2,.2)
var color3 = Color(.8,.2,.2)
var color4 = Color(1, 0, 0, .3)
var line = 3
var p = Vector2(30,15)


func _ready():
	pass

func _process(delta):
	
	update()
	
func _draw():
	
	if shared.sel_char != null:
		if shared.sel_char.ally:
			draw_outline(shared.sel_char, color)
		else:
			draw_outline(shared.sel_char, color2)
		
	if shared.path.size() > 0:
		for wp in shared.path:
			var offset = BattleField.map_to_world(wp)
			offset.y += 15
			if wp == BattleField.get_wp('last'):
				draw_circle(offset, 10, color)
			draw_circle(offset, 5, color)
	
	if BattleField.overpath.size() > 0:
		for wp in BattleField.overpath:
			var offset  = BattleField.map_to_world(wp)
			offset.y += 15
			draw_circle(offset, 5, color2) 

	if shared.targets.size() > 0:
		
		for cell in shared.targets.keys():
			if shared.targets[cell] == 0:
				draw_cell(cell, color4)
			if shared.targets[cell] == 1:
				draw_cell(cell, color3)

func draw_cell(cell, color):
	
	var offset = BattleField.map_to_world(cell)
	var points = PoolVector2Array()
	offset.y += 16
	offset.x += 3
	points.append(offset+Vector2(0,-p.y))
	points.append(offset+Vector2(-p.x,0))
	points.append(offset+Vector2(0,p.y))
	points.append(offset+Vector2(p.x,0))
	draw_colored_polygon(points, color)


func draw_outline(unit, color):
	
	var offset = unit.position
	offset.y += 15
	draw_line(offset+Vector2(0,-p.y), offset+Vector2(-p.x,0), color, line)
	draw_line(offset+Vector2(0,-p.y), offset+Vector2(p.x,0), color, line)
	draw_line(offset+Vector2(0,p.y), offset+Vector2(-p.x,0), color, line)
	draw_line(offset+Vector2(0,p.y), offset+Vector2(p.x,0), color, line)