extends Node

@onready var scene_holder := $"../SceneHolder"
@onready var current_scene := $"../SceneHolder/temp"

enum Scene {
	GAMEPLAY,
	HOMEBASE,
	MAIN_MENU
}
var scene_paths := {
	Scene.GAMEPLAY: preload("res://Scenes/Gameplay/Gameplay.tscn"),
	Scene.HOMEBASE: preload("res://Scenes/Homebase/Homebase.tscn"),
	Scene.MAIN_MENU: preload("res://Scenes/Main Menu/main_menu.tscn")
}

func change_scene(s: Scene) -> void:
	# clear current scene if there
	if current_scene:
		current_scene.queue_free()
		
	# instantiate designated scene and save ref
	current_scene = scene_paths[s].instantiate()
	scene_holder.add_child(current_scene)
	
func _ready() -> void:
	change_scene(Scene.MAIN_MENU)
