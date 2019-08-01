extends Area2D

signal hurt
signal pickup

export (int) var speed = 200
var velocity = Vector2()
var screensize = Vector2(480, 360)
var isLive


func _process(delta):
	get_input()
	animate()
	update_position(delta)

func _on_Player_area_entered(area):
	if area.is_in_group("pickupable"):
		pickup(area)
		
	if area.is_in_group("obstacles"):
		die()


func start(pos):
	set_process(true)
	isLive = true
	position = pos
	show()
	$AnimatedSprite.play("idle")


func update_position(delta):
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)


func get_input():
	velocity.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	velocity.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed


func animate():
	if velocity.length() <= 0:
		$AnimatedSprite.play("idle")
		return
		
	$AnimatedSprite.play("run")
	$AnimatedSprite.flip_h = velocity.x < 0


func die():
	isLive = false
	$AnimatedSprite.stop()
	set_process(false)
	emit_signal("hurt")

func pickup(area):
	area.pickup()
	var type = "coins" if area.is_in_group("coins") else "powerups"
	
	emit_signal("pickup", type)


