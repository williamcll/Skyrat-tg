/obj/item/excavation_junk
	name = "ancient artifact"
	icon = 'modular_skyrat/modules/planetary/icons/items/excavation_junk.dmi'
	icon_state = "bowl"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/excavation_junk/Initialize()
	. = ..()
	var/random = rand(1,4)
	switch(random)
		if(1)
			name = "ancient bowl"
			desc = "An ancient looking bowl, used for obvious reasons."
			icon_state = "bowl"
		if(2)
			name = "ancient urn"
			desc = "An ancient urn, did aliens cremate their own?"
			icon_state = "urn"
		if(3)
			name = "ancient statuette"
			desc = "An ancient statuette, you're not quite sure what it's depicting."
			icon_state = "statuette"
		if(4)
			name = "ancient instrument"
			desc = "An ancient instrument, you can't wrap your head around on how to even begin to play that."
			icon_state = "instrument"
