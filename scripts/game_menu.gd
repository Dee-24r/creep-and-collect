extends Control
var game_mode
@onready var start_game: Button = $TextureRect/startGame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_stopwatch_btn_pressed() -> void:
	GameMenu.game_mode = "stopwatch_mode"
	start_game.disabled = false

func _on_timer_btn_pressed() -> void:
	GameMenu.game_mode = "timer_mode"
	start_game.disabled = false

func _on_start_game_pressed() -> void:
	print("MODE:", GameMenu.game_mode)
	get_tree().change_scene_to_file("res://scenes/mainn.tscn")
