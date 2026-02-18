extends Node

#@onready var scene_holder := $"../SceneHolder"
#@onready var current_scene := $"../SceneHolder/temp"
# since this is a global, need to assign these in _ready
var scene_holder: Node
var current_scene: Node

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
	print("---- change_scene called ----")
	print_stack()
	
	# clear current scene if there
	if current_scene:
		current_scene.queue_free()
		
	# instantiate designated scene and save ref
	current_scene = scene_paths[s].instantiate()
	scene_holder.add_child(current_scene)
	
func _ready() -> void:
	await get_tree().process_frame
	
	scene_holder = get_tree().current_scene.get_node("SceneHolder")
	
	change_scene(Scene.HOMEBASE)
