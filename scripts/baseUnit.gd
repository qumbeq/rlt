extends Node2D

var pos = Vector2()
var groupname
var max_health = 100
var health = 100
var max_stamina = 100
var stamina = 100
var speed = 10
var ally
var move_cost
var portrait = preload("res://sprites/portrait.png")


var actual_image = [] # array of pixels with alpha > 0
var source_image 
var hit = {
	'on' : false,
	'back' : false
	}
var vol

func _ready():
	pass
	
func init():
	
	add_to_group(groupname)
	move_cost = 100 / speed
	z_index = 1
	get_image_source()

func _physics_process(delta):

	if hit.on:
		animate_process(delta)
	

func get_image_source():
	
	source_image = $Sprite.texture.get_data()
	source_image.lock()
	
	var size = source_image.get_size()
	for x in size.x:
		for y in size.y:
			if source_image.get_pixel(x, y).a > 0:
				actual_image.append(Vector2(x,y))
	
func animate_process(delta):
	
	var result = source_image.duplicate()
	result.lock()
	var source_color
	
	if hit.back:
		vol = clamp(vol - delta*2, 0, 1)
	else:
		vol = clamp(vol + delta*2, 0, 1)
	for pixel in actual_image:
		source_color = source_image.get_pixel(pixel.x, pixel.y)
		var color_red = lerp(source_color.r, 1, vol)
		source_color.r = color_red
		result.set_pixel(pixel.x, pixel.y, source_color)
	var imgt = ImageTexture.new()
	imgt.create_from_image(result, 1)
	$Sprite.texture = imgt
	
	if vol == 1:
		hit.back = true
	if vol == 0:
		hit.on = false

func animate_hit_start():
	
	hit.on = true
	hit.back = false
	vol = 0

func get_unit_childrens():
	
	var childrens = get_tree().get_nodes_in_group(groupname)
	return childrens
	
func spawn(pos, node):
	
	node.add_child(self, true)
	self.pos = pos
	return self

func take_damage(dmg):
	
	health -= dmg
	animate_hit_start()

func use_stamina(stam):
	
	stamina -= stam
	
func start_turn():
	
	stamina = clamp(stamina + 35, 0, max_stamina) 
	 
func end_turn():
	pass
	
func _input(event):
	
	if event.is_action_pressed("ui_up"):
		pass