/datum/fossil
	///Name of whatever is in the fossil
	var/name
	///Proceduraly genned description, make it something interesting
	var/desc
	///Short descriptive hints about the fossil found. "quadruped", "thorny", "big", "small" etc.
	var/list/hints
	///Which planet is it from
	var/datum/planet_dictionary/origin
	///How many research points we get from this
	var/research_points = 7500
	///Whether it's a flora or a fauna
	var/fossil_type = FOSSIL_TYPE_FLORA
	///The lower the rarity the more rare it is
	var/rarity = 10

/datum/fossil/New(datum/planet_dictionary/ori)
	origin = ori
	RandomizeFossil()

/datum/fossil/proc/RandomizeFossil()
	return

/datum/fossil/proc/get_random_hints()
	var/list/copied = hints.Copy()
	var/list/returned = list()
	var/amount = rand(2,4)
	if(amount > length(copied))
		amount = copied.len
	for(var/i in 1 to amount)
		var/string = pick_n_take(copied)
		returned += string
	return returned

/datum/fossil/fauna/RandomizeFossil()
	name = pick(GLOB.alien_fauna_names)
	//

	//
	desc = "Oooh scary"
	//Height in inches
	//Build
	hints = list("scary", "stinky", "big", "did I mention scary", "horns", "frills")

/datum/fossil/fauna/RandomizeFossil()
	name = pick(GLOB.alien_flora_names)
	desc = "Oooh planty"
	hints = list("planty", "stinky planty", "big planty", "did I mention scary planty", "horn planty", "frills planty")
