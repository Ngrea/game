extends Node2D
#This script determines who's turn it is.
#It will hook into a larger UI scene
var playerCount = PlayerCount.playerCount
var turn
func _ready() -> void:
	turn = 1
	$RichTextLabel.text = str(turn)
	Turn.turn = 1

func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if turn < playerCount:
		turn += 1
	else:
		turn = 1
	Turn.turn = turn
	$RichTextLabel.text = str(turn)
