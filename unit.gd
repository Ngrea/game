extends Node2D
var tile
var highlight
var select
var X
var Y

func _ready() -> void:
	position.x = tile.position.x - 80
	position.y = tile.position - 80


func _on_area_2d_mouse_entered() -> void:
	highlight = true

func _on_area_2d_mouse_exited() -> void:
	highlight = false

func _input(event: InputEvent) -> void: 
	if event.is_action_released("click") and highlight == true:
		select = true
	elif select == true and event.is_action_released("click"):
		select = false
		
func _process(delta: float) -> void:
	if select == true:
		$Sprite2D.modulate=Color(255,0,0)
	else:
		$Sprite2D.modulate=Color(255,255,255)
