extends Node2D
var LASTLEVEL = 4
var score: int = 0
var level: int = 4
var current_level_root:Node = null
@onready var message: RichTextLabel = $levelMessage

@onready var fade: ColorRect = $display/Fade
@onready var score_label: Label = $display/scorePanel/score_Label
signal win

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#setup level
	fade.modulate.a = 1.0
	current_level_root = get_node("LevelRoot")
	await _load_level(level, true, false)

#LEVEL MANAGEMENTTT!

func _load_level(level_number: int, first_load: bool, reset_score: bool) -> void:
	
	if not first_load:
		await _fade(1.0) #fading out
		
	if reset_score:
		score = 0
		score_label.text = "SCORE: 0"
	if current_level_root:
		current_level_root.queue_free()
		
	var level_path = "res://scenes/levels/level%s.tscn" %level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)
	
	await _fade(0) #fade-in
	

func _setup_level(level_root: Node) -> void:
	#exit
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)

	
	#bananas
	var bananas = level_root.get_node_or_null("bananas")
	if bananas:
		for banana in bananas.get_children():
			banana.collected.connect(_increase_score)
	
	#snail enemies
	var enemies = level_root.get_node_or_null("enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_failed.connect(_on_player_failed)


#LEVEL MESSAGE
func show_message(text):
	message.text = text
	message.visible = true
	
	await get_tree().create_timer(2.0).timeout
	message.visible = false
	
		
#signals
func _on_exit_body_entered(body: Node2D)-> void:
	if body.name == "player":
		if level >= LASTLEVEL:
			print("Game completed")
			_winner()
			return
			
		level+=1
		body.can_move = false
		await _load_level(level, false, false)

func _on_player_failed(body):
	body.fail()
	level = 1
	await _load_level(level, false, true)

func _winner() -> void:
	var winning_sound = current_level_root.get_node("player/winningSound")
	winning_sound.play()
	emit_signal("win")


func _increase_score() -> void:
	score += 5
	score_label.text = "SCORE: %s" % score
	if score == 20 || score == 50 || score == 100:
		_winner()
		

#--------------------------
#THE FADE PART
#--------------------------

func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished
