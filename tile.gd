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
var colour
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
			
			$Sprite2D.modulate = Color(clamp(1 - biomeValue/70,0,1),clamp(biomeValue/40,0,1), clamp(1-biomeValue/70,0,1))
	
	isoX = ((inputX*160) * 0.5) + ((inputY*160) * -0.5) +800
	isoY = ((inputX*160) *0.25 )+ ((inputY*160) * 0.25) - 1.5 #-(altitude/2.5)
	position.x = isoX 
	position.y = isoY
	
	for x in range(0,PlayerCount.playerCount):
		units.append([])
	print(units)
	
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
	units[Turn.turn-1].append(unit)
	print(units)
	var contestants =[]
	var j = 0
	for row in units:
		for item in row:
			if item.player not in contestants:
				contestants.append(item.player)
	print("contestants: ", contestants, "length: ", len(contestants))
	for row in units:
		var i = 0
		j+=1
		for item in row:
			i+=1
			if len(contestants)==1:
				item.location = "center"
				item.level = i
			
			if len(contestants)==2:
				if j == 1:
					item.location = "centerTop"
					item.level = i
				if j == 2:
					item.location = "centerBottom"
					item.level = i
			if len(contestants)==3:
				if j == 1:
					item.location = "topLeft"
					item.level = i
				if j == 2:
					item.location = "topRight"
					item.level = i
				if j == 3:
					item.location = "centerBottom"
					item.level = i
			if len(contestants)==4:
				if j == 1:
					item.location = "topLeft"
					item.level = i
				if j == 2:
					item.location = "topRight"
					item.level = i
				if j == 3:
					item.location = "bottomLeft"
					item.level = i
				if j == 4:
					item.location ="bottomRight"
					item.level = i
	unit.tile=self
			
