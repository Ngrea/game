extends Node2D

##Vars
var noiseValue
var random=RandomNumberGenerator.new()
var noise=FastNoiseLite.new()
var biomeNoise = FastNoiseLite.new()            
var tileMap = []
var seed = random.randi_range(1,1000000)
var debugString = "Seed: %s \nPos: %s , %s \nAltitude: %s \nBiome: %s "
var size = 10
var regionMap = []
var tileScene = load("res://tile.tscn")
var testUnit
var unitScene = load("res://unit.tscn")
var lastClickedTile

var generated = false
var animate = true
var units=[]
var waiting = false
var turnHandler
var border = true
func getBiome(i,j,save) -> float:
	biomeNoise.seed = seed
	biomeNoise.frequency=0.007
	biomeNoise.noise_type=FastNoiseLite.TYPE_CELLULAR
	biomeNoise.cellular_distance_function=FastNoiseLite.DISTANCE_EUCLIDEAN
	biomeNoise.cellular_return_type=FastNoiseLite.RETURN_CELL_VALUE
	biomeNoise.cellular_jitter=1
	biomeNoise.fractal_octaves=1
	
	if save == true:
		var img = Image.new()
		img = biomeNoise.get_image(340,340)
		img.save_png("noise.png")
		print("saved")
	return abs(biomeNoise.get_noise_2d(i*20,j*20) *100)



func _ready() -> void:
	$label.add_theme_font_size_override("normal_font_size",100)
	
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = seed
	noise.frequency = 0.0005
	noise.fractal_octaves = 7
	noise.fractal_lacunarity = 2
	noise.fractal_gain = 0.3
	
	#initialise tilemap

	for j in range(size):
		var row = []
		for i in range(size):
			row.append(0)
		tileMap.append(row)
		
	for i in range(size):
		for j in range(size):
			noiseValue = abs(noise.get_noise_2d(i*100,j*100) * 2 - 1)
			
			var tile = tileScene.instantiate()
			var biomeValue = getBiome(i,j,false)
			add_child(tile)
			if animate:
				await get_tree().process_frame
			tile.altitude=tile.start(i,j,noiseValue,biomeValue)
			tileMap[i][j] = tile
	
	#find regions
	var values = []
	var count = 0
	var solvedTiles = []
	for row in tileMap:
		for tile in row:
			if tile.biomeValue not in values:
				var region = tile.biomeValue
				values.append(region)
				regionMap.append([region])
				#print(region)
				var colour = Color(random.randf_range(0,1)/1.5,random.randf_range(0,1),random.randf_range(0,1)/3)
				for checkRow in tileMap:
					for checkTile in checkRow:
						if checkTile.biomeValue == region and checkTile not in solvedTiles:
							if checkTile.altitude > 74:
								checkTile.get_node("Sprite2D").modulate = colour
							solvedTiles.append(checkTile)
							regionMap[count].append(checkTile)
							checkTile.region = count
				count+=1
 			#print(regionMap)
	##Asign capture values
	for region in regionMap:
		region.append(floor(len(region)/2))
	
	if border:
		for row in tileMap:
			for tile in row:
				if tile.altitude >= 75:
					var biome = tile.biomeValue
					var adjacent = findAdjacent(tile)
	
					
					#full border
					if isBorder(([adjacent[0],adjacent[2],adjacent[4],adjacent[6]]),biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/grassTileAllBorder.png")
					#threes
					elif isBorder(([adjacent[0],adjacent[2],adjacent[4]]),biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/grassTileNotLeftBorder.png")
					elif isBorder(([adjacent[2],adjacent[4],adjacent[6]]),biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/grassTileNotDownBorder.png")
					elif isBorder(([adjacent[4],adjacent[6],adjacent[0]]),biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/grassTileNotRightBorder.png")
					elif isBorder(([adjacent[6],adjacent[0],adjacent[2]]),biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/grassTileNotUpBorder.png")
					#twos
					elif isBorder(([adjacent[0],adjacent[2]]),biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/grassTileDownRightBorder.png")
					elif isBorder(([adjacent[2],adjacent[4]]),biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/grassTileUpLeftBorder.png")
					elif isBorder(([adjacent[4],adjacent[6]]),biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/grassTileUpRightBorder.png")
					elif isBorder(([adjacent[6],adjacent[0]]),biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/grassTileDownLeftBorder.png")
					elif isBorder(([adjacent[0],adjacent[4]]),biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/grassTileUpDownBorder.png")
					elif isBorder(([adjacent[2],adjacent[6]]),biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/grassTileLeftRightBorder.png")
		
					#ones
					elif isBorder([adjacent[4]],biome):
							tile.get_node("Sprite2D").texture = load("res://sprites/grassTileUpBorder.png")
	
					elif isBorder([adjacent[2]],biome):
							tile.get_node("Sprite2D").texture = load("res://sprites/grassTileRightBorder.png")
	
	
					elif isBorder([adjacent[0]],biome):
							tile.get_node("Sprite2D").texture = load("res://sprites/grassTileDownBorder.png")
	
					elif isBorder([adjacent[6]],biome):
							tile.get_node("Sprite2D").texture = load("res://sprites/grassTileLeftBorder.png")
					#if animate:
						#await get_tree().process_frame
					
	######Init starting units
	var tile = tileMap[random.randf_range(0,size-1)][random.randi_range(0,size-1)]
	var unit = unitScene.instantiate()
	unit.tile=tile
	add_child(unit)
	units.append(unit)
	
	
	####UI ELEMENTS
	turnHandler = (load("res://turn_handler.tscn")).instantiate()
	add_child(turnHandler)
	turnHandler.get_node("Button").pressed.connect(endTurn)
	print(regionMap)
	generated = true

func endTurn():
	print("pressed")
	print(Turn.turn)
	print(PlayerCount.playerCount)
	if Turn.turn == PlayerCount.playerCount:
		for row in tileMap:
			for tile in row:
				tile.battle()
	####Capturing
	###sum units
	for region in regionMap:
		var p1sum = 0
		var p2sum = 0
		var p3sum = 0
		var p4sum = 0
		for tile in region:
			if tile is Node:
				p1sum+=tile.p1UnitTotal
				p2sum+=tile.p2UnitTotal
				p3sum+=tile.p3UnitTotal
				p4sum+=tile.p4UnitTotal
			###Captured?
			#player 1 capture:
			if p1sum+p2sum+p3sum+p4sum<=1:
				if p1sum >= region[-1]:
					capture(1,region)
				if p2sum >= region[-1]:
					capture(2,region)
				if p3sum >= region[-1]:
					capture(3,region)
				if p4sum >= region[-1]:
					capture(4,region)
			else:
				var values = [p1sum,p2sum,p3sum,p4sum]
				var largest = p1sum
				for value in values:
					if value > largest:
						largest = value	
				capture(largest,region)
	if Turn.turn < PlayerCount.playerCount:
		Turn.turn += 1
	else:
		Turn.turn = 1

func capture(player,region):
	print("captured",player,region)
func findAdjacent(tile):
	#Finds tiles adjacent to the input tile
	var x = tile.cartX
	var y = tile.cartY
	var tiles = []
	#top [0]
	if y<size-1:
		tiles.append(tileMap[x][y+1])
	else:
		tiles.append(0)
	#top right [1]
	if y<size-1 and x<size-1:
		tiles.append(tileMap[x+1][y+1])
	else:
		tiles.append(0)
	#right[2]
	if x < size - 1:
		tiles.append(tileMap[x + 1][y])
	else:
		tiles.append(0)
	if x<size-1 and y >0:
		tiles.append(tileMap[x+1][y-1])
	else:
		tiles.append(0)
	if y>0:
		tiles.append(tileMap[x][y-1])
	else:
		tiles.append(0)
	if x >0 and y>0:
		tiles.append(tileMap[x-1][y-1])
	else:
		tiles.append(0)
	if x>0:
		tiles.append(tileMap[x-1][y])
	else:
		tiles.append(0)
	if x>0 and y<size-1:
		tiles.append(tileMap[x-1][y+1])
	else:
		tiles.append(0)
	
	return(tiles)

func isBorder(check,biome):

	if check is Array:
		for item in check:
			#print("list")
			if not(item is not int and item.altitude >= 75 and item.biomeValue!=biome):
				return false
		return true
	#if check is not int:
		#print("single")
	#if check is not int and check.altitude >= 75 and check.biomeValue != biome:
	#	return true
	#else:
	#	return false

	#return true
#Camera zoom func
func _input(event: InputEvent) -> void:
	if event.is_action_released("scrollUp"):
		$Camera2D.zoom.x += 0.01
		$Camera2D.zoom.y += 0.01
	if event.is_action_released("scrollDown") and $Camera2D.zoom.x >0.1:
		$Camera2D.zoom.x -= 0.01
		$Camera2D.zoom.y -= 0.01
		
	if event.is_action_released("J"):
		get_tree().quit() 

#Camera move func
func _physics_process(delta):
	if Input.is_action_pressed("W"):
		$Camera2D.position.y -= 500 * delta
	if Input.is_action_pressed("A"):
		$Camera2D.position.x -= 500 * delta
	if Input.is_action_pressed("S"):
		$Camera2D.position.y += 500 * delta
	if Input.is_action_pressed("D"):
		$Camera2D.position.x += 500 * delta

#Gets the identifier for the next tile clicked on
func selectTile():
	print("waiting for input")
	var lastTile = LastSelectedTile.lastSelectedTile #Global. Whenever a tile is clicked it updates
	waiting = true
	while true:
		if LastSelectedTile.lastSelectedTile != lastTile:
			waiting = false
			return(LastSelectedTile.lastSelectedTile)
		await get_tree().process_frame

func updateInfo(tile):
	print(tile)
	$label.text = str(regionMap[tile.region][-1])

func _on_test_pressed() -> void:
	var tile = await selectTile()

	var unit = unitScene.instantiate()
	unit.tile=tile
	unit.player = Turn.turn
	add_child(unit)
	units.append(unit)
	



#func _process(delta: float) -> void:
#	if false:
#	#print(waiting)
#		for unit in units:
##			if not unit.select:
#				#print(waiting)
#				for row in tileMap:
#					for tile in row:
#						tile.position.y = tile.isoY
##						if tile.highlight == true:
#							$label.text = debugString % [seed,tile.cartX,tile.cartY,tile.altitude,tile.biomeValue]
#						if tile.select == true and not(waiting):
#							for biomeGroup in regionMap:
#								if biomeGroup[0] == tile.biomeValue:
#									for target in biomeGroup:
#										if target is not float:
#											if target.altitude >75:
#												target.position.y = target.isoY - 20
#									return
#			
#						else:
#							tile.position.y = tile.isoY
##OLD^#^^^
#

# Called every frame. 'delta' is the elapsed time since the previous frame.
