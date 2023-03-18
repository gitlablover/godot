extends PanelContainer

onready var grid = $VBoxContainer/PanelContainer/GridContainer
onready var copy = $VBoxContainer/HBoxContainer/Copy
onready var save = $VBoxContainer/HBoxContainer/Save
onready var mybtn = $VBoxContainer/HBoxContainer/Mybtn
onready var Swin_scene = preload("res://Swin.tscn").instance()
onready var Nwin_scene = preload("res://Nwin.tscn").instance()

func _ready():
	OS.min_window_size = OS.window_size
	
	
func _on_Mybtn_pressed():
	print("hello world")

func _on_Save_pressed():
	var data = []
	
	var skip = 0
	for cell in grid.get_children():
		if cell.text:
			if skip:
				data.append(skip)
				skip = 0
				
			data.append(cell.text)
		else:
			skip += 1
	
	save.hint_tooltip = str(data)
	
	var file = File.new()
	file.open("user://chess.dat", File.WRITE)
	file.store_string(var2str(data))
	file.close()
	
func _on_Load_pressed():
	var file = File.new()
	file.open("user://chess.dat", File.READ)
	var data = str2var(file.get_as_text())
	file.close()
	
	var skip = 0
	for cell in grid.get_children():
		if skip:
			cell.text = ""
			skip -= 1
		else:
			var val = data.pop_front()
			
			if val is int:
				skip = val -1
				
			elif val is String:
				cell.text = val
			
# https://www.chess.com/terms/fen-chess

