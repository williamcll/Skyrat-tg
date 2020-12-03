/datum/fossil
	///Name of whatever is in the fossil
	var/name
	///Proceduraly genned description, make it something interesting
	var/desc
	///Short descriptive hints about the fossil found. "quadruped", "thorny", "big", "small" etc.
	var/list/hints
	///Which planet is it from
	var/origin
	///How many research points we get from this
	var/research_points
	///Unique ID for easy checking with RnD consoles
	var/fossil_id
	///Whether it's a flora or a fauna
	var/fossil_type = FOSSIL_TYPE_FLORA
	///The lower the rarity the more rare it is
	var/rarity = 1

