extends Object

class_name User

var username
var level
var experience
var cur_experience
var max_experience
var rating
var token

func _init(iusername, ilevel, iexperience, icur_experience, imax_experience, irating, itoken):
	username = iusername
	level = ilevel
	experience = iexperience
	cur_experience = icur_experience
	max_experience = imax_experience
	rating = irating
	token = itoken
