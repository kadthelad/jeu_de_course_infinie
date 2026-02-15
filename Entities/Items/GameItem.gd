class_name GameItem
extends Resource

@export var ID := 0

@export var i_name := ""
@export_multiline var description := ""
@export var price := 0
@export var icon := Texture2D.new()
@export var effect : ItemEffect
