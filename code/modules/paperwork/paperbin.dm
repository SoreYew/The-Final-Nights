#define PAPERS_PER_OVERLAY 8
#define PAPER_OVERLAY_PIXEL_SHIFT 2
/obj/item/paper_bin
	name = "paper bin"
	desc = "Contains all the paper you'll never need."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin0"
	inhand_icon_state = "sheet-metal"
	lefthand_file = 'icons/mob/inhands/misc/sheets_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/sheets_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 3
	throw_range = 7
	var/papertype = /obj/item/paper
	var/total_paper = 30
	var/list/paper_stack = list()
	var/obj/item/pen/bin_pen
	///Overlay of the pen on top of the bin.
	var/mutable_appearance/pen_overlay
	///Name of icon that goes over the paper overlays.
	var/bin_overlay_string = "paper_bin_overlay"
	///Overlay that goes over the paper overlays.
	var/mutable_appearance/bin_overlay

/obj/item/paper_bin/Initialize(mapload)
	. = ..()
	interaction_flags_item &= ~INTERACT_ITEM_ATTACK_HAND_PICKUP
	AddElement(/datum/element/drag_pickup)
	if(mapload)
		var/obj/item/pen/pen = locate(/obj/item/pen) in loc
		if(pen && !bin_pen)
			pen.forceMove(src)
			bin_pen = pen
	update_icon()

/obj/item/paper_bin/Destroy()
	QDEL_LIST(paper_stack)
	return ..()

/// Returns a fresh piece of paper
/obj/item/paper_bin/proc/generate_paper()
	var/obj/item/paper/paper = new papertype
	if(SSevents.holidays && SSevents.holidays[APRIL_FOOLS])
		if(prob(30))
			paper.add_raw_text("<font face=\"[CRAYON_FONT]\" color=\"red\"><b>HONK HONK HONK HONK HONK HONK HONK<br>HOOOOOOOOOOOOOOOOOOOOOONK<br>APRIL FOOLS</b></font>")
			paper.AddComponent(/datum/component/honkspam)
	return paper

/obj/item/paper_bin/dump_contents(atom/droppoint, collapse = FALSE)
	if(!droppoint)
		droppoint = drop_location()
	if(collapse)
		visible_message(span_warning("The stack of paper collapses!"))
	for(var/obj/item/paper/stacked_paper in paper_stack) //first, dump all of the paper that already exists
		stacked_paper.forceMove(droppoint)
		if(!stacked_paper.pixel_y)
			stacked_paper.pixel_y = rand(-3,3)
		if(!stacked_paper.pixel_x)
			stacked_paper.pixel_x = rand(-3,3)
		paper_stack -= stacked_paper
		total_paper -= 1
	for(var/i in 1 to total_paper) //second, generate new paper for the remainder
		var/obj/item/paper/new_paper = generate_paper()
		new_paper.forceMove(droppoint)
		if(!new_paper.pixel_y)
			new_paper.pixel_y = rand(-3,3)
		if(!new_paper.pixel_x)
			new_paper.pixel_x = rand(-3,3)
	if(bin_pen)
		var/obj/item/pen/pen = bin_pen
		pen.forceMove(droppoint)
		bin_pen = null
	total_paper = 0
	update_icon()

/obj/item/paper_bin/fire_act(exposed_temperature, exposed_volume)
	if(total_paper > 0)
		total_paper = 0
		QDEL_LIST(paper_stack)
		update_icon()

	..()

/obj/item/paper_bin/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/paper_bin/attack_hand(mob/user, list/modifiers)
	if(isliving(user))
		var/mob/living/living_mob = user
		if(!(living_mob.mobility_flags & MOBILITY_PICKUP))
			return
	user.changeNext_move(CLICK_CD_RAPID)
	if(at_overlay_limit())
		dump_contents(drop_location(), TRUE)
		return
	if(bin_pen)
		var/obj/item/pen/pen = bin_pen
		pen.add_fingerprint(user)
		pen.forceMove(user.loc)
		user.put_in_hands(pen)
		to_chat(user, span_notice("You take [pen] out of [src]."))
		bin_pen = null
		update_icon()
	else if(total_paper > 0)
		var/obj/item/paper/top_paper = pop(paper_stack) || generate_paper()
		total_paper -= 1
		top_paper.add_fingerprint(user)
		top_paper.forceMove(user.loc)
		user.put_in_hands(top_paper)
		to_chat(user, span_notice("You take [top_paper] out of [src]."))
		update_icon()
	else
		to_chat(user, span_warning("[src] is empty!"))
	add_fingerprint(user)
	return ..()

/obj/item/paper_bin/attackby(obj/item/I, mob/user, params)
	if(at_overlay_limit())
		dump_contents(drop_location(), TRUE)
		return
	if(istype(I, /obj/item/paper))
		var/obj/item/paper/paper = I
		if(!user.transferItemToLoc(paper, src, silent = FALSE))
			return
		to_chat(user, span_notice("You put [paper] in [src]."))
		paper_stack += paper
		total_paper += 1
		update_icon()
	else if(istype(I, /obj/item/pen) && !bin_pen)
		var/obj/item/pen/pen = I
		if(!user.transferItemToLoc(pen, src, silent = FALSE))
			return
		to_chat(user, span_notice("You put [pen] in [src]."))
		bin_pen = pen
		update_icon()
	else
		return ..()

/obj/item/paper_bin/proc/at_overlay_limit()
	return overlays.len >= MAX_ATOM_OVERLAYS - 1

/obj/item/paper_bin/examine(mob/user)
	. = ..()
	if(total_paper)
		. += "It contains [total_paper > 1 ? "[total_paper] papers" : "one paper"]."
	else
		. += "It doesn't contain anything."

/obj/item/paper_bin/update_icon_state()
	if(total_paper < 1)
		icon_state = "paper_bin0"
	else
		icon_state = "[initial(icon_state)]"
	return ..()

/obj/item/paper_bin/update_overlays()
	. = ..()

	var/static/reference_paper
	if (isnull(reference_paper))
		reference_paper = new /obj/item/paper

	if(bin_pen)
		pen_overlay = mutable_appearance(bin_pen.icon, bin_pen.icon_state)

	if(!bin_overlay)
		bin_overlay = mutable_appearance(icon, bin_overlay_string)

	if(total_paper > 0)
		for(var/paper_number in 1 to total_paper)
			if(paper_number != total_paper && paper_number % PAPERS_PER_OVERLAY != 0) //only top paper and every nth paper get overlays
				continue

			var/obj/item/paper/current_paper = paper_number > (total_paper - paper_stack.len) \
				? paper_stack[paper_stack.len - (total_paper - paper_number + 1) + 1] \
				: reference_paper

			var/mutable_appearance/paper_overlay = mutable_appearance(current_paper.icon, current_paper.icon_state)
			paper_overlay.color = current_paper.color
			paper_overlay.pixel_y = paper_number/PAPERS_PER_OVERLAY - PAPER_OVERLAY_PIXEL_SHIFT //gives the illusion of stacking
			. += paper_overlay
			if(paper_number == total_paper) //this is our top paper
				. += current_paper.overlays //add overlays only for top paper
				if(istype(src, /obj/item/paper_bin/bundlenatural))
					bin_overlay.pixel_y = paper_overlay.pixel_y //keeps binding centred on stack
				if(bin_pen)
					pen_overlay.pixel_y = paper_overlay.pixel_y //keeps pen on top of stack
		. += bin_overlay

	if(bin_pen)
		. += pen_overlay

/obj/item/paper_bin/construction
	name = "construction paper bin"
	desc = "Contains all the paper you'll never need, IN COLOR!"
	papertype = /obj/item/paper/construction

/obj/item/paper_bin/bundlenatural
	name = "natural paper bundle"
	desc = "A bundle of paper created using traditional methods."
	icon_state = null
	papertype = /obj/item/paper/natural
	resistance_flags = FLAMMABLE
	bin_overlay_string = "paper_bundle_overlay"
	///Cable this bundle is held together with.
	var/obj/item/stack/cable_coil/binding_cable

/obj/item/paper_bin/bundlenatural/attack_hand(mob/user, list/modifiers)
	..()
	if(total_paper < 1)
		qdel(src)

/obj/item/paper_bin/bundlenatural/fire_act(exposed_temperature, exposed_volume)
	qdel(src)

/obj/item/paper_bin/bundlenatural/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/paper/carbon))
		to_chat(user, span_warning("[W] won't fit into [src]."))
		return
	if(W.get_sharpness())
		if(W.use_tool(src, user, 1 SECONDS))
			to_chat(user, span_notice("You slice the cable from [src]."))
			deconstruct(TRUE)
	else
		..()

/obj/item/paper_bin/carbon
	name = "carbon paper bin"
	desc = "Contains all the paper you'll ever need, in duplicate!"
	icon_state = "paper_bin_carbon0"
	papertype = /obj/item/paper/carbon
	bin_overlay_string = "paper_bin_carbon_overlay"

#undef PAPERS_PER_OVERLAY
#undef PAPER_OVERLAY_PIXEL_SHIFT
