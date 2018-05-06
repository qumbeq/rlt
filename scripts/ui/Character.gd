extends Control


func update_character_panel(unit):
	
	$Portrait.texture = unit.portrait
	set_hp(unit)
	set_st(unit)
	
	
func set_hp(unit):
	
	$HP.text = 'HP: ' + str(unit.health) + '/' + str(unit.max_health)
	
func set_st(unit):
	
	$ST.text = 'ST: ' + str(unit.stamina) + '/' + str(unit.max_stamina)