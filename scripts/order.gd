extends Node2D

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
		"name": "turkey",
		"command": "UDUDUD"
	},
	{
		"name": "ham",
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
]

#input commands for different toppings
var toppings_array_dictionary = [
	{
		"name": "mayo",
		"command": "LRLR"
	},
	{
		"name": "mustard",
		"command": "LRLR"
	},
	{
		"name": "lettuce",
		"command": "UDRUDR"
	},
	{
		"name": "tomato",
		"command": "UDLUDLUDL"
	},
	{
		"name": "pickle",
		"command": "UDRUD"
	},
]

#flag variable to signify when the current sandwich is done or not
var is_current_sandwich_done = false

#variables to randomize the sandwich by meat, cheese, and num of toppings
var current_meat
var current_cheese
var amount_of_toppings

#step variables that keep track at where the user is at in the creation
#of the sandwich
var current_sandwich_step = 1
var current_bread_step = 0
var current_meat_step = 0
var current_cheese_step = 0
var current_topping_step = 0

func _process(_delta):
	if is_current_sandwich_done == false:
		make_sandwich()
	else:
		command_label.text = "Sandwich complete!"
		await get_tree().create_timer(1).timeout
		is_current_sandwich_done = false
		current_sandwich_step = 1
		current_bread_step = 0
		current_meat_step = 0
		current_cheese_step = 0
		current_topping_step = 0

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
	var meat_command_length = meat_array_dictionary[0].command.length()
	print(meat_command_length)
	
	if current_meat_step < meat_command_length:
		current_meat_command = meat_array_dictionary[0].command[current_meat_step]
		command_label.text = "Current meat Command: " + current_meat_command
	else:
		current_sandwich_step += 1
	
	var current_meat_input_check
	if current_meat_step < meat_command_length:
		current_meat_input_check = input_dictionary[current_meat_command]
	
	if current_meat_input_check && Input.is_action_just_pressed(current_meat_input_check):
		current_meat_step += 1

func put_cheese():
	var current_cheese_command
	var cheese_command_length = cheese_array_dictionary[0].command.length()
	print(cheese_command_length)
	
	if current_cheese_step < cheese_command_length:
		current_cheese_command = cheese_array_dictionary[0].command[current_cheese_step]
		command_label.text = "Current cheese Command: " + current_cheese_command
	else:
		current_sandwich_step += 1
	
	var current_cheese_input_check
	if current_cheese_step < cheese_command_length:
		current_cheese_input_check = input_dictionary[current_cheese_command]
	
	if current_cheese_input_check && Input.is_action_just_pressed(current_cheese_input_check):
		current_cheese_step += 1

func put_toppings():
	var current_topping_command
	var topping_command_length = toppings_array_dictionary[0].command.length()
	print(topping_command_length)
	
	if current_topping_step < topping_command_length:
		current_topping_command = toppings_array_dictionary[0].command[current_topping_step]
		command_label.text = "Current topping Command: " + current_topping_command
	else:
		current_sandwich_step += 1
	
	var current_topping_input_check
	if current_topping_step < topping_command_length:
		current_topping_input_check = input_dictionary[current_topping_command]
	
	if current_topping_input_check && Input.is_action_just_pressed(current_topping_input_check):
		current_topping_step += 1

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
