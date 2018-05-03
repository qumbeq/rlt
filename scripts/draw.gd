extends Node2D
onready var BattleField = get_node("../BattleField")

var shared = {}

func _ready():
	pass

func _process(delta):
	
	update()
	
func _draw():
	
	var color = Color(.2,.5,.2)
	var line = 3
	var p = Vector2(30,15)
	
	if shared.sel_char != null:
		var offset = shared.sel_char.position
		offset.y += 15
		draw_line(offset+Vector2(0,-p.y), offset+Vector2(-p.x,0), color, line)
		draw_line(offset+Vector2(0,-p.y), offset+Vector2(p.x,0), color, line)
		draw_line(offset+Vector2(0,p.y), offset+Vector2(-p.x,0), color, line)
		draw_line(offset+Vector2(0,p.y), offset+Vector2(p.x,0), color, line)
		
	if shared.path.size() > 0:
		for wp in shared.path:
			var offset  = BattleField.map_to_world(wp)
			offset.y += 15
			draw_circle(offset, 5, color)