extends Node2D
var random = RandomNumberGenerator.new()
var hue = randf_range(0.1,5)
var isoX
var isoY
var highlight
var altitude
var cartX
var cartY
var regionValue
var water = load("res://sprites/waterTile.png")
var land = load("res://sprites/grassTile.png")
var select
var regionDebug = true
var units = []
var colour
var contestants
var region
var p1UnitTotal =0
var p2UnitTotal = 0
var p3UnitTotal = 0
var p4UnitTotal = 0
func start(inputX,inputY,altitude,region) -> float:
	cartX = inputX
	cartY = inputY
	altitude = altitude * 100
	isoX = ((inputX*160) * 0.5) + ((inputY*160) * -0.5) +800
	isoY = ((inputX*160) *0.25 )+ ((inputY*160) * 0.25) - 1.5 #-(altitude/2.5)
	position.x = isoX 
	position.y = isoY
	regionValue = region
	
	#if altitude < 75:
	#	$Sprite2D.texture=water
	#	altitude = 74
	#
	#elif altitude >=75:
	#	$Sprite2D.texture = land
	#	#if regionDebug == true:	
	#	$Sprite2D.modulate = Color(clamp(1 - regionValue/70,0,1),clamp(regionValue/40,0,1), clamp(1-regionValue/70,0,1))	
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
			get_parent().updateInfo(self)
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
	distribute(contestants)
			
	unit.tile=self
	p1UnitTotal = 0
	p2UnitTotal = 0
	p3UnitTotal = 0
	p4UnitTotal = 0
	for group in units:
		for item in group:
			if item.player == 1:
				p1UnitTotal+=1
			if item.player == 2:
				p2UnitTotal+=1
			if item.player == 3:
				p3UnitTotal+=1
			if item.player == 4:
				p4UnitTotal+=1
		
func removeUnit(unit):
	for i in range(PlayerCount.playerCount):
		if unit in units[i]:
			units[i].erase(unit)  # Remove unit from the correct player's array
			break
	unit.queue_free()
	await get_tree().process_frame
	contestants = []
	var j = 0
	for row in units:
		for item in row:
			if item.player not in contestants:
				contestants.append(item.player)
	distribute(contestants)
	p1UnitTotal = 0
	p2UnitTotal = 0
	p3UnitTotal = 0
	p4UnitTotal = 0
	for group in units:
		for item in group:
			if item.player == 1:
				p1UnitTotal+=1
			if item.player == 2:
				p2UnitTotal+=1
			if item.player == 3:
				p3UnitTotal+=1
			if item.player == 4:
				p4UnitTotal+=1
				
func distribute(contestants):
	var j=1
	for row in units:
		var i = 1
		
		for item in row:
			
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
			i+=1
		j+=1
func battle():
	var combatantPlayers = []
	var combatantUnits = []
	if contestants and len(contestants) == 2:
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
		elif outcome < 6:
			await removeUnit(combatantUnits[0])
			return
		elif outcome < 9:
			await removeUnit(combatantUnits[1])
			return
		else:
			await removeUnit(combatantUnits[0])
			await removeUnit(combatantUnits[1])
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
			await removeUnit(combatantUnits[0])
			return
		if outcome < 6:
			await removeUnit(combatantUnits[1])
			return
		if outcome < 8:
			await removeUnit(combatantUnits[2])
			return
		if outcome <=10:
			await removeUnit(combatantUnits[0])
			await removeUnit(combatantUnits[1])
			await removeUnit(combatantUnits[2])
		
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
			await removeUnit(combatantUnits[0])
		if outcome < 5:
			await removeUnit(combatantUnits[1])
		if outcome < 7:
			await removeUnit(combatantUnits[2])
		if outcome < 9:
			await removeUnit(combatantUnits[3])
		else:
			await removeUnit(combatantUnits[0])
			await removeUnit(combatantUnits[1])
			await removeUnit(combatantUnits[2])
			await removeUnit(combatantUnits[3])
		
				
	#if len(contestants) == 2:
	#	for unit in 
