@tool
extends Node

var editor: ScriptEditor

func _ready():
	editor = EditorInterface.get_script_editor()

func _process(delta):
	if Engine.is_editor_hint() and editor.get_current_script().resource_name != "Replacer":
		var edit_control:CodeEdit = editor.get_current_editor().get_base_editor()
		var index = edit_control.text.find("@TIMEVAR")
		if index != -1:
			var starting_line = edit_control.get_caret_line()
			var var_i = edit_control.text.rfind("\n",index)
			var dec_line = edit_control.text.substr(var_i,index-var_i)
			dec_line = dec_line.get_slice(" ",1)
			var var_name = dec_line.substr(0,dec_line.find(":"))
			edit_control.start_action(TextEdit.ACTION_TYPING)
			edit_control.text = edit_control.text.replace("@TIMEVAR", "\n\tset(value):\n\t\t#timelog()\n\t\t%s = value" % var_name)
			edit_control.set_caret_line(starting_line + 3)
			edit_control.set_caret_column(var_name.length()+10)
