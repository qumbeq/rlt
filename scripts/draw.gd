extends Node2D
onready var BattleField = get_node("../BattleField")

func _ready():
	pass

func _process(delta):
	
	update()
	
func _draw():
	
	var color = Color(.2,.5,.2)
	var line = 3
	var p = Vector2(30,15)
	
	if BattleField.sel_char != null:
		var offset = BattleField.sel_char.position
		offset.y += 15
		draw_line(offset+Vector2(0,-p.y), offset+Vector2(-p.x,0), color, line)
		draw_line(offset+Vector2(0,-p.y), offset+Vector2(p.x,0), color, line)
		draw_line(offset+Vector2(0,p.y), offset+Vector2(-p.x,0), color, line)
		draw_line(offset+Vector2(0,p.y), offset+Vector2(p.x,0), color, line)
		
	if BattleField.path.size() > 0:
		for wp in BattleField.path:
			var offset  = BattleField.map_to_world(wp)
			offset.y += 15
			draw_circle(offset, 5, color)