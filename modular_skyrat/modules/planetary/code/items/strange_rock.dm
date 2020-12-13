/obj/item/strange_rock
	name = "strange rock"
	desc = "It seems like there's something inside, encased with fringe layers of rock that seem like they'd peel away at your touch."
	icon = 'modular_skyrat/modules/planetary/icons/items/strange_rock.dmi'
	icon_state = "strange"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/strange_rock/Initialize()
	. = ..()
	icon_state = "strange[rand(0,3)]"

/obj/item/strange_rock/attack_self(mob/user)
	. = ..()
	if(.)
		return
	to_chat(user, "<span class='notice'>You carefully crack open [src].</span>")
	playsound(src, 'sound/effects/break_stone.ogg', 30, TRUE)
	qdel(src)
	for(var/obj/item/I in contents)
		if(!user.put_in_hand(I))
			I.forceMove(get_turf(src))
