extends Node2D
var tile
var highlight
var select
var player
var location
var level
func _ready() -> void:
	position.x = tile.position.x
	position.y = tile.position.y - 48
	if player == 1:
		$Sprite2D.texture = load("res://sprites/p1Unit.png")
	if player == 2:
		$Sprite2D.texture = load("res://sprites/p2Unit.png")
	if player == 3:
		$Sprite2D.texture = load("res://sprites/p3Unit.png")
	if player == 4:
		$Sprite2D.texture = load("res://sprites/p4Unit.png")
func _on_area_2d_mouse_entered() -> void:
	highlight = true

func _on_area_2d_mouse_exited() -> void:
	highlight = false

func _input(event: InputEvent) -> void: 
	if event.is_action_released("click") and highlight == true and Turn.turn == player:
		select = true
		#$Sprite2D.modulate=Color(0,255,0)
		LastSelectedUnit.lastSelectedUnit = self
		print(tile)
	elif select == true and event.is_action_released("click"):
		select = false
		#$Sprite2D.modulate=Color(0,0,0)
		
func _process(delta: float) -> void:
	#if select == true:
	#	$Sprite2D.modulate=Color(255,0,0)
	#else:
	#	$Sprite2D.modulate=Color(0,0,0)
	#position.y = tile.position.y -50
	#position.x = tile.position.x
	#position.y = tile.position.y -48
	if location == "center":
		position.y = tile.position.y - 48 - (level * 3 * 2.5)
		position.x = tile.position.x
	elif location == "centerTop":
		position.y = tile.position.y -48 - 12- (level * 3 * 2.5)
		position.x = tile.position.x + 20
	elif location == "centerBottom":
		position.y = tile.position.y - 48 + 12- (level * 3 * 2.5)
		position.x = tile.position.x -20
	elif location == "topLeft":
		position.y = tile.position.y -48-24- (level * 3 * 2.5)
		position.x = tile.position.x
	elif location == "topRight":
		position.y = tile.position.y -48- (level * 3 * 2.5)
		position.x = tile.position.x +36
	elif location == "bottomLeft":
		position.y = tile.position.y -48-(level * 3 * 2.5)
		position.x = tile.position.x -36
	elif location == "bottomRight":
		position.y = tile.position.y -48 +24- (level * 3 * 2.5)
		position.x = tile.position.x
	
