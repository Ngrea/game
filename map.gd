extends Node2D
var noiseValue
var random=RandomNumberGenerator.new()
var noise=FastNoiseLite.new()
var biomeNoise = FastNoiseLite.new()            
var tileMap = []
var seed = random.randi_range(1,1000000)
var debugString = "Seed: %s \nPos: %s , %s \nAltitude: %s \nBiome: %s "
var size = 30
var biomeMap = []
var tileScene = load("res://tile.tscn")
var testUnit
var unitScene = load("res://unit.tscn")
var lastClickedTile
var notLeft = load("res://sprites/greentileNotLeft.png")
var notRight = load("res://sprites/greentileNotRight.png")
var notUp = load("res://sprites/greentileNotUp.png")
var notDown = load("res://sprites/greentileNotDown.png")
var upDown = load("res://sprites/greentileUpDownBorder.png")
var upRight = load("res://sprites/greentileUpRightBorder.png")
var upLeft = load("res://sprites/greentileUpLeftBorder.png")
var downLeft = load("res://sprites/greentileDownLeftBorder.png")
var downRight = load("res://sprites/greentileDownRightBorder.png")
var leftRight = load("res://sprites/greentileRightLeftBorder.png")
var up = load("res://sprites/greenTileUpBorder.png")
var down = load("res://sprites/greentileDownBorder.png")
var left = load("res://sprites/greenTileLeftBorder.png")
var right= load("res://sprites/greenTileRightBorder.png")
var generated = false
var animate = false
var units=[]
var waiting = false
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
	return abs(biomeNoise.get_noise_2d(i*7,j*7) *100)



func _ready() -> void:
	$label.add_theme_font_size_override("normal_font_size",100)
	
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = seed
	noise.frequency = 0.001
	noise.fractal_octaves = 5
	noise.fractal_lacunarity = 3
	noise.fractal_gain = 0.3
	
	#initialise tilemap

	for j in range(size):
		var row = []
		for i in range(size):
			row.append(0)
		tileMap.append(row)
		
	for i in range(size):
		for j in range(size):
			noiseValue = abs(noise.get_noise_2d(i*40,j*40) * 2 - 1)
			
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
				biomeMap.append([region])
				#print(region)
				for checkRow in tileMap:
					for checkTile in checkRow:
						if checkTile.biomeValue == region and checkTile not in solvedTiles:
							solvedTiles.append(checkTile)
							biomeMap[count].append(checkTile)
				count+=1
 			#print(biomeMap)
	for row in tileMap:
		for tile in row:
			if tile.altitude >= 75:
				var biome = tile.biomeValue
				var adjacent = findAdjacent(tile)

				
				#full border (just in case)
				if isBorder(([adjacent[0],adjacent[2],adjacent[4],adjacent[6]]),biome):
					tile.get_node("Sprite2D").texture = load("res://sprites/greentileAllBordert.png")
				#threes
				elif isBorder(([adjacent[0],adjacent[2],adjacent[4]]),biome):
					tile.get_node("Sprite2D").texture = load("res://sprites/greentileNotLeft.png")
				elif isBorder(([adjacent[2],adjacent[4],adjacent[6]]),biome):
					tile.get_node("Sprite2D").texture = load("res://sprites/greentileNotDown.png")
				elif isBorder(([adjacent[4],adjacent[6],adjacent[0]]),biome):
					tile.get_node("Sprite2D").texture = load("res://sprites/greentileNotRight.png")
				elif isBorder(([adjacent[6],adjacent[0],adjacent[2]]),biome):
					tile.get_node("Sprite2D").texture = load("res://sprites/greentileNotUp.png")
				#twos
				elif isBorder(([adjacent[0],adjacent[2]]),biome):
					tile.get_node("Sprite2D").texture = load("res://sprites/greentileDownRightBorder.png")
				elif isBorder(([adjacent[2],adjacent[4]]),biome):
					tile.get_node("Sprite2D").texture = load("res://sprites/greentileUpLeftBorder.png")
				elif isBorder(([adjacent[4],adjacent[6]]),biome):
					tile.get_node("Sprite2D").texture = load("res://sprites/greentileUpRightBorder.png")
				elif isBorder(([adjacent[6],adjacent[0]]),biome):
					tile.get_node("Sprite2D").texture = load("res://sprites/greentileDownLeftBorder.png")
				elif isBorder(([adjacent[0],adjacent[4]]),biome):
					tile.get_node("Sprite2D").texture = load("res://sprites/greentileUpDownBorder.png")
				elif isBorder(([adjacent[2],adjacent[6]]),biome):
					tile.get_node("Sprite2D").texture = load("res://sprites/greentileRightLeftBorder.png")
	
				#ones
				elif isBorder(adjacent[4],biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/greenTileUpBorder.png")

				elif isBorder(adjacent[2],biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/greenTileRightBorder.png")


				elif isBorder(adjacent[0],biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/greentileDownBorder.png")

				elif isBorder(adjacent[6],biome):
						tile.get_node("Sprite2D").texture = load("res://sprites/greenTileLeftBorder.png")
				if animate:
					await get_tree().process_frame

	generated = true		
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
			if not(item is not int and item.altitude >=75 and item.biomeValue!=biome):
				return false
		return true
	#if check is not int:
		#print("single")
	if check is not int and check.altitude >= 75 and check.biomeValue != biome:
		return true
	else:
		return false

	return true
#Camera zoom func
func _input(event: InputEvent) -> void:
	if event.is_action_released("scrollUp"):
		$Camera2D.zoom.x += 0.01
		$Camera2D.zoom.y += 0.01
	if event.is_action_released("scrollDown"):
		$Camera2D.zoom.x -= 0.01
		$Camera2D.zoom.y -= 0.01
		
	if event.is_action_released("J"):
		get_tree().quit() 

#Camera move func
func _physics_process(delta):
	if Input.is_action_pressed("W"):
		$Camera2D.position.y -= 300 * delta
	if Input.is_action_pressed("A"):
		$Camera2D.position.x -= 300 * delta
	if Input.is_action_pressed("S"):
		$Camera2D.position.y += 300 * delta
	if Input.is_action_pressed("D"):
		$Camera2D.position.x += 300 * delta

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

  


func _on_test_pressed() -> void:
	var tile = await selectTile()
	#for x in findAdjacent(tile):
	#	x.position.y += 20
	#	await get_tree().create_timer(1.0).timeout
	waiting = false
	var unit = unitScene.instantiate()
	unit.tile=tile
	add_child(unit)
	units.append(unit)
	

func _process(delta: float) -> void:
	if generated:
		for unit in units:
			if not unit.select:
				#print(waiting)
				for row in tileMap:
					for tile in row:
						tile.position.y = tile.isoY
						if tile.highlight == true:
							$label.text = debugString % [seed,tile.cartX,tile.cartY,tile.altitude,tile.biomeValue]
						if tile.select == true and not(waiting):
							for biomeGroup in biomeMap:
								if biomeGroup[0] == tile.biomeValue:
									for target in biomeGroup:
										if target is not float:
											if target.altitude >75:
												target.position.y = target.isoY - 20
									return
			
						else:
							tile.position.y = tile.isoY
#OLD^#^^^
	
	
	

	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
