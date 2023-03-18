extends Button

onready var vector = [self.get_index()-9*(self.get_index()/9),self.get_index()/9]
onready var is_choosed = false
onready var btn_group = self.group
onready var enemy = ["x"]


func _ready():
	hint_tooltip = str(vector)
	if text == "x":
		enemy = ["p","n","b","r","k","q","g"]
	else:
		enemy = ["x"]

func is_doable_byV(text, v1, v2):
	var btn1 = btn_group.get_button_byVector(v1[0],v1[1])
	var btn2 = btn_group.get_button_byVector(v2[0],v2[1])
	var without_blocked = true
	var partbool = false
	if 1==1:  # true
		
		if text == "p":  # 小兵的走法
			partbool = v1[1] == v2[1]+1
			return v1[0] == v2[0] and  partbool
		elif text == "r":  # 车的走法
			var big
			var small
			partbool = v1[1] == v2[1] or v1[0] == v2[0]
			if v1[0] == v2[0]:  # 假如是纵向移动
				if v1[1]> v2[1]:
					big = v1[1]
					small = v2[1]
				else:
					big = v2[1]
					small = v1[1]
				for y in range(small+1, big):
					if not btn_group.is_empty_button(v1[0],y):
						without_blocked = false
			elif v1[1] ==v2[1]:  # 假如是横向移动
				if v1[0] > v2[0]:
					big = v1[0]
					small  = v2[0]
				else:
					big = v2[0]
					small = v1[0]
				for x in range(small+1, big):
					if not btn_group.is_empty_button(x,v1[1]):
						without_blocked = false
			return without_blocked and partbool
		elif text == "n":  # 马的走法
			if abs((v1[0]-v2[0])*(v1[1]-v2[1])) == 2:
				partbool = true  # 走日字
			if abs(v1[0]-v2[0]) == 2:  # 假如说是左右走
				without_blocked = btn_group.is_empty_button(v1[0]-(v1[0]-v2[0])/2,v1[1])
			elif abs(v1[1]-v2[1]) == 2:
				without_blocked = btn_group.is_empty_button(v1[0], v1[1]-(v1[1]-v2[1])/2)
			else: 
				without_blocked = false
			return without_blocked and partbool
		elif text == "g":  # 炮走法
			if btn2.text == "":  # 假设正常走路，是跟车一样走
				return is_doable("r",btn1, btn2)
			elif btn2.text in btn1.enemy:  # 假设是吃子走法
				var big
				var small
				var middiate = 0
				partbool = v1[1] == v2[1] or v1[0] == v2[0]
				if v1[0] == v2[0]:  # 假如是纵向移动
					if v1[1]> v2[1]:
						big = v1[1]
						small = v2[1]
					else:
						big = v2[1]
						small = v1[1]
					for y in range(small+1, big):
						if not btn_group.is_empty_button(v1[0],y):
							middiate += 1
				elif v1[1] == v2[1]:  # 假如是横向移动
					if v1[0] > v2[0]:
						big = v1[0]
						small  = v2[0]
					else:
						big = v2[0]
						small = v1[0]
					for x in range(small+1, big):
						if not btn_group.is_empty_button(x,v1[1]):
							middiate +=1
				without_blocked = middiate == 1
				return without_blocked and partbool
		elif text == "b":  # 象走法
			partbool = abs(v1[1]- v2[1]) == abs(v1[0]-v2[0])
			if partbool ==false:
				return false
			else:
				for x in range(1, abs(v1[0]- v2[0])):
					if not btn_group.is_empty_button(v1[0]-x*(v1[0]- v2[0])/abs(v1[0]- v2[0]) , v1[1]-x*(v1[1]- v2[1])/abs(v1[1]- v2[1])):
						without_blocked = false
				return without_blocked
		elif text == "x":  # 项羽的走法
			return is_doable_byV("r",v1,v2) or is_doable_byV("b",v1,v2) or is_doable_byV("n",v1,v2) or is_doable_byV("g",v1,v2)
		elif text == "k":  # 将的走法
			return abs((v1[0]-v2[0])) <= 1 and abs((v1[1]-v2[1])) <= 1
		else:  # 空位不能自己走
			return false
	
func is_doable(text,btn1,btn2):
	var v1 = btn1.vector
	var v2 = btn2.vector
	if text == "x":  # 假如选择的是x
		var partbool = btn2.text != "x"
		return is_doable_byV(text,v1,v2) and partbool
	else:  # 假如是x以外的棋子
		var partbool = btn2.text == "" or "x"
		return is_doable_byV(text, v1, v2) and partbool

	

	
func _toggled(button_pressed):
	if text == "x":  #刷新一下敌人表 
		enemy =  ["p","n","b","r","k","q","g"]
	else:
		enemy = ["x"]
	if is_choosed == true:  # 假如已经点上了，再点一下取消
		pressed = false
		is_choosed = false
	else:  # 假如还没点，点一下选中
		is_choosed = true
		if btn_group.is_anychosen():  # 假如已经点过其他按钮
			if is_doable(btn_group.get_current_button().text,btn_group.get_current_button(),self):  # 假如能走这里
				if text == "x": #假如吃掉了x
					get_tree().change_scene("res://Swin.tscn")
				if text == "k":
					get_tree().change_scene("res://Nwin.tscn")
				self.text = str(btn_group.get_current_button().text)
				
				
				btn_group.get_current_button().text = ""
				
				# 换位操作
				pressed = false
				btn_group.clear_current_button()
			else:  #假如不能走这里
				pressed = false
				btn_group.clear_current_button()
		btn_group.set_current_button()#反馈给按钮组目前选中的这个按钮


