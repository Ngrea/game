extends Node2D
var noiseValue
var random=RandomNumberGenerator.new()
var noise=FastNoiseLite.new()
var biomeNoise = FastNoiseLite.new()            
var tileMap = []
var seed = random.randi_range(1,1000000)
var debugString = "Pos: %s , %s \nAltitude: %s \nBiome: %s "
var size = 30
var biomeMap = []
var tileScene = load("res://tile.tscn")
var testUnit
var unitScene = load("res://unit.tscn")
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
	return abs(biomeNoise.get_noise_2d(i*10,j*10) *100)



func _ready() -> void:
	$label.add_theme_font_size_override("normal_font_size",250)
	
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
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
			tile.altitude=tile.init(i*160,j*160,noiseValue,biomeValue)
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
func findAdjacent(tile):
	#Finds tiles adjacent to the input tile
	var x = tile.cartX
	var y = tile.cartY
	return(
		[
		Vector2(x,y-1),       #Top [0]
		Vector2(x+1,y+1),     #Top Right [1]
		Vector2(x+1,y),       #Right [2]
		Vector2(x+1,y-1),     #Bottom right [3]
		Vector2(x,y-1),       #Bottom  [4]
		Vector2(x-1,y-1),     #Bottom left [5]
		Vector2(x-1,y),       #Left [6]
		Vector2(x-1,y+1)      #Top left [7]
		]
	
	)

######TESTUNIT
func _on_make_unit_pressed() -> void:
	add_child(unitScene.instantiate())



func _process(delta: float) -> void:
	for row in tileMap:
		for tile in row:
			tile.position.y = tile.isoY
			if tile.select == true:
				for biomeGroup in biomeMap:
					if biomeGroup[0] == tile.biomeValue:
						for target in biomeGroup:
							if target is not float:
								if target.altitude >75:
									target.position.y = target.isoY - 20
						return
			
			else:
				tile.position.y = tile.isoY


	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
