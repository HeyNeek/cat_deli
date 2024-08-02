extends Node2D

signal order_completed

@onready var command_label = $CommandLabel

#this will be so the char in the command can be translated to a godot input binding
var input_dictionary = {
	"D": "down_arrow",
	"U": "up_arrow",
	"L": "left_arrow",
	"R": "right_arrow"
}

#input command for cutting bread open
var bread_command = "DLRU"

#input commands for different meats
var meat_array_dictionary = [
	{
		"name": "Turkey",
		"command": "UDUDUD"
	},
	{
		"name": "Ham",
		"command": "UDUDUD"
	},
]

#input commands for different cheeses
var cheese_array_dictionary = [
	{
		"name": "Cheddar",
		"command": "DRDR"
	},
	{
		"name": "Swiss",
		"command": "DRDR"
	},
	{
		"name": "Pepper Jack",
		"command": "DRDR"
	},
]

#input commands for different toppings
var toppings_array_dictionary = [
	{
		"name": "Mayo",
		"command": "LRLR"
	},
	{
		"name": "Mustard",
		"command": "LRLR"
	},
	{
		"name": "Lettuce",
		"command": "UDRUDR"
	},
	{
		"name": "Tomato",
		"command": "UDLUDLUDL"
	},
	{
		"name": "Pickle",
		"command": "UDRUD"
	},
]

#flag variable to signify when the current sandwich is done or not
var is_current_sandwich_done = false

#variables to randomize the sandwich by meat, cheese, and num of toppings
var random_meat_index = randi_range(0, meat_array_dictionary.size() - 1)
var random_cheese_index = randi_range(0, cheese_array_dictionary.size() - 1)

var random_toppings_index_arr = []
var random_for_loop_length = randi_range(0, toppings_array_dictionary.size() - 1)

#step variables that keep track at where the user is at in the creation
#of the sandwich
var current_sandwich_step = 1
var current_bread_step = 0
var current_meat_step = 0
var current_cheese_step = 0
var current_topping_index = 0
var current_topping_step = 0

func _ready():
	populate_toppings()

#there may be something wrong with having this in _process idk
#update: actually it had more to do with putting an await call in here
#update 2: maybe it would make sense to destroy this node after we emit the signal rather than
#reinitializing everything? idk
func _process(_delta):
	if is_current_sandwich_done == false:
		make_sandwich()
	else:
		order_completed.emit()
		
		is_current_sandwich_done = false
		current_sandwich_step = 1
		current_bread_step = 0
		current_meat_step = 0
		current_cheese_step = 0
		current_topping_index = 0
		current_topping_step = 0
		
		random_toppings_index_arr = []
		random_for_loop_length = randi_range(0, toppings_array_dictionary.size() - 1)
		populate_toppings()
		
		random_meat_index = randi_range(0, meat_array_dictionary.size() - 1)
		random_cheese_index = randi_range(0, cheese_array_dictionary.size() - 1)

#this func is to randomly populate the toppings that go in the sandwich, but I need
#to add validation to make sure we dont get repeat toppings
func populate_toppings():
	for index in random_for_loop_length:
		var random_index = randi_range(1, toppings_array_dictionary.size() - 1)
		if !random_toppings_index_arr.has(random_index):
			random_toppings_index_arr.append(random_index)
	
	print(random_toppings_index_arr)

func cut_bread():
	var current_bread_command
	if current_bread_step < 4:
		current_bread_command = bread_command[current_bread_step]
		command_label.text = "Current Bread Command: " + current_bread_command
	else:
		current_sandwich_step += 1
	
	var current_bread_input_check
	if current_bread_step < 4:
		current_bread_input_check = input_dictionary[current_bread_command]
	
	if current_bread_input_check && Input.is_action_just_pressed(current_bread_input_check):
		current_bread_step += 1

func put_meat():
	var current_meat_command
	var meat_name = meat_array_dictionary[random_meat_index].name
	var meat_command_length = meat_array_dictionary[random_meat_index].command.length()
	
	if current_meat_step < meat_command_length:
		current_meat_command = meat_array_dictionary[random_meat_index].command[current_meat_step]
		command_label.text = "Current " + meat_name + " Command: " + current_meat_command
	else:
		current_sandwich_step += 1
	
	var current_meat_input_check
	if current_meat_step < meat_command_length:
		current_meat_input_check = input_dictionary[current_meat_command]
	
	if current_meat_input_check && Input.is_action_just_pressed(current_meat_input_check):
		current_meat_step += 1

func put_cheese():
	var current_cheese_command
	var cheese_name = cheese_array_dictionary[random_cheese_index].name
	var cheese_command_length = cheese_array_dictionary[random_cheese_index].command.length()
	
	if current_cheese_step < cheese_command_length:
		current_cheese_command = cheese_array_dictionary[random_cheese_index].command[current_cheese_step]
		command_label.text = "Current " + cheese_name + " Command: " + current_cheese_command
	else:
		current_sandwich_step += 1
	
	var current_cheese_input_check
	if current_cheese_step < cheese_command_length:
		current_cheese_input_check = input_dictionary[current_cheese_command]
	
	if current_cheese_input_check && Input.is_action_just_pressed(current_cheese_input_check):
		current_cheese_step += 1

func put_toppings():
	#the way Im currently accessing the random toppings is very ugly
	#should probably just add in the whole object in the randomized topping array
	#rather than getting the index and doing a nested arr call idk
	if current_topping_index == random_toppings_index_arr.size():
		print("finished putting on toppings")
		current_sandwich_step += 1
		return
	
	var current_topping_command
	var topping_name = toppings_array_dictionary[random_toppings_index_arr[current_topping_index]].name
	var topping_command_length = toppings_array_dictionary[random_toppings_index_arr[current_topping_index]].command.length()
	
	if current_topping_step < topping_command_length:
		current_topping_command = toppings_array_dictionary[random_toppings_index_arr[current_topping_index]].command[current_topping_step]
		command_label.text = "Current " + topping_name + " Command: " + current_topping_command
	elif current_topping_step == topping_command_length && current_topping_index < random_toppings_index_arr.size():
		print("finished topping")
		current_topping_index += 1
		current_topping_step = 0
		return
	
	var current_topping_input_check
	if current_topping_step < topping_command_length:
		current_topping_input_check = input_dictionary[current_topping_command]
	
	if current_topping_input_check && Input.is_action_just_pressed(current_topping_input_check):
		current_topping_step += 1
		print(current_topping_command)

func make_sandwich():
	if current_sandwich_step == 1:
		cut_bread()
	elif current_sandwich_step == 2:
		put_meat()
	elif current_sandwich_step == 3:
		put_cheese()
	elif current_sandwich_step == 4:
		put_toppings()
	elif current_sandwich_step == 5:
		is_current_sandwich_done = true
