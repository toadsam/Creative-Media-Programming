extends TileMapLayer


func _process(delta: float) -> void:
	$car1.play("movement1")
	$car2.play("movement2")
	$car3.play("movement3")
