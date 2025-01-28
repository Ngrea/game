extends Node2D
var lastUnit = LastSelectedUnit.lastSelectedUnit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if LastSelectedUnit.lastSelectedUnit != lastUnit:

		lastUnit = LastSelectedUnit.lastSelectedUnit
		if LastSelectedUnit.lastSelectedUnit and LastSelectedUnit.lastSelectedUnit.player == Turn.turn:
			#print(LastSelectedUnit.lastSelectedUnit)
			#print($map.findAdjacent(LastSelectedUnit.lastSelectedUnit.tile))
			var adjacent = $map.findAdjacent(LastSelectedUnit.lastSelectedUnit.tile)
			for tile in adjacent:
				if tile is not int:
					#tile.get_node("Sprite2D").modulate=Color(255,0,0)
					pass
			$map.waiting = true
			var newTile = await $map.selectTile()
			if newTile in adjacent:
				LastSelectedUnit.lastSelectedUnit.tile= newTile
			$map.waiting = false
			LastSelectedUnit.lastSelectedUnit = null
	
