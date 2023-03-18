extends Button

onready var vector = [self.get_index()-8*(self.get_index()/8),self.get_index()/8]
onready var is_choosed = false
onready var btn_group = self.group


func _ready():
	hint_tooltip = str(vector)

func is_doable(text,btn1,btn2):
	var v1 = btn1.vector
	var v2 = btn2.vector
	if btn2.text != "":  # 有队友棋子存在不能走
		return false
	elif btn1.text == "p":  # 小兵的走法
		var partbool = v1[1] == v2[1]-1
		return v1[0] == v2[0] and  partbool
	elif btn1.text == "r":  # 车的走法
		return v1[0] == v2[0]
	else:  # 空位不能自己走
		return false
	

	
func _toggled(button_pressed):
	if is_choosed == true:  # 假如已经点上了，再点一下取消
		pressed = false
		is_choosed = false
	else:  # 假如还没点，点一下选中
		is_choosed = true
		if btn_group.is_anychosen():  # 假如已经点过其他按钮
			if is_doable(self.text,btn_group.get_current_button(),self):  # 假如能走这里
				self.text = str(btn_group.get_current_button().text)
				btn_group.get_current_button().text = ""
				# 换位操作
				pressed = false
				btn_group.clear_current_button()
			else:  #假如不能走这里
				pressed = false
				btn_group.clear_current_button()
		btn_group.set_current_button()#反馈给按钮组目前选中的这个按钮


