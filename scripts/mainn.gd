extends Node2D
var score: int = 0
var level: int = 1
@onready var score_label: Label = $display/scorePanel/score_Label
@onready var winning_sound: AudioStreamPlayer2D = $LevelRoot/player/winningSound
signal win

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _setup_level() -> void:
	#exit
	var exit = $LevelRoot.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
	
	#bananas
	var bananas = $LevelRoot.get_node_or_null("bananas")
	if bananas:
		for banana in bananas.get_children():
			banana.collected.connect(_increase_score)
	
	#snail enemies
	var enemies = $LevelRoot.get_node_or_null("enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_failed.connect(_on_player_failed)


#signals

func _on_exit_body_entered(body: Node2D)-> void:
	if body.name == "player":
		level+=1
		print(level)
		body.can_move = false

func _on_player_failed(body):
	body.fail()
	print("Player failed")

func _winner() -> void:
	emit_signal("win")
	winning_sound.play()

func _increase_score() -> void:
	score += 5
	score_label.text = "SCORE: %s" % score
	if score == 20:
		_winner()
	
