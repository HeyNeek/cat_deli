extends Control

@export var story_scene: PackedScene = null

@onready var story_mode_button = $StoryButton
@onready var quit_button = $QuitButton

func _on_story_button_pressed():
	get_tree().change_scene_to_packed(story_scene)

func _on_quit_button_pressed():
	get_tree().quit()
