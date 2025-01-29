extends Node2D
var tile
var highlight
var select
var X
var Y
var player
var location
var level
func _ready() -> void:
	position.x = tile.position.x
	position.y = tile.position.y - 48


func _on_area_2d_mouse_entered() -> void:
	highlight = true

func _on_area_2d_mouse_exited() -> void:
	highlight = false

func _input(event: InputEvent) -> void: 
	if event.is_action_released("click") and highlight == true and Turn.turn == player:
		select = true
		$Sprite2D.modulate=Color(0,255,0)
		LastSelectedUnit.lastSelectedUnit = self
		print(tile)
	elif select == true and event.is_action_released("click"):
		select = false
		$Sprite2D.modulate=Color(0,0,0)
		
func _process(delta: float) -> void:
	#if select == true:
	#	$Sprite2D.modulate=Color(255,0,0)
	#else:
	#	$Sprite2D.modulate=Color(0,0,0)
	#position.y = tile.position.y -50
	position.x = tile.position.x
	position.y = tile.position.y -48
