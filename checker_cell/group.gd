extends ButtonGroup
var current_btn = null
func get_current_button():
	return current_btn
	
func set_current_button():
	current_btn = get_pressed_button()
	
func is_anychosen():
	return current_btn != null
	
func clear_current_button():
	current_btn = null

func get_button_byVector(x,y):
	for button in get_buttons():
		if button.vector[0] == x and button.vector[1] == y:
			return button
			
func is_empty_button(x,y):
	return get_button_byVector(x,y).text == ""
