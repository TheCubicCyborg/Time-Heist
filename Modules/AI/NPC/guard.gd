@tool
class_name Guard extends NPC

#enum AlertStates {NORMAL, SUSPICIOUS, ALERT}

#var state = AlertStates.NORMAL

@export var cone_vision: ConeVision
@export var alert_time: float = 1
@export var caught_time: float = 2

var time_offset: float = 0
var alert: bool = false

func _ready():
	super()
	cone_vision.time_till_caught = caught_time

func _process(_delta):
	if not Engine.is_editor_hint():
		if not path_following:
			return
		
		if cone_vision.time_detecting > 0:
			time_offset += globals.time_manager.delta_time
			if cone_vision.time_detecting >= alert_time:
				if not alert:
					$torso.get_surface_override_material(0).emission = Color(1.0, 0.0, 0.0, 1.0)
				alert = true
			if cone_vision.time_detecting >= caught_time:
				#globals.player_caught()
				print("player caught")
			
			if alert and cone_vision.time_detecting < alert_time:
				$torso.get_surface_override_material(0).emission = color
		else:
			var cur_time = time_manager.cur_time - time_offset
			if path_following.loop:
				cur_time = fmod(cur_time,path_following.get_path_duration())
			if last_processed_time > cur_time: # moved backward in time
				path_following.revert(self,last_processed_time,cur_time)
			elif last_processed_time < cur_time: # moved forward in time
				path_following.progress(self,last_processed_time,cur_time)
			last_processed_time = cur_time
