extends UI

func _on_try_again_pressed():
	#print("press restart")
	close()
	globals.restart_gameplay()


func _on_homebase_pressed():
	#print("press homebase")
	close()
	globals.to_homebase()

func handle_input(_delta):
	pass
