extends Node2D
class_name Game

static var language_en:bool = true
static var tooltip:PanelContainer

static func switchLanguage(btn:Button):
	if language_en:
		language_en = false
		btn.text = "简体中文"
	else:
		language_en = true
		btn.text = "English"
