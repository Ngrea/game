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
var contestants
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
		#if biomeDebug == true:
			
		$Sprite2D.modulate = Color(clamp(1 - biomeValue/70,0,1),clamp(biomeValue/40,0,1), clamp(1-biomeValue/70,0,1))
	
	isoX = ((inputX*160) * 0.5) + ((inputY*160) * -0.5) +800
	isoY = ((inputX*160) *0.25 )+ ((inputY*160) * 0.25) - 1.5 #-(altitude/2.5)
	position.x = isoX 
	position.y = isoY
	
	for x in range(0,PlayerCount.playerCount):
		units.append([])
	
	
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
	contestants = []
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
			if len(contestants) == 1:
				item.location = "center"
				
			
			if len(contestants)==2:
				if j == 1:
					item.location = "centerTop"
					
				if j == 2:
					item.location = "centerBottom"
					
			if len(contestants)==3:
				if j == 1:
					item.location = "topLeft"
					
				if j == 2:
					item.location = "topRight"
					
				if j == 3:
					item.location = "centerBottom"
					
			if len(contestants)==4:
				if j == 1:
					item.location = "topLeft"
					
				if j == 2:
					item.location = "topRight"
					
				if j == 3:
					item.location = "bottomLeft"
					
				if j == 4:
					item.location = "bottomRight"
			
			item.level = i	
			
	unit.tile=self

func removeUnit(unit):
	var i=-1
	var j=-1
	for group in units:
		i+=1
		for item in group:
			j +=1
			if item == unit:
				units[i].pop_at(j)
	unit.queue_free()
	
func battle():
	var combatantPlayers = []
	var combatantUnits = []
	if contestants and  len(contestants) == 2:
		var number = 2

		for group in units:
			for unit in group:
				if len(combatantPlayers) == 2:
					break
				if unit.player not in combatantPlayers:
					combatantPlayers.append(unit.player)
					combatantUnits.append(unit)
		var outcome = random.randi_range(1,10)
		if outcome < 3:
			return
		if outcome < 6:
			removeUnit(combatantUnits[0])
			return
		if outcome < 9:
			removeUnit(combatantUnits[1])
			return
		else:
			removeUnit(combatantUnits[0])
			removeUnit(combatantUnits[1])
			return
	if contestants and len(contestants) == 3:
		for group in units:
			for unit in group:
				if len(combatantPlayers) == 3:
					break
				if unit.player not in combatantPlayers:
					combatantPlayers.append(unit.player)
					combatantUnits.append(unit)
		var outcome = randi_range(1,10)
		if outcome <2:
			return
		if outcome < 4:
			removeUnit(combatantUnits[0])
			return
		if outcome < 6:
			removeUnit(combatantUnits[1])
			return
		if outcome < 8:
			removeUnit(combatantUnits[2])
			return
		if outcome <=10:
			removeUnit(combatantUnits[0])
			removeUnit(combatantUnits[1])
			removeUnit(combatantUnits[2])
		
	if contestants and len(contestants) == 4:
		for group in units:
			for unit in group:
				if len(combatantPlayers) == 4:
					break
				if unit.player not in combatantPlayers:
					combatantPlayers.append(unit.player)
					combatantUnits.append(unit)
		var outcome = randi_range(1,10)
		if outcome <1:
			return
		if outcome < 3:
			removeUnit(combatantUnits[0])
		if outcome < 5:
			removeUnit(combatantUnits[1])
		if outcome < 7:
			removeUnit(combatantUnits[2])
		if outcome < 9:
			removeUnit(combatantUnits[3])
		else:
			removeUnit(combatantUnits[0])
			removeUnit(combatantUnits[1])
			removeUnit(combatantUnits[2])
			removeUnit(combatantUnits[3])
		
				
	#if len(contestants) == 2:
	#	for unit in 
