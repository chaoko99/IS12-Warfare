// This is not very good code and could use cleanup and optimization, but
// I am very tired and will probably forget in the morning. C'est la vie. ~Z

#define FIRE_LIT   1
#define FIRE_OUT   0

/obj/structure/fire_source
	name = "campfire"
	desc = "Did anyone bring any marshmallows?"
	icon = 'icons/obj/fire.dmi'
	icon_state = "campfire"
	anchored = 1
	density = 0
	var/lit = 0

/obj/structure/fire_source/New()
	..()
	if(lit == FIRE_LIT)
		light()
	update_icon()


/obj/structure/fire_source/hearth/update_icon()
	..()
	if(lit == FIRE_LIT)
		density = 1


/obj/structure/fire_source/burningbarrel
	name = "barrel"
	desc = "They used to keep flamer fuel in these. There's a weird gel on the bottom, which burns seemingly forever."
	icon_state = "hobo"
	density = 1

/obj/structure/fire_source/burningbarrel/lit
	lit = 1
/*
/obj/structure/fire_source/fireplace
	name = "fireplace"
	desc = "So cheery!"
	icon_state = "fireplace"
	density = 1
*/

/obj/structure/fire_source/ex_act() // Did you know that explosions impart significant force upon things? Use grenades to blind them.
	die()

/obj/structure/fire_source/attack_hand(var/mob/user)
	die()
	return ..()

/obj/structure/fire_source/attackby(var/obj/item/thing, var/mob/user)

	// A spot of the old ultraviolence.
	if(istype(thing, /obj/item/grab) && open_flame)
		var/obj/item/grab/G = thing
		if(G.affecting)
			G.affecting.forceMove(get_turf(src))
			G.affecting.Weaken(3)
			visible_message("<span class='danger'>\The [user] hurls \the [G.affecting] onto \the [src]!</span>")
			burn(G.affecting)
			user.unEquip(G)
			qdel(G)
			return

	if(isflamesource(thing) && lit != FIRE_LIT)
		visible_message("<span class='notice'>\The [user] attempts to light \the [src] with \the [thing]...</span>")
		light()
		return

	return ..()

/obj/structure/fire_source/proc/light()
	if(lit == FIRE_LIT)
		return
	lit = FIRE_LIT
	playsound(src, 'sound/items/torch_light.ogg', 75, 1)
	visible_message("<span class='danger'>\The [src] catches alight!</span>")
	update_icon()
	return

/obj/structure/fire_source/proc/die()
	if(lit != FIRE_LIT)
		return
	lit = FIRE_OUT
	playsound(get_turf(src), 'sound/items/torch_snuff.ogg', 75, 1)
	visible_message("<span class='danger'>\The [src] goes out!</span>")
	update_icon()
	return

/obj/structure/fire_source/update_icon()
	if(lit == FIRE_LIT)
		icon_state = "icon_state-lit"
		set_light(6, 3,"#E38F46")
	else
		icon_state = initial(icon_state)
		set_light(0)

/obj/structure/fire_source/proc/burn(var/mob/living/victim)
	to_chat(victim, "<span class='danger'>You are burned by \the [src]!</span>")
	victim.IgniteMob()
	victim.apply_damage(rand(10,20), BURN)
