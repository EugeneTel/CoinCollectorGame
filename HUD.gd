extends CanvasLayer

signal start_game

func _ready():
	$MessageLabel.show()
	$MarginContainer.show()
	$StartButton.show()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _on_StartButton_pressed():
	$StartButton.hide()
	$MessageLabel.hide()
	emit_signal("start_game")

func update_score(value):
	$MarginContainer/ScoreLabel.text = str(value)
	
func update_time(value):
	$MarginContainer/TimeLabel.text = str(value)
	
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageLabel/MessageTimer.start()
	
func show_gameover():
	show_message("Game Over!")
	print("Yield started")
	yield($MessageLabel/MessageTimer, "timeout")
	print("Yield finished")
	$StartButton.show()
	$MessageLabel.text = "Coin Dash"
	$MessageLabel.show()
	
func show_level(level):
	show_message("Level " + str(level))
