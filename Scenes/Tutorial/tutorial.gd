extends Node3D

func _ready():
	globals.time_manager.start_time()


func _on_area_3d_body_entered(_body):
	SceneManager.change_scene(SceneManager.Scene.HOMEBASE)
