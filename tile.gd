extends Node2D
var random = RandomNumberGenerator.new()
var hue = randf_range(0.1,5)
var isoX
var isoY
var highlight
var altitude
var cartX
var cartY
var biomeValue
var water = load("res://sprites/waterTile.png")
var land = load("res://sprites/grassTile.png")
var select
var biomeDebug = true
var units = []
func start(inputX,inputY,altitude,biome) -> float:
	cartX = inputX
	cartY = inputY
	altitude = altitude * 100
	biomeValue = biome

	if altitude < 75:
		$Sprite2D.texture=water
		altitude = 74
	
	elif altitude >=75:
		$Sprite2D.texture = land
		if biomeDebug == true:
			
			$Sprite2D.modulate = Color(clamp(1 - biomeValue/70,0,1)*0.75,clamp(biomeValue/50,0,1), clamp(1-biomeValue/70,0,1))
	
	isoX = ((inputX*160) * 0.5) + ((inputY*160) * -0.5) +800
	isoY = ((inputX*160) *0.25 )+ ((inputY*160) * 0.25) - 1.5 #-(altitude/2.5)
	position.x = isoX 
	position.y = isoY
	return (altitude)
	
func _on_area_2d_mouse_entered() -> void:
	highlight = true
	
func _on_area_2d_mouse_exited() -> void:
	highlight = false

func _input(event: InputEvent) -> void: 
	if event.is_action_released("click"):
		if highlight == true:
			LastSelectedTile.lastSelectedTile = self
		if highlight == true and select != true:
			select = true
		else:
			select = false	
	
func addUnit(unit):
	units.append(unit)
	var player = unit.player
	if len(units) == 1:
		unit.location = "center"
		unit.level = 1
	
	var contestants = []
	for item in units:
		if item.player not in contestants:
			contestants.append(unit.player)
	

	if len(contestants) == 1:
		unit.location = "center"
		unit.level = len(units)
	elif len(contestants) == 2:
		for item in units:
			if item.player == contestants[1]:
				item.location = "left"
				item.level = len(units)
			elif item.player == contestants[2]:
				item.location = "right"
				item.location == len(units)
	elif len(contestants) == 3:
		for item in units:
			if item.player == contestants[1]:
				item.location = "topLeft"
				item.level = len(units)
			elif item.player == contestants[2]:
				item.location = "topRight"
				item.location == len(units)	
		#	elif item.player == contestants
		
