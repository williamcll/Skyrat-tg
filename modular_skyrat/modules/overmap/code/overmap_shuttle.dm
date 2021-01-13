/datum/overmap_object/shuttle
	name = "Shuttle"
	icon = 'modular_skyrat/modules/overmap/icons/shuttle.dmi'
	icon_state = "shuttle"
	var/obj/docking_port/mobile/my_shuttle = null
	var/do_move = FALSE
	var/do_angle = FALSE
	var/destination_x = 0
	var/destination_y = 0
	var/angle = 0
	var/max_engine_speed = 10
	var/last_relayed_direction

	var/partial_x = 0
	var/partial_y = 0

	var/velocity_x = 0
	var/velocity_y = 0

	var/target_speed = 0

	interact_flags = OMI_LOCKABLE

/datum/overmap_object/shuttle/proc/SetLockTo(target)
	if(main_lock)
		if(main_lock.target == target)
			return
		else
			qdel(main_lock)
	main_lock = new(src, target)

/datum/overmap_object/shuttle/proc/AbortLock()
	if(main_lock)
		qdel(main_lock)

/datum/overmap_object/shuttle/New()
	..()
	START_PROCESSING(SSfastprocess, src)

/datum/overmap_object/shuttle/process(delta_time)
	//var/datum/point/vector/V = new(x, y, 0, 0, 0, angle)
	/*
	else if (last_relayed_direction == WEST)
		angle -= 10
	else if (last_relayed_direction == EAST)
		angle += 10
	*/
	if(do_move)
		if(do_angle)
			var/target_angle = Get_Angle(locate(x,y,current_system.z_level), locate(destination_x,destination_y,current_system.z_level))
			var/my_angle = angle
			if(my_angle < 0)
				my_angle = 360 + my_angle
			var/diff = target_angle - my_angle
			var/left_turn = FALSE
			if(diff < 0)
				diff += 360
			if(diff > 180)
				diff = 360 - diff
				left_turn = TRUE
	
			if(left_turn)
				angle -= min(diff,10)
			else
				angle += min(diff,10)
	
			if(angle > 180)
				angle -= 360
			else if (angle < -180)
				angle += 360

			if(diff < 10)
				do_angle = FALSE

		if(last_relayed_direction == NORTH)
			var/added_velocity_x = 0.65 * sin(angle)
			var/added_velocity_y = 0.65 * cos(angle)
	
			velocity_x += added_velocity_x
			velocity_y += added_velocity_y

			my_visual.icon_state = "shuttle_forward"

		else if(last_relayed_direction == SOUTH)
	
			velocity_x *= 0.8
			velocity_y *= 0.8

			my_visual.icon_state = "shuttle_backwards"

		else
			my_visual.icon_state = "shuttle"


		last_relayed_direction = null

	velocity_x *= 0.93
	velocity_y *= 0.93

	var/add_partial_x = round(velocity_x)
	var/add_partial_y = round(velocity_y)

	partial_x += add_partial_x
	partial_y += add_partial_y
	if(partial_y > 16)
		partial_y -= 32
		y = min(y+1,world.maxy)
	else if(partial_y < -16)
		partial_y += 32
		y = max(y-1,1)
	if(partial_x > 16)
		partial_x -= 32
		x = min(x+1,world.maxx)
	else if(partial_x < -16)
		partial_x += 32
		x = max(x-1,1)

	if(do_move && x == destination_x && y == destination_y)
		StopMove()
	/*
	if(x != destination_x)
		if(destination_x > x)
			x++
		else
			x--
	if(y != destination_y)
		if(destination_y > y)
			y++
		else
			y--
	*/
	/*
	my_visual.pixel_x = partial_x
	my_visual.pixel_y = partial_y
	*/
	var/matrix/M = new
	M.Turn(angle)
	my_visual.transform = M
	update_visual_position()
	//if(y==destination_y && x==destination_x)
	//	StopMove()

/datum/overmap_object/shuttle/proc/CommandMove(dest_x, dest_y)
	destination_y = dest_y
	destination_x = dest_x
	do_move = TRUE
	do_angle = TRUE

/datum/overmap_object/shuttle/proc/StopMove()
	do_move = FALSE

/datum/overmap_object/shuttle/relaymove(mob/living/user, direction)
	do_move = TRUE
	last_relayed_direction = direction
