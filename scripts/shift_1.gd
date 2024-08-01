extends Node2D

@onready var order_scene = preload("res://scenes/order.tscn")
@onready var start_text_scene = preload("res://scenes/start_text.tscn")

@onready var orders_completed_text = $OrdersCompletedText

var bread_for_the_day = 100
var orders_completed = 0

func _ready():
	orders_completed_text.text = "Orders Completed: " + str(orders_completed)
	var start_text = start_text_scene.instantiate()
	start_text.position = Vector2(825, 486)
	get_tree().current_scene.add_child(start_text)
	
	await get_tree().create_timer(1).timeout
	
	start_text.queue_free()
	
	make_new_order()

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func make_new_order():
	var order_instance = order_scene.instantiate()
	get_tree().current_scene.add_child(order_instance)
	order_instance.connect("order_completed", _on_order_completed)
	
	order_instance.position = Vector2(550, 486)

#i think we would destroy the order node in here and create a new one 
func _on_order_completed():
	bread_for_the_day -= 1
	orders_completed += 1
	orders_completed_text.text = "Orders Completed: " + str(orders_completed)
