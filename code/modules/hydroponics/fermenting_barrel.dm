/obj/structure/fermenting_barrel
	name = "wooden barrel"
	desc = "A large wooden barrel. You can ferment fruits and such inside it, or just use it to hold liquid."
	icon = 'icons/obj/objects.dmi'
	icon_state = "barrel"
	resistance_flags = FLAMMABLE
	density = TRUE
	anchored = FALSE
	max_integrity = 300
	var/open = FALSE
	var/speed_multiplier = 1 //How fast it distills. Defaults to 100% (1.0). Lower is better.

/obj/structure/fermenting_barrel/Initialize()
	// Bluespace beakers, but without the portability or efficiency in circuits.
	create_reagents(300, DRAINABLE)
	. = ..()

/obj/structure/fermenting_barrel/examine(mob/user)
	. = ..()
	. += "<span class='notice'>It is currently [open?"open, letting you pour liquids in.":"closed, letting you draw liquids from the tap."]</span>"

/obj/structure/fermenting_barrel/proc/makeWine(obj/item/food/grown/fruit)
	if(fruit.reagents)
		fruit.reagents.trans_to(src, fruit.reagents.total_volume)
	var/amount = fruit.seed.potency / 4
	if(fruit.distill_reagent)
		reagents.add_reagent(fruit.distill_reagent, amount)
	else
		var/data = list()
		data["names"] = list("[initial(fruit.name)]" = 1)
		data["color"] = fruit.filling_color
		data["boozepwr"] = fruit.wine_power
		if(fruit.wine_flavor)
			data["tastes"] = list(fruit.wine_flavor = 1)
		else
			data["tastes"] = list(fruit.tastes[1] = 1)
		reagents.add_reagent(/datum/reagent/consumable/ethanol/fruit_wine, amount, data)
	qdel(fruit)
	playsound(src, 'sound/effects/bubbles.ogg', 50, TRUE)

/obj/structure/fermenting_barrel/attackby(obj/item/I, mob/user, params)
	var/obj/item/food/grown/fruit = I
	if(istype(fruit))
		if(!fruit.can_distill)
			to_chat(user, "<span class='warning'>You can't distill this into anything...</span>")
			return TRUE
		else if(!user.transferItemToLoc(I,src))
			to_chat(user, "<span class='warning'>[I] is stuck to your hand!</span>")
			return TRUE
		to_chat(user, "<span class='notice'>You place [I] into [src] to start the fermentation process.</span>")
		addtimer(CALLBACK(src, PROC_REF(makeWine), fruit), rand(80, 120) * speed_multiplier)
		return TRUE
	if(I)
		if(I.is_refillable())
			return FALSE //so we can refill them via their afterattack.
	else
		return ..()

/obj/structure/fermenting_barrel/attack_hand(mob/user, list/modifiers)
	open = !open
	if(open)
		reagents.flags &= ~(DRAINABLE)
		reagents.flags |= REFILLABLE | TRANSPARENT
		to_chat(user, "<span class='notice'>You open [src], letting you fill it.</span>")
	else
		reagents.flags |= DRAINABLE
		reagents.flags &= ~(REFILLABLE | TRANSPARENT)
		to_chat(user, "<span class='notice'>You close [src], letting you draw from its tap.</span>")
	update_appearance()

/obj/structure/fermenting_barrel/update_icon_state()
	icon_state = open ? "barrel_open" : "barrel"
	return ..()

/datum/crafting_recipe/fermenting_barrel
	name = "Wooden Barrel"
	result = /obj/structure/fermenting_barrel
	reqs = list(/obj/item/stack/sheet/mineral/wood = 8)
	time = 50
	category = CAT_PRIMAL
