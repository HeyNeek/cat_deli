extends Node2D

@onready var order_scene = preload("res://scenes/order.tscn")
@onready var start_text = Label.new()

var bread_for_the_day = 100

func _ready():
	start_text.text = "START!!!"
	start_text.position = Vector2(781, 486)
	get_tree().current_scene.add_child(start_text)
	await get_tree().create_timer(1).timeout
	start_text.queue_free()
	make_new_order()

func make_new_order():
	var order_instance = order_scene.instantiate()
	get_tree().current_scene.add_child(order_instance)
	
	order_instance.position = Vector2(781, 486)
