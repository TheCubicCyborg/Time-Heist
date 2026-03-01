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

const START_SCENE := Scene.HOMEBASE
const ROOT_SCENE_NAME := "TimeHeist"


func change_scene(s: Scene) -> void:
	# clear current scene if there
	if current_scene:
		current_scene.queue_free()
		
	# instantiate designated scene and save ref
	current_scene = scene_paths[s].instantiate()
	if scene_holder:
		scene_holder.add_child(current_scene)
	
func _ready() -> void:
	await get_tree().process_frame
	
	scene_holder = Node.new()
	add_child(scene_holder)
	
	if get_tree().current_scene.name == ROOT_SCENE_NAME:
		change_scene(START_SCENE)
