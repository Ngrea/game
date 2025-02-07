extends Node2D
#This script determines who's turn it is.
#It will hook into a larger UI scene
var playerCount = PlayerCount.playerCount
var turn
func _ready() -> void:
	turn = 1
	$RichTextLabel.text = str(turn)
	

func _process(delta: float) -> void:
	turn = Turn.turn
