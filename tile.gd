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
var water = load("res://sprites/water.png")
var land = load("res://sprites/unitTileGREEN.png")
var select
var biomeDebug = true
var unit
func init(inputX,inputY,altitude,biome) -> float:
	cartX = inputX
	cartY = inputY
	altitude = altitude * 100
	biomeValue = biome

	if altitude < 75:
		$Sprite2D.texture=water
		altitude = 75
	
	elif altitude >=75:
		$Sprite2D.texture = land
		if biomeDebug == true:
			
			$Sprite2D.modulate = Color(clamp(1 - biomeValue/70,0,1),clamp(biomeValue/50,0,1), clamp(biomeValue/70,0,1))
	
	isoX = (inputX * 0.5) + (inputY * -0.5) +800
	isoY = (inputX *0.25 )+ (inputY * 0.25) - 1.5# - (altitude)
	position.x = isoX 
	position.y = isoY
	return (altitude)
	
func _on_area_2d_mouse_entered() -> void:
	highlight = true
	
func _on_area_2d_mouse_exited() -> void:
	highlight = false

func _input(event: InputEvent) -> void: 
	if event.is_action_released("click"):
		onClick()
	

func onClick():
	if highlight == true and select != true:
		select = true
	else:
		select = false	
