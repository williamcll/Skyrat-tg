/obj/effect/overlay/lock_effect
	icon = 'modular_skyrat/modules/gunpoint/icons/targeted.dmi'
	icon_state = "locking"
	layer = FLY_LAYER
	plane = GAME_PLANE
	appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	mouse_opacity = 0

/datum/overmap_lock
	var/datum/overmap_object/target
	var/datum/overmap_object/parent
	var/obj/effect/overlay/lock_effect/effect

	var/locked_on = FALSE

/datum/overmap_lock/New(source, aimed)
	parent = source
	parent.main_lock = src
	target = aimed
	effect = new
	target.my_visual.vis_contents += effect
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, .proc/Destroy)
	RegisterSignal(target, COMSIG_PARENT_QDELETING, .proc/Destroy)

	addtimer(CALLBACK(src, .proc/LockOn), 1 SECONDS)

/datum/overmap_lock/Destroy()
	target.my_visual.vis_contents -= effect
	qdel(effect)
	UnregisterSignal(parent, COMSIG_PARENT_QDELETING)
	UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	parent.main_lock = null
	target = null
	return ..()

/datum/overmap_lock/proc/LockOn()
	if(QDELETED(src))
		return
	locked_on = TRUE
	effect.icon_state = "locked"
