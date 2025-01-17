extends Node2D
var game = load("res://map.tscn")
var newGame = game.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	newGame.queue_free()
	game = load("res://map.tscn")
	newGame = game.instantiate()
	add_child(newGame)
	
	
