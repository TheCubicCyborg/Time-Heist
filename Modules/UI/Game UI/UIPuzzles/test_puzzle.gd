extends UIPuzzle

class_name TestPuzzle

signal puzzle_passed
@export var correct_answer = "password"

func _on_line_edit_text_submitted(new_text):
	if new_text == correct_answer:
		puzzle_passed.emit()
		close()
		print("correct!")
	else:
		print("incorrect!")
