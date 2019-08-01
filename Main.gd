extends Node

export (PackedScene) var CoinScene
export (PackedScene) var PowerupScene
export (int) var playtime = 30

var level
var screensize
var time_left
var score
var playing
var isCheckNextLevel = false


func _ready():
	setup_game()


func _process(delta):
	check_next_level()


func _on_Player_pickup(type):
	$CoinSound.play()
	match type:
		'coins':
			score += 1
			$HUD.update_score(score)
			isCheckNextLevel = true
		'powerups':
			time_left += 5
			$HUD.update_time(time_left)


func _on_HUD_start_game():
	new_game()


func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_time(time_left)
	if time_left <= 0:
		gameover()


func _on_PowerupTimer_timeout():
	if not playing:
		return
	
	var powerup = PowerupScene.instance()
	powerup.screensize = screensize
	powerup.position = Vector2(rand_range(10, screensize.x - 10), rand_range(10, screensize.y - 10))
	
	$PowerupContainer.add_child(powerup)
	$PowerupTimer.wait_time = rand_range(5, 10)
	$PowerupTimer.start()


func _on_Player_hurt():
	gameover()


func setup_game():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.hide()
	$Player.screensize = screensize
	
	for obstacle in $ObstacleContainer.get_children():
		obstacle.show()


func new_game():
	print("Main::New game")
	level = 1
	score = 0
	time_left = playtime
	playing = true
	isCheckNextLevel = false
	
	spawn_coins()
	
	$HUD.update_score(score)
	$HUD.update_time(time_left)
	$HUD.show_level(level)
	yield($HUD/MessageLabel/MessageTimer, "timeout")

	$GameTimer.start()
	$Player.start($PlayerStart.position)
	$PowerupTimer.start()


func gameover():
	print("Main::Gameover")
	playing = false
	
	if $Player.isLive:
		$Player.die()
		
	$GameTimer.stop()
	$HUD.show_gameover()
	$EndSound.play()
	
	for coin in $CoinContainer.get_children():
		coin.queue_free()
		
	for powerup in $PowerupContainer.get_children():
		powerup.queue_free()


func spawn_coins():
	print("Main::Spawn coins")
	for i in range(4 + level):
		var coin = CoinScene.instance()
		coin.screensize = screensize
		coin.position = Vector2(rand_range(10, screensize.x - 10), rand_range(10, screensize.y - 10))
		$CoinContainer.add_child(coin)


func check_next_level():
	if isCheckNextLevel and $CoinContainer.get_child_count() <= 0:
		isCheckNextLevel = false
		next_level()
	isCheckNextLevel = false


func next_level():
	print("Next level")
	level += 1
	time_left += 5
	spawn_coins()
	$HUD.show_level(level)
	$LevelSound.play()
