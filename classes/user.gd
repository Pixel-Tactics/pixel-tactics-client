extends Node

class_name User

var username
var level
var exp
var max_exp
var rating

func _init(iusername, ilevel, iexp, irating):
	username = iusername
	level = ilevel
	exp = iexp
	max_exp = iexp
	rating = irating
