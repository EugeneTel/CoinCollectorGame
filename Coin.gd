extends Area2D

var screensize

func _ready():
	animate()

func _on_AnimTimer_timeout():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()

func animate():
	$AnimTimer.wait_time = rand_range(3, 8)
	$AnimTimer.start()

func pickup():
	queue_free()
	

func _on_Coin_area_entered(area):
	if area.is_in_group("obstacles") or area.is_in_group("pickupable"):
		position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
