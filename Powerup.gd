extends Area2D

var screensize

func _on_AnimTimer_timeout():
	queue_free()

func pickup():
	queue_free()
	

func _on_Powerup_area_entered(area):
	if area.is_in_group("obstacles") or area.is_in_group("pickupable"):
		position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
