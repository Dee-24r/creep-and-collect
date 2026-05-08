extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collect_sound: AudioStreamPlayer2D = $collectSound

signal collected

func _on_body_entered(_body: Node2D) -> void:
	if _body.name != "player":
		return
		
	animated_sprite_2d.animation = "collected"
	collect_sound.play()
	collected.emit()
	call_deferred("_disable_collision")

func _disable_collision() -> void:
	collision_shape_2d.disabled = true


func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite_2d.animation == "collected":
		queue_free()
