/obj/structure/grille
	desc = "A flimsy framework of metal rods."
	name = "grille"
	icon = 'icons/obj/structures.dmi'
	icon_state = "grille"
	base_icon_state = "grille"
	density = TRUE
	anchored = TRUE
	pass_flags_self = PASSGRILLE
	flags_1 = CONDUCT_1 | RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1
	armor = list(MELEE = 50, BULLET = 70, LASER = 70, ENERGY = 100, BOMB = 10, BIO = 100, RAD = 100, FIRE = 0, ACID = 0)
	max_integrity = 50
	integrity_failure = 0.4
	var/rods_type = /obj/item/stack/rods
	var/rods_amount = 2
	var/rods_broken = TRUE
	var/grille_type = null
	var/broken_type = /obj/structure/grille/broken

/obj/structure/grille/Destroy()
	update_cable_icons_on_turf(get_turf(src))
	return ..()

/obj/structure/grille/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	update_appearance()

/obj/structure/grille/update_appearance(updates)
	if(QDELETED(src) || broken)
		return

	. = ..()
	if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
		QUEUE_SMOOTH(src)

/obj/structure/grille/update_icon_state()
	icon_state = "[base_icon_state][((atom_integrity / max_integrity) <= 0.5) ? "50_[rand(0, 3)]" : null]"
	return ..()

/obj/structure/grille/examine(mob/user)
	. = ..()
	if(anchored)
		. += "<span class='notice'>It's secured in place with <b>screws</b>. The rods look like they could be <b>cut</b> through.</span>"
	if(!anchored)
		. += "<span class='notice'>The anchoring screws are <i>unscrewed</i>. The rods look like they could be <b>cut</b> through.</span>"

/obj/structure/grille/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 20, "cost" = 5)
		if(RCD_WINDOWGRILLE)
			if(the_rcd.window_glass == RCD_WINDOW_REINFORCED)
				return list("mode" = RCD_WINDOWGRILLE, "delay" = 40, "cost" = 12)
			return list("mode" = RCD_WINDOWGRILLE, "delay" = 20, "cost" = 8)
	return FALSE

/obj/structure/grille/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, "<span class='notice'>You deconstruct the grille.</span>")
			qdel(src)
			return TRUE
		if(RCD_WINDOWGRILLE)
			if(!isturf(loc))
				return FALSE
			var/turf/T = loc
			if(!ispath(the_rcd.window_type, /obj/structure/window))
				CRASH("Invalid window path type in RCD: [the_rcd.window_type]")
			var/obj/structure/window/window_path = the_rcd.window_type
			if(!valid_window_location(T, user.dir, is_fulltile = initial(window_path.fulltile)))
				return FALSE
			to_chat(user, "<span class='notice'>You construct the window.</span>")
			var/obj/structure/window/WD = new the_rcd.window_type(T, user.dir)
			WD.set_anchored(TRUE)
			return TRUE
	return FALSE

/obj/structure/grille/Bumped(atom/movable/AM)
	if(!ismob(AM))
		return
	var/mob/M = AM
	shock(M, 70)

/obj/structure/grille/attack_animal(mob/user, list/modifiers)
	. = ..()
	if(!.)
		return
	if(!shock(user, 70) && !QDELETED(src)) //Last hit still shocks but shouldn't deal damage to the grille
		take_damage(rand(5,10), BRUTE, MELEE, 1)

/obj/structure/grille/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/grille/hulk_damage()
	return 60

/obj/structure/grille/attack_hulk(mob/living/carbon/human/user)
	if(shock(user, 70))
		return
	. = ..()

/obj/structure/grille/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src, ATTACK_EFFECT_KICK)
	user.visible_message("<span class='warning'>[user] hits [src].</span>", null, null, COMBAT_MESSAGE_RANGE)
	log_combat(user, src, "hit")
	if(!shock(user, 70))
		take_damage(rand(5,10), BRUTE, MELEE, 1)

/obj/structure/grille/attack_alien(mob/living/user, list/modifiers)
	user.do_attack_animation(src)
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message("<span class='warning'>[user] mangles [src].</span>", null, null, COMBAT_MESSAGE_RANGE)
	if(!shock(user, 70))
		take_damage(20, BRUTE, MELEE, 1)

/obj/structure/grille/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(!. && istype(mover, /obj/projectile))
		return prob(30)

/obj/structure/grille/CanAStarPass(ID, dir, pathfinding_atom)
	. = !density
	if(ismovable(pathfinding_atom))
		var/atom/movable/mover = pathfinding_atom
		. = . || (mover.pass_flags & PASSGRILLE)

/obj/structure/grille/attackby(obj/item/W, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	add_fingerprint(user)
	if(W.tool_behaviour == TOOL_WIRECUTTER)
		if(!shock(user, 100))
			W.play_tool_sound(src, 100)
			deconstruct()
	else if((W.tool_behaviour == TOOL_SCREWDRIVER) && (isturf(loc) || anchored))
		if(!shock(user, 90))
			W.play_tool_sound(src, 100)
			set_anchored(!anchored)
			user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] [src].</span>", \
				"<span class='notice'>You [anchored ? "fasten [src] to" : "unfasten [src] from"] the floor.</span>")
			return
	else if(istype(W, /obj/item/stack/rods) && broken)
		var/obj/item/stack/rods/R = W
		if(!shock(user, 90))
			user.visible_message("<span class='notice'>[user] rebuilds the broken grille.</span>", \
				"<span class='notice'>You rebuild the broken grille.</span>")
			new grille_type(src.loc)
			R.use(1)
			qdel(src)
			return

//window placing begin
	else if(is_glass_sheet(W))
		if (!broken)
			var/obj/item/stack/ST = W
			if (ST.get_amount() < 2)
				to_chat(user, "<span class='warning'>You need at least two sheets of glass for that!</span>")
				return
			var/dir_to_set = SOUTHWEST
			if(!anchored)
				to_chat(user, "<span class='warning'>[src] needs to be fastened to the floor first!</span>")
				return
			for(var/obj/structure/window/WINDOW in loc)
				to_chat(user, "<span class='warning'>There is already a window there!</span>")
				return
			to_chat(user, "<span class='notice'>You start placing the window...</span>")
			if(do_after(user,20, target = src))
				if(!src.loc || !anchored) //Grille broken or unanchored while waiting
					return
				for(var/obj/structure/window/WINDOW in loc) //Another window already installed on grille
					return
				var/obj/structure/window/WD
				if(istype(W, /obj/item/stack/sheet/plasmarglass))
					WD = new/obj/structure/window/plasma/reinforced/fulltile(drop_location()) //reinforced plasma window
				else if(istype(W, /obj/item/stack/sheet/plasmaglass))
					WD = new/obj/structure/window/plasma/fulltile(drop_location()) //plasma window
				else if(istype(W, /obj/item/stack/sheet/rglass))
					WD = new/obj/structure/window/reinforced/fulltile(drop_location()) //reinforced window
				else if(istype(W, /obj/item/stack/sheet/titaniumglass))
					WD = new/obj/structure/window/shuttle(drop_location())
				else if(istype(W, /obj/item/stack/sheet/plastitaniumglass))
					WD = new/obj/structure/window/plasma/reinforced/plastitanium(drop_location())
				else
					WD = new/obj/structure/window/fulltile(drop_location()) //normal window
				WD.setDir(dir_to_set)
				WD.set_anchored(FALSE)
				WD.state = 0
				ST.use(2)
				to_chat(user, "<span class='notice'>You place [WD] on [src].</span>")
			return
//window placing end

	else if(istype(W, /obj/item/shard) || !shock(user, 70))
		return ..()

/obj/structure/grille/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src, 'sound/effects/grillehit.ogg', 80, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(src, 'sound/items/welder.ogg', 80, TRUE)


/obj/structure/grille/deconstruct(disassembled = TRUE)
	if(!loc) //if already qdel'd somehow, we do nothing
		return
	if(!(flags_1&NODECONSTRUCT_1))
		var/obj/R = new rods_type(drop_location(), rods_amount)
		transfer_fingerprints_to(R)
		qdel(src)
	..()

/obj/structure/grille/atom_break()
	. = ..()
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		icon_state = "brokengrille"
		set_density(FALSE)
		atom_integrity = 20
		broken = TRUE
		rods_amount = 1
		rods_broken = FALSE
		var/obj/R = new rods_type(drop_location(), rods_broken)
		transfer_fingerprints_to(R)
		qdel(src)

/obj/structure/grille/proc/repair_grille()
	if(broken)
		icon_state = "grille"
		set_density(TRUE)
		atom_integrity = max_integrity
		broken = FALSE
		rods_amount = 2
		rods_broken = TRUE
		return TRUE
	return FALSE

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user, prb)
	if(!anchored || broken)		// anchored/broken grilles are never connected
		return FALSE
	if(!prob(prb))
		return FALSE
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return FALSE
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src, 1, TRUE))
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			return TRUE
		else
			return FALSE
	return FALSE

/obj/structure/grille/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(isobj(AM))
		if(prob(50) && anchored && !broken)
			var/obj/O = AM
			if(O.throwforce != 0)//don't want to let people spam tesla bolts, this way it will break after time
				var/turf/T = get_turf(src)
				var/obj/structure/cable/C = T.get_cable_node()
				if(C)
					playsound(src, 'sound/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
					C.add_delayedload(C.newavail() * 0.0375) // you can gain up to 3.5 via the 4x upgrades power is halved by the pole so thats 2x then 1X then .5X for 3.5x the 3 bounces shock.
	return ..()

/obj/structure/grille/get_dumping_location(datum/component/storage/source,mob/user)
	return null

/obj/structure/grille/broken // Pre-broken grilles for map placement
	icon_state = "brokengrille"
	density = FALSE
	broken = TRUE
	rods_amount = 1
	rods_broken = FALSE
	grille_type = /obj/structure/grille
	broken_type = null
