extends Node2D

var collisions = [
	preload("res://scenes/bullet_collision/common/Collision4x-0.png"),
	preload("res://scenes/bullet_collision/common/Collision4x-1.png"),
	preload("res://scenes/bullet_collision/common/Collision4x-2.png"),
	preload("res://scenes/bullet_collision/common/Collision8x-0.png"),
	preload("res://scenes/bullet_collision/common/Collision8x-1.png"),
	preload("res://scenes/bullet_collision/common/Collision8x-2.png"),
	preload("res://scenes/bullet_collision/common/Collision12x-0.png"),
	preload("res://scenes/bullet_collision/common/Collision12x-1.png"),
	preload("res://scenes/bullet_collision/common/Collision12x-2.png")
]

func _ready():
	randomize()
	
	var sprite1 = Sprite.new()
	sprite1.texture = collisions[int(round(rand_range(0, 8)))]
	sprite1.global_position = Vector2(int(round(rand_range(-8, 8))), int(round(rand_range(-8, 8))))
	add_child(sprite1)
	
	var image_delay = rand_range(0.01, 0.05)
	
	$Image1.interpolate_property(
		sprite1,
		"scale",
		Vector2.ZERO,
		Vector2(1,1),
		0.1,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN,
		image_delay
	)
	
	$Image1.interpolate_property(
		sprite1,
		"self_modulate",
		Color(1,1,1,1),
		Color(1,1,1,0),
		0.2,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	
	$Image1.start()
	
	var sprite2 = Sprite.new()
	sprite2.texture = collisions[int(round(rand_range(0, 8)))]
	sprite2.global_position = Vector2(int(round(rand_range(-8, 8))), int(round(rand_range(-8, 8))))
	add_child(sprite2)
	
	var image_delay2 = rand_range(0.01, 0.05)
	
	$Image2.interpolate_property(
		sprite2,
		"scale",
		Vector2.ZERO,
		Vector2(1,1),
		0.15,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT,
		image_delay2
	)
	
	$Image2.interpolate_property(
		sprite2,
		"self_modulate",
		Color(1,1,1,1),
		Color(1,1,1,0),
		0.2,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	
	$Image2.start()
	
	SoundManager.play(int(round(rand_range(SoundManager.Sound.BULLET_COLLISION_1, SoundManager.Sound.BULLET_COLLISION_6))))
	
#	var sprite3 = Sprite.new()
#	sprite3.texture = collisions[int(round(rand_range(0, 8)))]
#	sprite3.global_position = Vector2(int(round(rand_range(-8, 8))), int(round(rand_range(-8, 8))))
#	add_child(sprite3)
#
#	var image_delay3 = rand_range(0.01, 0.05)
#
#	$Image3.interpolate_property(
#		sprite3,
#		"scale",
#		Vector2.ZERO,
#		Vector2(1,1),
#		0.1,
#		Tween.TRANS_LINEAR,
#		Tween.EASE_OUT,
#		image_delay3
#	)
#
#	$Image3.interpolate_property(
#		sprite3,
#		"self_modulate",
#		Color(1,1,1,1),
#		Color(1,1,1,0),
#		0.2,
#		Tween.TRANS_LINEAR,
#		Tween.EASE_OUT
#	)
#
#	$Image3.start()

func _on_TimeToDelete_timeout():
	queue_free()
