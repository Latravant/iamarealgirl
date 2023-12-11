--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--
--	Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
--
--	Editing this file will cause you to be unable to use Github Desktop to update!
--
--	Any changes you wish to make in this file you should be able to make by overloading. That is Re-Defining the same variables or functions in another file, by copying and
--	pasting them to a file that is loaded after the original file, all of my library files, and then job files are loaded first.
--	The last files to load are the ones unique to you. User-Globals, Charactername-Globals, Charactername_Job_Gear, in that order, so these changes will take precedence.
--
--	You may wish to "hook" into existing functions, to add functionality without losing access to updates or fixes I make, for example, instead of copying and editing
--	status_change(), you can instead use the function user_status_change() in the same manner, which is called by status_change() if it exists, most of the important 
--  gearswap functions work like this in my files, and if it's unique to a specific job, user_job_status_change() would be appropriate instead.
--
--  Variables and tables can be easily redefined just by defining them in one of the later loaded files: autofood = 'Miso Ramen' for example.
--  States can be redefined as well: state.HybridMode:options('Normal','PDT') though most of these are already redefined in the gear files for editing there.
--	Commands can be added easily with: user_self_command(commandArgs, eventArgs) or user_job_self_command(commandArgs, eventArgs)
--
--	If you're not sure where is appropriate to copy and paste variables, tables and functions to make changes or add them:
--		User-Globals.lua - 			This file loads with all characters, all jobs, so it's ideal for settings and rules you want to be the same no matter what.
--		Charactername-Globals.lua -	This file loads with one character, all jobs, so it's ideal for gear settings that are usable on all jobs, but unique to this character.
--		Charactername_Job_Gear.lua-	This file loads only on one character, one job, so it's ideal for things that are specific only to that job and character.
--
--
--	If you still need help, feel free to contact me on discord or ask in my chat for help: https://discord.gg/ug6xtvQ
--  !Please do NOT message me in game about anything third party related, though you're welcome to message me there and ask me to talk on another medium.
--
--  Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    -- Load and initialize the include file.
    include('Sel-Include.lua')
	include('organizer-lib')		
end

    -- Setup vars that are user-independent.
function job_setup()

    state.Buff.Souleater = buffactive.Souleater or false
    state.Buff['Dark Seal'] = buffactive['Dark Seal'] or false
	state.Buff['Nether Void'] = buffactive['Nether Void'] or false
    state.Buff['Aftermath'] = buffactive['Aftermath'] or false
    state.Buff['Aftermath: Lv.3'] = buffactive['Aftermath: Lv.3'] or false
    state.Buff.Hasso = buffactive.Hasso or false
    state.Buff.Seigan = buffactive.Seigan or false
	state.Stance = M{['description']='Stance','Hasso','Seigan','None'}
	state.DrainSwapWeaponMode = M{'Never','300','1000','Always'}
	
	autows = 'Resolution'
	autofood = 'Soy Ramen'
	
	update_melee_groups()

	init_job_states({"Capacity","AutoRuneMode","AutoTrustMode","AutoWSMode","AutoShadowMode","AutoFoodMode","AutoNukeMode","AutoStunMode","AutoDefenseMode",},{"AutoBuffMode","AutoSambaMode","Weapons","OffenseMode","WeaponskillMode","Stance","IdleMode","Passive","RuneElement","DrainSwapWeaponMode","CastingMode","TreasureMode",})
end
	
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
	
function job_precast(spell, spellMap, eventArgs)

	if spell.type == 'WeaponSkill' and state.AutoBuffMode.value ~= 'Off' then
		local abil_recasts = windower.ffxi.get_ability_recasts()
		if spell.english == 'Entropy' and not buffactive['Sekkanoki'] and abil_recasts[95] < latency then
			eventArgs.cancel = true
			windower.chat.input('/ja "Consume Mana" <me>')
			windower.chat.input:schedule(1,'/ws "Entropy" <t>')
			tickdelay = os.clock() + 1.25
			return
		elseif player.sub_job == 'SAM' and not state.Buff['SJ Restriction'] then
				if player.tp > 1850 and not buffactive['Consume Mana'] and abil_recasts[140] < latency then
					eventArgs.cancel = true
					windower.chat.input('/ja "Sekkanoki" <me>')
					windower.chat.input:schedule(1,'/ws "'..spell.english..'" '..spell.target.raw..'')
					tickdelay = os.clock() + 1.25
					return
				elseif abil_recasts[134] < latency then
					eventArgs.cancel = true
					windower.chat.input('/ja "Meditate" <me>')
					windower.chat.input:schedule(1,'/ws "'..spell.english..'" '..spell.target.raw..'')
					tickdelay = os.clock() + 1.25
					return
				end
			end
	end

end

function job_aftercast(spell, spellMap, eventArgs)
    if not spell.interrupted then
		if (spell.english == 'Drain II' or spell.english == 'Drain III') and state.DrainSwapWeaponMode.value ~= 'Never' then
			if player.equipment.main and sets.DrainWeapon and player.equipment.main == sets.DrainWeapon.main and player.equipment.main ~= sets.weapons[state.Weapons.value].main then
				equip_weaponset(state.Weapons.value)
			end
        elseif state.UseCustomTimers.value and (spell.english == 'Sleep' or spell.english == 'Sleepga') then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 60 down spells/00220.png')
        elseif spell.skill == 'Elemental Magic' and state.MagicBurstMode.value == 'Single' then
            state.MagicBurstMode:reset()
			if state.DisplayMode.value then update_job_states()	end
        end
    end
end

-- Modify the default idle set after it was constructed.
function job_customize_idle_set(idleSet)
    if player.mpp < 51 and (state.IdleMode.value == 'Normal' or state.IdleMode.value:contains('Sphere')) then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

-- Modify the default melee set after it was constructed.
function job_customize_melee_set(meleeSet)
    if state.Buff.Souleater and state.DefenseMode.current == 'None' then
        meleeSet = set_combine(meleeSet, sets.buff.Souleater)
    end

    return meleeSet
end

function job_customize_defense_set(defenseSet)
    return defenseSet
end

-- Run after the general precast() is done.
function job_post_precast(spell, spellMap, eventArgs)
	
	if spell.type == 'WeaponSkill' then

		local WSset = standardize_set(get_precast_set(spell, spellMap))
		local wsacc = check_ws_acc()
		
		if (WSset.ear1 == "Moonshade Earring" or WSset.ear2 == "Moonshade Earring") then
			-- Replace Moonshade Earring if we're at cap TP
			if get_effective_player_tp(spell, WSset) > 3200 then
				if wsacc:contains('Acc') and not buffactive['Sneak Attack'] and sets.AccMaxTP then
					local AccMaxTPset = standardize_set(sets.AccMaxTP)

					if (AccMaxTPset.ear1:startswith("Lugra Earring") or AccMaxTPset.ear2:startswith("Lugra Earring")) and not classes.DuskToDawn and sets.AccDayMaxTPWSEars then
						equip(sets.AccDayMaxTPWSEars[spell.english] or sets.AccDayMaxTPWSEars)
					else
						equip(sets.AccMaxTP[spell.english] or sets.AccMaxTP)
					end
				elseif sets.MaxTP then
					local MaxTPset = standardize_set(sets.MaxTP)
					if (MaxTPset.ear1:startswith("Lugra Earring") or MaxTPset.ear2:startswith("Lugra Earring")) and not classes.DuskToDawn and sets.DayMaxTPWSEars then
						equip(sets.DayMaxTPWSEars[spell.english] or sets.DayMaxTPWSEars)
					else
						equip(sets.MaxTP[spell.english] or sets.MaxTP)
					end
				else
				end
			else
				if wsacc:contains('Acc') and not buffactive['Sneak Attack'] and (WSset.ear1:startswith("Lugra Earring") or WSset.ear2:startswith("Lugra Earring")) and not classes.DuskToDawn and sets.AccDayWSEars then
					equip(sets.AccDayWSEars[spell.english] or sets.AccDayWSEars)
				elseif (WSset.ear1:startswith("Lugra Earring") or WSset.ear2:startswith("Lugra Earring")) and not classes.DuskToDawn and sets.DayWSEars then
					equip(sets.DayWSEars[spell.english] or sets.DayWSEars)
				end
			end
		elseif (WSset.ear1:startswith("Lugra Earring") or WSset.ear2:startswith("Lugra Earring")) and not classes.DuskToDawn then
			if wsacc:contains('Acc') and not buffactive['Sneak Attack'] and sets.AccDayWSEars then
				equip(sets.AccDayWSEars[spell.english] or sets.AccDayWSEars)
			elseif sets.DayWSEars then
				equip(sets.DayWSEars[spell.english] or sets.DayWSEars)
			end
		end
		
		if state.Buff.Souleater then   
			equip(sets.buff.Souleater)
		end
	end
end

Wants_Dark_Seal_maps = S{
	'Absorb-STR','Absorb-DEX','Absorb-VIT',
	'Absorb-INT','Absorb-MND','Absorb-CHR','Absorb-AGI','Absorb-ACC', 'Dread Spikes', 'Drain II', 'Drain III'}


function job_post_midcast(spell, spellMap, eventArgs)
if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' and spell.english ~= 'Impact' then
	if state.MagicBurstMode.value ~= 'Off' then equip(sets.MagicBurst) end
	if spell.element == world.weather_element or spell.element == world.day_element then
		if state.CastingMode.value == 'Fodder' then
			if spell.element == world.day_element then
				if item_available('Zodiac Ring') then
					sets.ZodiacRing = {ring2="Zodiac Ring"}
					equip(sets.ZodiacRing)
				end
			end
		end
	end
	
	if spell.element and sets.element[spell.element] then
		equip(sets.element[spell.element])
	end
elseif spell.skill == 'Dark Magic' then
	if state.Buff['Nether Void'] and sets.buff['Nether Void'] and (Wants_Dark_Seal_maps:contains(spell.english) or spell.english == 'Absorb-Attri') then
		equip(sets.buff['Nether Void'])
	end
	if state.Buff['Dark Seal'] and sets.buff['Dark Seal'] and Wants_Dark_Seal_maps:contains(spell.english)  then
		equip(sets.buff['Dark Seal'])
	end
	if (spell.english == 'Drain II' or spell.english == 'Drain III') and state.DrainSwapWeaponMode.value ~= 'Never' then
		if sets.DrainWeapon and (state.DrainSwapWeaponMode.value == 'Always' or tonumber(state.DrainSwapWeaponMode.value) > player.tp) then
			enable('main','sub','range','ammo')
			equip(sets.DrainWeapon)
		end
	end
		if Wants_Dark_Seal_maps:contains(spell.english) and spellMap == "Absorb" and state.DrainSwapWeaponMode.value ~= 'Never' then
		if sets.AbsorbWeapon and (state.DrainSwapWeaponMode.value == 'Always' or tonumber(state.DrainSwapWeaponMode.value) > player.tp) then
			enable('main','sub','range','ammo')
			equip(sets.AbsorbWeapon)
		end
	end
		if spell.english == 'Dread Spikes' and state.DrainSwapWeaponMode.value ~= 'Never' then
		if sets.DreadWeapon and (state.DrainSwapWeaponMode.value == 'Always' or tonumber(state.DrainSwapWeaponMode.value) > player.tp) then
			enable('main','sub','range','ammo')				
			equip(sets.DreadWeapon)
		end
	end
end
end 

function job_tick()
	if check_hasso() then return true end
	if check_buff() then return true end
	if check_buffup() then return true end
	return false
end

function job_update(cmdParams, eventArgs)
    update_melee_groups()
	
	if player.sub_job ~= 'SAM' and state.Stance.value ~= "None" then
		state.Stance:set("None")
		update_job_states()
	end
end

function job_buff_change(buff, gain)
	update_melee_groups()
end
	
function update_melee_groups()
    classes.CustomMeleeGroups:clear()
	
    if data.areas.adoulin:contains(world.area) and buffactive.Ionis then
		classes.CustomMeleeGroups:append('Adoulin')
    end
	
	if (player.equipment.main == "Liberator" and buffactive['Aftermath: Lv.3']) then
			classes.CustomMeleeGroups:append('AM')
	end
	
end

function check_hasso()
if player.sub_job == 'SAM' and player.status == 'Engaged' and not (state.Stance.value == 'None' or state.Buff.Hasso or state.Buff.Seigan or state.Buff['SJ Restriction'] or main_weapon_is_one_handed() or silent_check_amnesia()) then
		
		local abil_recasts = windower.ffxi.get_ability_recasts()
		
		if state.Stance.value == 'Hasso' and abil_recasts[138] < latency then
			windower.chat.input('/ja "Hasso" <me>')
			tickdelay = os.clock() + 1.1
			return true
		elseif state.Stance.value == 'Seigan' and abil_recasts[139] < latency then
			windower.chat.input('/ja "Seigan" <me>')
			tickdelay = os.clock() + 1.1
			return true
		else
			return false
		end
	end

	return false
end

function check_buff()
	if state.AutoBuffMode.value ~= 'Off' and not data.areas.cities:contains(world.area) then
		local spell_recasts = windower.ffxi.get_spell_recasts()
		for i in pairs(buff_spell_lists[state.AutoBuffMode.Value]) do
			if not buffactive[buff_spell_lists[state.AutoBuffMode.Value][i].Buff] and (buff_spell_lists[state.AutoBuffMode.Value][i].When == 'Always' or (buff_spell_lists[state.AutoBuffMode.Value][i].When == 'Combat' and (player.in_combat or being_attacked)) or (buff_spell_lists[state.AutoBuffMode.Value][i].When == 'Engaged' and player.status == 'Engaged') or (buff_spell_lists[state.AutoBuffMode.Value][i].When == 'Idle' and player.status == 'Idle') or (buff_spell_lists[state.AutoBuffMode.Value][i].When == 'OutOfCombat' and not (player.in_combat or being_attacked))) and spell_recasts[buff_spell_lists[state.AutoBuffMode.Value][i].SpellID] < latency and silent_can_use(buff_spell_lists[state.AutoBuffMode.Value][i].SpellID) then
				windower.chat.input('/ma "'..buff_spell_lists[state.AutoBuffMode.Value][i].Name..'" <me>')
				tickdelay = os.clock() + 2
				return true
			end
		end
		
		if player.in_combat then
			local abil_recasts = windower.ffxi.get_ability_recasts()

			if not buffactive['Last Resort'] and abil_recasts[87] < latency then
				windower.chat.input('/ja "Last Resort" <me>')
				tickdelay = os.clock() + 1.1
				return true
			elseif not buffactive['Scarlet Delirium'] and abil_recasts[44] < latency then
				windower.chat.input('/ja "Scarlet Delirium" <me>')
				tickdelay = os.clock() + 1.1
				return true
			elseif player.sub_job == 'WAR' and not buffactive.Berserk and abil_recasts[1] < latency then
				windower.chat.input('/ja "Berserk" <me>')
				tickdelay = os.clock() + 1.1
				return true
			elseif player.sub_job == 'WAR' and not buffactive.Aggressor and abil_recasts[4] < latency then
				windower.chat.input('/ja "Aggressor" <me>')
				tickdelay = os.clock() + 1.1
				return true
			else
				return false
			end
		end
	end
	return false
end

function check_buffup()
	if buffup ~= '' then
		local needsbuff = false
		for i in pairs(buff_spell_lists[buffup]) do
			if not buffactive[buff_spell_lists[buffup][i].Buff] and silent_can_use(buff_spell_lists[buffup][i].SpellID) then
				needsbuff = true
				break
			end
		end
	
		if not needsbuff then
			add_to_chat(217, 'All '..buffup..' buffs are up!')
			buffup = ''
			return false
		end
		
		local spell_recasts = windower.ffxi.get_spell_recasts()
		
		for i in pairs(buff_spell_lists[buffup]) do
			if not buffactive[buff_spell_lists[buffup][i].Buff] and silent_can_use(buff_spell_lists[buffup][i].SpellID) and spell_recasts[buff_spell_lists[buffup][i].SpellID] < spell_latency then
				windower.chat.input('/ma "'..buff_spell_lists[buffup][i].Name..'" <me>')
				tickdelay = os.clock() + 2
				return true
			end
		end
		
		return false
	else
		return false
	end
end

buff_spell_lists = {
	Auto = {	
		{Name='Dread Spikes',Buff='Dread Spikes',SpellID=277,When='Combat'},
	},
	
	Default = {
		{Name='Dread Spikes',Buff='Dread Spikes',SpellID=277,Reapply=false},
	},
}