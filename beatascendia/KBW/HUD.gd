extends CanvasLayer

func update_health(hp):
	$HP.value = hp

func update_time(cool):
	$Time.value = cool

func game_over():
	$GameEnd.show()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_packed(preload("res://Main.tscn"))
