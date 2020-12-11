/datum/fossil
	///Name of whatever is in the fossil
	var/name = ""
	///Proceduraly genned description, make it something interesting
	var/desc = ""
	///Short descriptive hints about the fossil found. "quadruped", "thorny", "big", "small" etc.
	var/list/hints = list()
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
	var/amount = rand(2,3)
	if(amount > length(copied))
		amount = copied.len
	for(var/i in 1 to amount)
		var/string = pick_n_take(copied)
		returned += string
	return returned

/datum/fossil/fauna
	fossil_type = FOSSIL_TYPE_FAUNA

/datum/fossil/fauna/RandomizeFossil()
	name = pick(GLOB.alien_fauna_names)
	//LIMBS
	var/quadruped = TRUE
	if(prob(30))
		quadruped = FALSE
	hints += "It's seems like it's a [quadruped ? "quadruped" : "humanoid"]."
	desc += "[name] is a [quadruped ? "quadruped" : "humanoid"] resembling creature. "
	//HEIGHT
	var/height_tb = rand(3,20)
	var/height2_tb = rand(0,11)
	switch(height_tb)
		if(-INFINITY to 5)
			hints += "It resembles a small creature."
		if(5 to 8)
			hints += "It resembles an average-sized creature."
		if(9 to 14)
			hints += "It resembles an huge creature."
		if(15 to INFINITY)
			hints += "It resembles a gigantic creature."
	if(quadruped)
		height_tb = round(height_tb*0.6)
	var/real_height = "[height_tb]'[height2_tb] feet tall"
	desc += "It's standing at [real_height]. "
	//BUILD
	var/build = pick(list("strong", "average", "lithe", "oddly skinny", "very buff"))
	hints += "It's build is [build]."
	desc += "The creature's build is [build]. "
	//SKIN
	var/skin_rand = rand(1,3)
	var/skin_color = pick(list("black", "white", "orange", "green", "brown", "cream", "red", "green", "dark brown", "dark green"))
	switch(skin_rand)
		if(1)
			//SKIN
			desc += "It has [skin_color] skin. "
			hints += "It seems to have skin."
		if(2)
			//SCALES
			desc += "It has [skin_color] scales. "
			hints += "It seems to have scales."
		if(3)
			//FUR
			desc += "It has [skin_color] fur. "
			hints += "It seems to have fur."
	if(prob(50))
		var/skin_dis_rand = rand(1,4)
		switch(skin_dis_rand)
			if(1)
				desc += "There's discoloured patches spanning across their entire body. "
			if(2)
				desc += "There's scar-like markings across their body. "
			if(3)
				desc += "Their body has intricate looking markings, as if they're unknown runes. "
			if(4)
				switch(skin_rand)
					if(1)
						desc += "There's patches of scales around their limbs. "
					if(2)
						desc += "There's patches of fur in some spots of their body. "
					if(3)
						desc += "Some spots of their fur gradient to another color. "
	//HEAD AND HEAD FEATURES
	var/eye_string
	if(prob(15))
		hints += "Oddly, it seems to be missing it's head."
		desc += "The creature doesn't have a head, "
		var/no_head_rand = rand(1,4)
		switch(no_head_rand)
			if(1)
				desc += " instead in place of it there's tentacles sticking out. "
			if(2)
				desc += " in it's place there's a maw-like hole with fangs. "
			if(3)
				desc += " in it's place there's a tail-resembling appendage with a vertical maw. "
			if(4)
				desc += " as if the end of it was amputated. Their chest has a huge maw. "
	else
		//EYES
		var/eye_rand = rand(1,5)
		switch(eye_rand)
			if(1)
				eye_string = "It has no eyes. "
			if(2)
				eye_string = "It has a pair of eyes. "
			if(3)
				eye_string = "It has two pairs of eyes, lined one under the other. "
			if(4)
				eye_string = "It has three eyes, with the uneven one inbetween them. "
		if(eye_rand != 1)
			var/eye_color = pick(list("green", "red", "purple", "yellow", "brown", "blue", "white", "black"))
			if(prob(20))
				eye_string += "It's eyes are of [eye_color] color, and are glowing. "
			else
				eye_string += "It's eyes are of [eye_color] color. "
		desc += eye_string
		//HORNS
		if(prob(25))
			hints += "It seems to have horns."
			var/horn_rand = rand(1,3)
			switch(horn_rand)
				if(1)
					desc += "It has a single horn sticking out of the top of its snout. "
				if(1)
					desc += "It has two horns sticking out of its head. "
				if(1)
					desc += "It has several pairs of horns. "
		//FRILLS
		if(prob(25))
			hints += "It seems to have frills."
			var/frill_rand = rand(1,2)
			switch(frill_rand)
				if(1)
					desc += "It has two small frills sticking out of the sides of its head. "
				if(2)
					desc += "It has two large frills sticking out of the sides of its head. "
	//Body features
	//SPINES
	if(prob(30))
		hints += "It seems to have spines."
		var/spines_rand = rand(1,3)
		switch(spines_rand)
			if(1)
				desc += "It has membranous spines spanning across their back . "
			if(2)
				desc += "It has spiky spines poking out of their back. "
			if(3)
				desc += "It has a huge coat of fur on their back. "

	//WINGS AND WING FEATURES
	if(prob(20))
		hints += "It seems to have wings."
		var/wing_rand = rand(1,4)
		switch(wing_rand)
			if(1)
				desc += "It has feathery wings. "
			if(2)
				desc += "It has membranous wings. "
			if(3)
				desc += "It has insect wings. "
			if(4)
				desc += "It has wing-like spikes poking out of it's back. "
	//DIET
	var/diet_rand = rand(1,4)
	switch(diet_rand)
		if(1)
			desc += "It's carnivorous. "
		if(2)
			desc += "It's herbivorous. "
		if(3)
			desc += "It's omnivorous. "
		if(4)
			desc += "It's complex digestive tracts make it hard to establish its diet. "

/datum/fossil/fauna/flora
	fossil_type = FOSSIL_TYPE_FLORA

/datum/fossil/flora/RandomizeFossil()
	name = pick(GLOB.alien_flora_names)
	//Determine the "type" of the flora
	var/height_tb = rand(1,7)
	var/height2_tb = rand(0,11)

	switch(height_tb)
		if(1 to 2)
			hints += "It resembles a small plant."
		if(3 to 5)
			hints += "It resembles an average-sized plant."
		if(6 to 7)
			hints += "It resembles a huge plant."

	var/type_rand = rand(1,4)
	var/type_string
	switch(type_rand)
		if(1)
			//Bush 
			hints += "It resembles a bush"
			type_string = "bush"
		if(2)
			//Flower
			hints += "It resembles a flower."
			type_string = "flower"
		if(3)
			//Tree
			height_tb *= 4
			hints += "It resembles a tree."
			type_string = "tree"
		if(4)
			//Herb
			hints += "It resembles an herb."
			type_string = "herb"

	desc += "[name] is a flora, resembling a [type_string]. The average specimen grows as tall as [height_tb]'[height2_tb] feet tall. "

	var/color = pick(list("brown", "black", "white", "green", "dark green", "olive", "pink", "teal", "purple", "blue", "green"))
	switch(type_rand)
		if(1,2,4)
			desc += "It's stalks and leaves are [color]. "
		if(3)
			desc += "It's leaves are [color]. "
	var/color2 = pick(list("brown", "black", "white", "olive", "pink", "teal", "purple", "blue", "green", "yellow", "red", "crimson", "gray"))
	switch(type_rand)
		if(2)
			desc += "It's petals are [color2]. "
		if(3)
			desc += "It's trunk and branches are [color2]. "

	//Fruits
	if(prob(60))
		hints += "It seems to grow fruit."
		var/color3 = pick(list("brown", "black", "white", "olive", "pink", "teal", "purple", "blue", "green", "yellow", "red", "crimson", "gray"))
		if(prob(30))
			color3 = "glowing [color3]"
		var/fruit_rand = rand(1,4)
		switch(fruit_rand)
			if(1)
				//Small berries
				desc += "It grows fruit which resemble [color3] small berries. "
			if(2)
				//Spiky fruit
				desc += "It grows fruit which resemble [color3] balls with sharp spikes poking out of them. "
			if(3)
				//Banana shaped
				desc += "It grows fruit which resemble [color3] bananas. "
			if(4)
				//Apple shaped
				desc += "It grows fruit which resemble [color3] apples. "
		//Special reagent
		if(prob(70))
			var/reagent_rand = rand(1,7)
			switch(reagent_rand)
				if(1)
					desc += "It's fruit has rejuvenative properties. "
				if(2)
					desc += "It's fruit is poisonous. "
				if(3)
					desc += "It's fruit carries lethal poisons. "
				if(4)
					desc += "It's fruit seems to have intoxicating properties. "
				if(5)
					desc += "It's fruit works like a potent aphrodisiac. "
				if(6)
					desc += "It's fruit is extremely sour. "
				if(7)
					desc += "It's fruit is very sweet. "
	//Extras
	if(prob(25))
		hints += "It seems to have thorns."
		switch(type_rand)
			if(1,2,4)
				desc += "It's stalk has thorns. "
			if(3)
				desc += "It's trunk has thorns. "

	if(prob(45))
		var/weird_rand = rand(1,3)
		hints += "It seems to have weird spots over it."
		var/color4 = pick(list("brown", "black", "white", "olive", "pink", "teal", "purple", "blue", "green", "yellow", "red", "crimson", "gray"))
		switch(weird_rand)
			if(1)
				desc += "It has strange [color4] spots all over it. "
			if(2)
				desc += "It has [color4] vertical lines over it. "
			if(3)
				desc += "It's leaves gradient to a [color4] color'. "
