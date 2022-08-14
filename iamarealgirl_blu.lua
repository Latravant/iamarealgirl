-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
-- Initialization function for this job file.

function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('organizer-lib')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
    state.Buff.Convergence = buffactive.Convergence or false
    state.Buff.Diffusion = buffactive.Diffusion or false
    state.Buff.Efflux = buffactive.Efflux or false
    
    state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false

    
    include('Mote-TreasureHunter')
    state.TreasureMode:set('None')

    state.HasteMode = M{['description']='Haste Mode', 'Normal', 'Hi', 'Trust'}
	state.WeaponMode = M{['description']='Weapon Mode', 'DPS', 'SwordMA', 'ClubMA','TH'}
    blue_magic_maps = {}
    
    -- Mappings for gear sets to use for various blue magic spells.
    -- While Str isn't listed for each, it's generally assumed as being at least
    -- moderately signficant, even for spells with other mods.
    -- Physical Spells --
    
    -- Physical spells with no particular (or known) stat mods
    blue_magic_maps.Physical = S{
        'Bilgestorm'
    }

    -- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
    blue_magic_maps.PhysicalAcc = S{
        'Heavy Strike',
    }

    -- Physical spells with Str stat mod
    blue_magic_maps.PhysicalStr = S{
        'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
        'Empty Thrash','Quadrastrike','Sinker Drill','Spinal Cleave',
        'Uppercut','Vertical Cleave', 'Quadratic Continuum'
    }
        
    -- Physical spells with Dex stat mod
    blue_magic_maps.PhysicalDex = S{
        'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone','Disseverment',
        'Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
        'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault',
        'Vanity Dive'
    }
        
    -- Physical spells with Vit stat mod
    blue_magic_maps.PhysicalVit = S{
        'Body Slam','Cannonball','Delta Thrust','Glutinous Dart','Grand Slam',
        'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash',
        'Sweeping Gouge'
    }
        
    -- Physical spells with Agi stat mod
    blue_magic_maps.PhysicalAgi = S{
        'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
        'Pinecone Bomb','Spiral Spin','Wild Oats'
    }

    -- Physical spells with Int stat mod
    blue_magic_maps.PhysicalInt = S{
        'Mandibular Bite','Queasyshroom'
    }

    -- Physical spells with Mnd stat mod
    blue_magic_maps.PhysicalMnd = S{
        'Ram Charge','Screwdriver','Tourbillion'
    }

    -- Physical spells with Chr stat mod
    blue_magic_maps.PhysicalChr = S{
        'Bludgeon'
    }

    -- Physical spells with HP stat mod
    blue_magic_maps.PhysicalHP = S{
        'Final Sting'
    }

    -- Magical Spells --

    -- Magical spells with the typical Int mod
    blue_magic_maps.Magical = S{
        'Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere','Dark Orb','Death Ray',
        'Diffusion Ray','Droning Whirlwind','Embalming Earth','Firespit','Foul Waters',
        'Ice Break','Leafstorm','Maelstrom','Rail Cannon','Regurgitation','Rending Deluge',
        'Retinal Glare','Subduction','Tem. Upheaval','Water Bomb', 'Tenebral Crush', 'Spectral Floe',
        'Molting Plumage', 'Searing Tempest'
    }

    blue_magic_maps.MagicalLight = S{
        'Blinding Fulgor'
    }
    -- Magical spells with a primary Mnd mod
    blue_magic_maps.MagicalMnd = S{
        'Acrid Stream','Evryone. Grudge','Magic Hammer','Mind Blast','Scouring Spate'
    }

    -- Magical spells with a primary Chr mod
    blue_magic_maps.MagicalChr = S{
        'Eyes On Me','Mysterious Light'
    }

    -- Magical spells with a Vit stat mod (on top of Int)
    blue_magic_maps.MagicalVit = S{
        'Thermal Pulse', 'Entomb'
    }

    blue_magic_maps.MagicalAgi = S{
        'Silent Storm'
    }

    -- Magical spells with a Dex stat mod (on top of Int)
    blue_magic_maps.MagicalDex = S{
        'Charged Whisker','Gates of Hades','Anvil Lightning'
    }
            
    -- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
    -- Add Int for damage where available, though.
    blue_magic_maps.MagicAccuracy = S{
        '1000 Needles','Absolute Terror','Actinic Burst','Auroral Drape','Awful Eye',
        'Blank Gaze','Blistering Roar','Blood Drain','Blood Saber','Chaotic Eye',
        'Cimicine Discharge','Cold Wave','Corrosive Ooze','Demoralizing Roar','Digest',
        'Dream Flower','Enervation','Feather Tickle','Filamented Hold','Frightful Roar',
        'Geist Wall','Hecatomb Wave','Infrasonics','Jettatura','Light of Penance',
        'Lowing','Mind Blast','Mortal Ray','MP Drainkiss','Osmosis','Reaving Wind',
        'Sandspin','Sandspray','Sheep Song','Soporific','Sound Blast','Stinking Gas',
        'Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn'
    }
        
    -- Breath-based spells
    blue_magic_maps.Breath = S{
        'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath',
        'Hecatomb Wave','Magnetite Cloud','Poison Breath','Radiant Breath','Self-Destruct',
        'Thunder Breath','Vapor Spray','Wind Breath'
    }

    -- Stun spells
    blue_magic_maps.Stun = S{
        'Blitzstrahl','Frypan','Head Butt','Sudden Lunge','Tail slap','Temporal Shift',
        'Thunderbolt','Whirl of Rage'
    }
        
    -- Healing spells
    blue_magic_maps.Healing = S{
        'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','Restoral','White Wind',
        'Wild Carrot'
    }
    
    -- Buffs that depend on blue magic skill
    blue_magic_maps.SkillBasedBuff = S{
        'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body','Plasma Charge',
        'Pyric Bulwark','Reactor Cool','Nat. Meditation'
    }

    -- Other general buffs
    blue_magic_maps.Buff = S{
        'Amplification','Animating Wail','Battery Charge','Carcharian Verve','Cocoon',
        'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell',
        'Memento Mori','Nat. Meditation','Occultation','Orcish Counterstance','Refueling',
        'Regeneration','Saline Coat','Triumphant Roar','Warm-Up','Winds of Promyvion',
        'Zephyr Mantle'
    }
    
    
    -- Spells that require Unbridled Learning to cast.
    unbridled_spells = S{
        'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve',
        'Crashing Thunder','Droning Whirlwind','Gates of Hades','Harden Shell','Polar Roar',
        'Pyric Bulwark','Thunderbolt','Tourbillion','Uproot'
    }
    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Mid', 'Acc', 'Learning')
    state.HybridMode:options('Normal', 'PDT', 'EVA')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Learning')

    send_command('bind ^` input /ja "Chain Affinity" <me>')
    send_command('bind !` input /ja "Efflux" <me>')
    send_command('bind @` input /ja "Burst Affinity" <me>')
	send_command('bind ^w gs c cycle WeaponMode')
    send_command('bind @f9 gs c cycle HasteMode')
	send_command('bind PAGEUP gs c cycle IdleMode')
	
    update_combat_form()
    select_default_macro_book()
	send_command('wait 2; input /lockstyleset 16')
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind @`')
    send_command('unbind @f9')
	send_command('unbind PAGEUP')
	
	windower.send_command('sta !packets')
end


-- Set up gear sets.
function init_gear_sets()


    sets.buff['Burst Affinity'] = {feet="Hashi. Basmak +1"}
    sets.buff['Chain Affinity'] = {head="Hashishin Kavuk +1", feet="Assimilator's Charuqs +1"}
    sets.buff.Convergence = {head="Luhlaza Keffiyeh +2"}
    sets.buff.Diffusion = {feet="Luhlaza Charuqs +2"}
    sets.buff.Enchainment = {body="Luhlaza Jubbah +2"}
    sets.buff.Efflux = {legs="Hashishin Tayt +1"}
	
    sets.precast.JA['Azure Lore'] = {hands={ name="Luh. Bazubands +2", augments={'Enhances "Azure Lore" effect',}}}
    
    -- Precast Sets
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    sets.TreasureHunter = set_combine(sets.TH, {})
    
    sets.precast.FC = {
        ammo="Sapience Orb",
		head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
		body={ name="Luhlaza Jubbah +2", augments={'Enhances "Enchainment" effect',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+9','Mag. Acc.+5','"Mag.Atk.Bns."+6','"Fast Cast"+1',}},
		legs={ name="Lengo Pants", augments={'INT+7','Mag. Acc.+7','"Mag.Atk.Bns."+3','"Refresh"+1',}},
		feet={ name="Amalric Nails", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Conserve MP"+6',}},
		neck="Orunmila's Torque",
		waist="witful belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Naji's Loop",
		back="Swith Cape",
    }
        
    sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {    body="Hashishin Mintan +1",
    hands="Hashi. Bazu. +1"})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {    
	    ammo="Focal Orb",
		head={ name="Herculean Helm", augments={'Attack+5','Weapon skill damage +3%','DEX+4','Accuracy+14',}},
		body={ name="Herculean Vest", augments={'Pet: STR+10','Attack+26','"Treasure Hunter"+1','Accuracy+10 Attack+10','Mag. Acc.+12 "Mag.Atk.Bns."+12',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Herculean Trousers", augments={'Crit.hit rate+2','STR+7','Weapon skill damage +5%','Accuracy+18 Attack+18',}},
		feet={ name="Herculean Boots", augments={'Weapon skill damage +2%','Pet: Accuracy+28 Pet: Rng. Acc.+28','Quadruple Attack +1',}},
		neck="Asperity Necklace",
		waist="Grunfeld Rope",
		left_ear="Ishvara Earring",
		right_ear="Telos Earring",
		left_ring="Karieyh Ring",
		right_ring="Petrov Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','Weapon skill damage +10%','System: 1 ID: 640 Val: 4',}},
	}
    
    sets.precast.WS.acc = set_combine(sets.precast.WS, {    
		legs={ name="Taeon Tights", augments={'Pet: Accuracy+13 Pet: Rng. Acc.+13','Weapon Skill Acc.+10','AGI+9',}},
		waist="Caudata Belt",
		left_ring="Karieyh Ring",})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = {    
		ammo="Quartz Tathlum +1",
		head={ name="Carmine Mask", augments={'MP+60','INT+10','MND+10',}},
		body="Vanir Cotehardie",
		hands="Jhakri Cuffs +2",
		legs="Jhakri Slops +2",
		feet="Aya. Gambieras +2",
		neck="Imbodla Necklace",
		waist="Salire Belt",
		left_ear="Lifestorm Earring",
		right_ear="Influx Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Tuilha Cape",}

    sets.precast.WS['Sanguine Blade'] = {
        head="Hagondes Hat",neck="Eddy Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Hagondes Coat",hands="Hashi. Bazu. +1",ring1="Acumen Ring",ring2="Strendu Ring",
        back="Toro Cape",legs="Hagondes Pants",feet="Iuitl Gaiters +1"}
    
	sets.precast.WS['Chant du Cygne'] = {
        ammo="Cheruski Needle",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Jhakri Cuffs +2",
		legs={ name="Herculean Trousers", augments={'Crit.hit rate+2','STR+7','Weapon skill damage +5%','Accuracy+18 Attack+18',}},
		feet="Aya. Gambieras +2",
		neck="Fotia Gorget",
		waist="Artful Belt",
		left_ear="Ishvara Earring",
		right_ear="Odr Earring",
		left_ring="Ilabrat Ring",
		right_ring="Ramuh Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','Weapon skill damage +10%','System: 1 ID: 640 Val: 4',}},
		}

    sets.precast.WS['Savage Blade'] = {    
	    ammo="Cheruski Needle",
		head={ name="Herculean Helm", augments={'Attack+5','Weapon skill damage +3%','DEX+4','Accuracy+14',}},
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs={ name="Herculean Trousers", augments={'Crit.hit rate+2','STR+7','Weapon skill damage +5%','Accuracy+18 Attack+18',}},
		feet={ name="Herculean Boots", augments={'Weapon skill damage +2%','Pet: Accuracy+28 Pet: Rng. Acc.+28','Quadruple Attack +1',}},
		neck="Caro Necklace",
		waist="Caudata Belt",
		left_ear="Ishvara Earring",
		right_ear="Influx Earring",
		left_ring="Karieyh Ring",
		right_ring="Ifrit Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','Weapon skill damage +10%','System: 1 ID: 640 Val: 4',}},
		}
    
    -- Midcast Sets
    sets.midcast.FastRecast = {
        ammo="Sapience Orb",
		head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
		body="Vanir Cotehardie",
		hands={ name="Leyline Gloves", augments={'Accuracy+9','Mag. Acc.+5','"Mag.Atk.Bns."+6','"Fast Cast"+1',}},
		legs="Aya. Cosciales +2",
		feet={ name="Amalric Nails", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Conserve MP"+6',}},
		waist="Twilight Belt",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Naji's Loop",
		back="Swith Cape",}

    sets.midcast['Dark Magic'] = {
        ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",
        body="Shamash Robe",
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet="Jhakri Pigaches +2",
        neck="Erra Pendant",
        waist="Eschan Stone",
        ear1="Crepuscular Earring",
        ear2="Regal Earring",
        left_ring="Evanescence Ring",
        right_ring="Weather. Ring",
        back="Aput Mantle",
    }
    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        waist="Fucho-no-Obi",
    })
    sets.midcast.Aspir = sets.midcast.Drain
        
    sets.midcast['Blue Magic'] = {
        neck="Mirage Stole +1",
        body="Assimilator's Jubbah +1",
        back="Cornflower Cape",
        -- legs="Mavi Tayt +2",
        feet="Luhlaza Charuqs"
    }
    
    -- Physical Spells --
    
    sets.midcast['Blue Magic'].Physical = {
		ammo="Focal Orb",
		head="Jhakri Coronal +2",
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs="Jhakri Slops +2",
		feet={ name="Luhlaza Charuqs +2", augments={'Enhances "Diffusion" effect',}},
		neck="Sanctity Necklace",
		waist="Grunfeld Rope",
		left_ear="Bladeborn Earring",
		right_ear="Telos Earring",
		left_ring="Ilabrat Ring",
		right_ring="K'ayres Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','Weapon skill damage +10%','System: 1 ID: 640 Val: 4',}},    }

    sets.midcast['Blue Magic'].PhysicalAcc = {
		ammo="Hasty Pinion +1",
		head="Aya. Zucchetto +2",
		body={ name="Herculean Vest", augments={'Accuracy+18 Attack+18','"Triple Atk."+3','DEX+11','Accuracy+4','Attack+11',}},
		hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +2",
		feet={ name="Rawhide Boots", augments={'STR+10','Attack+15','"Store TP"+5',}},
		neck="Sanctity Necklace",
		waist="Grunfeld Rope",
		left_ear="Telos Earring",
		right_ear="Odr Earring",
		left_ring="Ilabrat Ring",
		right_ring="Ramuh Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','Weapon skill damage +10%','System: 1 ID: 640 Val: 4',}}
    }

    sets.midcast['Blue Magic'].PhysicalStr = set_combine(sets.midcast['Blue Magic'].Physical, {
        ring2="Ifrit Ring"
    })

    sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical, {
        ear1="Odr Earring",
        head="Malignance Chapeau",
        legs="Samnuha Tights"
    })

    sets.midcast['Blue Magic'].PhysicalVit = set_combine(sets.midcast['Blue Magic'].Physical, {})

    sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical, {})

    sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical, {})

    sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical, {})

    sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical, {})

    sets.midcast['Blue Magic'].PhysicalHP = set_combine(sets.midcast['Blue Magic'].Physical)


    -- Magical Spells --
    sets.midcast['Blue Magic'].Magical = {
	    ammo="Ghastly Tathlum",
		head="Jhakri Coronal +2",
		body="Amalric Doublet +1",
		hands="Amalric Gages +1",
		legs={ name="Luhlaza Shalwar +1", augments={'Enhances "Assimilation" effect',}},
		feet={ name="Amalric Nails", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Conserve MP"+6',}},
		neck="Sanctity Necklace",
		waist="Salire Belt",
		left_ear="Friomisi Earring",
		right_ear="Novio Earring",
		left_ring="Shiva Ring",
		right_ring="Shiva Ring",
		back="Izdubar Mantle",    }

    sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical, {
        neck="Mirage Stole +1",
    })
    
    sets.midcast['Blue Magic'].MagicalLight = set_combine(sets.midcast['Blue Magic'].Magical, {
        ring1="Weatherspoon Ring"
    })
    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical, {})

    sets.midcast['Blue Magic'].MagicalAgi = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Malignance Chapeau",

        ring1="Rajas Ring",
        ring2="Ilabrat Ring",

    })

    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical)

    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical, {})

    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Malignance Chapeau",
        ring1="Ilabrat Ring"
    })

    sets.midcast['Blue Magic'].MagicAccuracy = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Malignance Chapeau",
        neck="Mirage Stole +1",
        back="Aput Mantle",
        ring1="Weatherspoon Ring",
        ring2="Crepuscular Ring",
        legs="Malignance Tights", 
    })

    -- Breath Spells --
    
    sets.midcast['Blue Magic'].Breath = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {
        ammo="Mavi Tathlum",
        -- head="Luhlaza Keffiyeh",
        neck="Mirage Stole +1",
        -- ear1="Lifestorm Earring",
        -- ear2="Psystorm Earring",
        -- body="Vanir Cotehardie",
        -- hands="Assimilator's Bazubands +1",
        -- ring1="K'ayres Ring",
        -- ring2="Beeline Ring",
        -- back="Refraction Cape",
        waist="Glassblower's Belt",
        -- legs="Enif Cosciales",
        feet="Malignance Boots"
    })

    -- Other Types --
    
    sets.midcast['Blue Magic'].Stun = set_combine(sets.midcast['Blue Magic'].MagicAccuracy,
        {waist="Chaac Belt"})
        
    sets.midcast['Blue Magic']['Tenebral Crush'] = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Pixie Hairpin +1"
     })

    sets.midcast['Blue Magic'].Healing = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {
        ammo="Staunch Tathlum",
        ear1="Mendicant's Earring",
        hands="Telchine Gloves"
    })

    sets.midcast['Blue Magic'].SkillBasedBuff = {
        ammo="Mavi Tathlum",
        -- head="Mirage Keffiyeh",
        neck="Mirage Stole +1",
        body="Assimilator's Jubbah +1",
        back="Cornflower Cape",
        -- legs="Mavi Tayt +2",
        feet="Luhlaza Charuqs"
    }

    sets.midcast.Refresh = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {
        head="Amalric Coif"
    })
	
    sets.midcast['Blue Magic'].Buff = {
		ammo="Mavi Tathlum",
		head={ name="Luh. Keffiyeh +2", augments={'Enhances "Convergence" effect',}},
		body="Assim. Jubbah +1",
		legs="Hashishin Tayt +1",
		feet={ name="Luhlaza Charuqs +2", augments={'Enhances "Diffusion" effect',}},
		neck="Mirage Stole +1",
		right_ear="Njordr Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Cornflower Cape", augments={'MP+15','DEX+2','Accuracy+3','Blue Magic skill +10',}},
    }
    sets.midcast['Blue Magic']['Battery Charge'] = set_combine(sets.midcast['Blue Magic'].Buff, {
        head="Amalric Coif"
    })
    sets.midcast['Blue Magic']['Diamondhide'] = set_combine(sets.midcast['Blue Magic'].Buff, {
        waist="Siegel Sash",
    })
    sets.midcast.Aquaveil = sets.midcast['Blue Magic']['Battery Charge']
    
    -- sets.midcast.Protect = {ring1="Sheltered Ring"}
    -- sets.midcast.Protectra = {ring1="Sheltered Ring"}
    -- sets.midcast.Shell = {ring1="Sheltered Ring"}
    -- sets.midcast.Shellra = {ring1="Sheltered Ring"}

    -- Sets to return to when not performing an action.

    -- Gear for learning spells: +skill and AF hands.
    sets.Learning = {
	    ammo="Mavi Tathlum",
		head={ name="Luh. Keffiyeh +2", augments={'Enhances "Convergence" effect',}},
		body="Assim. Jubbah +1",
		hands="Assim. Bazu. +1",
		legs="Hashishin Tayt +1",
		feet={ name="Luhlaza Charuqs +2", augments={'Enhances "Diffusion" effect',}},
		neck="Mirage Stole +1",
		left_ear="Njordr Earring",
		right_ear="Influx Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Cornflower Cape", augments={'MP+15','DEX+2','Accuracy+3','Blue Magic skill +10',}},}
    
        --head="Luhlaza Keffiyeh",  
        --body="Assimilator's Jubbah",hands="Assimilator's Bazubands +1",
        --back="Cornflower Cape",legs="Mavi Tayt +2",feet="Luhlaza Charuqs"}


    sets.latent_refresh = {
	    body="Jhakri Robe +2",
		hands="Serpentes Cuffs",
		legs={ name="Lengo Pants", augments={'INT+7','Mag. Acc.+7','"Mag.Atk.Bns."+3','"Refresh"+1',}},
		waist="Fucho-no-Obi",
		left_ear={ name="Moonshade Earring", augments={'MP+25','Latent effect: "Refresh"+1',}},
		right_ear="Ethereal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",    }

    -- Resting sets
    sets.resting = {
        ammo="Staunch Tathlum",
        neck="Sanctity Necklace",
        body="Shamash Robe",
        ring1="Defending Ring",
        ring2="Paguroidea Ring",
        waist="Flume Belt",
        back="Kumbira Cape",
        feet="Malignance Boots"
    }
    
    -- Idle sets
    sets.idle = {
		ammo="Staunch Tathlum",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs="Carmine Cuisses",
		feet="Aya. Gambieras +2",
		neck="Twilight Torque",
		waist="Flume Belt",
		left_ear="Etiolation Earring",
		right_ear="Ethereal Earring",
		left_ring="Karieyh Ring",
		right_ring="Defending Ring",
		back="Solemnity Cape",
    }


    sets.idle.Learning = set_combine(sets.idle, sets.Learning)

    sets.idle.Refresh = set_combine(sets.latent_refresh, {
    })
    
    -- Defense sets
    sets.defense.PDT = { }

    sets.defense.MDT = {}

    sets.Kiting = {legs="Carmine Cuisses"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {
		ammo="Hasty Pinion +1",
		head={ name="Adhemar Bonnet", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}},
		body={ name="Adhemar Jacket", augments={'STR+10','DEX+10','Attack+15',}},
		hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
		legs="Aya. Cosciales +2",
		feet={ name="Herculean Boots", augments={'"Triple Atk."+1','"Dual Wield"+2','"Store TP"+5','Mag. Acc.+17 "Mag.Atk.Bns."+17',}},
		neck="Clotharius Torque",
		waist="Twilight Belt",
		left_ear="Eabani Earring",
		right_ear="Suppanomimi",
		left_ring="Hetairoi Ring",
		right_ring="Epona's Ring",
		back="Bleating Mantle",    }

    sets.engaged.Mid = set_combine(sets.engaged, {
        head="Adhemar Bonnet +1",
        --legs=HercLegs.TP,
        neck="Mirage Stole +1",
    })

    sets.engaged.Acc = set_combine(sets.engaged.Mid, {
        ear1="Telos Earring",
        waist="Olseni Belt",
        ring1="Cacoethic Ring +1",
        legs="Malignance Tights", 
    })

    sets.engaged.PDT = set_combine(sets.engaged, {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard", 
        feet="Nyame Sollerets",
        neck="Twilight Torque",
        ring1="Defending Ring",
    })
	
    sets.engaged.EVA = set_combine(sets.engaged, {
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights", 
        feet="Malignance Boots",
        neck="Twilight Torque",
        ring1="Defending Ring",
    })
	
    sets.engaged.Mid.PDT = set_combine(sets.engaged.Mid, {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard", 
        feet="Nyame Sollerets",
        neck="Twilight Torque",
        ring1="Defending Ring",
        ring2="Patricius Ring",
    })
	
    sets.engaged.Mid.EVA = set_combine(sets.engaged.Mid, {
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights", 
        feet="Malignance Boots",
        neck="Twilight Torque",
        ring1="Defending Ring",
        ring2="Patricius Ring",
    })
	
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Mid.PDT, {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard", 
        feet="Nyame Sollerets",
        ring1="Defending Ring",
    })
	
    sets.engaged.Acc.EVA = set_combine(sets.engaged.Mid.EVA, {
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights", 
        feet="Malignance Boots",
        ring1="Defending Ring",
    })

    sets.engaged.Learning = set_combine(sets.engaged, sets.Learning)

    sets.engaged.MaxHaste = { ammo="Focal Orb",
		head={ name="Adhemar Bonnet", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}},
		body="Ayanmo Corazza +2",
		hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
		legs={ name="Herculean Trousers", augments={'Crit.hit rate+2','STR+7','Weapon skill damage +5%','Accuracy+18 Attack+18',}},
		feet={ name="Herculean Boots", augments={'"Triple Atk."+1','"Dual Wield"+2','"Store TP"+5','Mag. Acc.+17 "Mag.Atk.Bns."+17',}},
		neck="Clotharius Torque",
		waist="Windbuffet Belt +1",
		left_ear="Brutal Earring",
		right_ear="Telos Earring",
		left_ring="Epona's Ring",
		right_ring="Hetairoi Ring",
		back="Bleating Mantle"}
		
    sets.engaged.Learning = set_combine(sets.engaged, sets.Learning)
	
	sets.engaged.TH	= set_combine(sets.engaged,{ammo="Perfect lucky egg", head="White Rarab Cap +1",
		waist="Chaac Belt",})

	sets.dps = {main="Naegling", sub="Almace"}
	
	sets.dps.matt = {
		main={ name="Colada", augments={'DEX+2','Mag. Acc.+7 "Mag.Atk.Bns."+7','"Treasure Hunter"+1',}},
		sub={ name="Colada", augments={'Mag. Acc.+4 "Mag.Atk.Bns."+4','MND+7','"Mag.Atk.Bns."+20','DMG:+10',}},}
		
	sets.matt = {main="nibiru cudgel", sub="nibiru cudgel"}
	sets.TH = {main="almace", sub={ name="Colada", augments={'DEX+2','Mag. Acc.+7 "Mag.Atk.Bns."+7','"Treasure Hunter"+1',},}}

    sets.self_healing = {ring1="Kunaji Ring",ring2="Asklepian Ring"}	
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if unbridled_spells:contains(spell.english) and not state.Buff['Unbridled Learning'] then
        eventArgs.cancel = true
        windower.send_command('@input /ja "Unbridled Learning" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
    end
    if spell.name == 'Spectral Jig' and buffactive.sneak then
        -- If sneak is active when using, cancel before completion
        send_command('cancel 71')
    end
    if string.find(spell.english, 'Utsusemi') then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4)'] then
            cancel_spell()
            eventArgs.cancel = true
            return
        end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Add enhancement gear for Chain Affinity, etc.
    if spell.skill == 'Blue Magic' then
        for buff,active in pairs(state.Buff) do
            if active and sets.buff[buff] then
                equip(sets.buff[buff])
            end
        end
        if spellMap == 'Healing' and spell.target.type == 'SELF' and sets.self_healing then
            equip(sets.self_healing)
        end
    end

    -- If in learning mode, keep on gear intended to help with that, regardless of action.
    if state.OffenseMode.value == 'Learning' then
        equip(sets.Learning)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        state.Buff[buff] = gain
    end
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
        determine_haste_group()
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
	
    if buff:startswith('Aftermath') then
        if player.equipment.main == 'Tizona' then
            classes.CustomMeleeGroups:clear()

            if (buff == "Aftermath: Lv.3" and gain) or buffactive['Aftermath: Lv.3'] then
                classes.CustomMeleeGroups:append('AM3')
                add_to_chat(8, '-------------AM3 UP-------------')
            end

            if not midaction() then
                handle_equipping_gear(player.status)
            end
        end
    end

end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 91 then
		set_combine{sets.idle, sets.latent_refresh}
    end
	
    return idleSet
end


function determine_haste_group()

    classes.CustomMeleeGroups:clear()
    -- mythic AM	
    if player.equipment.main == 'Tizona' then
        if buffactive['Aftermath: Lv.3'] then
            classes.CustomMeleeGroups:append('AM3')
        end
    end
    -- assuming +4 for marches (ghorn has +5)
    -- Haste (white magic) 15%
    -- Haste Samba (Sub) 5%    -- Haste (Merited DNC) 10% (never account for this)
    -- Victory March +0/+3/+4/+5    9.4/14%/15.6%/17.1% +0
    -- Advancing March +0/+3/+4/+5  6.3/10.9%/12.5%/14%  +0
    -- Embrava 30% with 500 enhancing skill
    -- Mighty Guard - 15%
    -- buffactive[580] = geo haste
    -- buffactive[33] = regular haste
    -- buffactive[604] = mighty guard
    -- state.HasteMode = toggle for when you know Haste II is being cast on you
    -- Hi = Haste II is being cast. This is clunky to use when both haste II and haste I are being cast
    if ( ( (buffactive[33] or buffactive[580] or buffactive.embrava) and (buffactive.march or buffactive[604]) ) or
            ( buffactive[33] and (buffactive[580] or buffactive.embrava) ) or
            ( buffactive.march == 2 and buffactive[604] ) ) then
        add_to_chat(8, '-------------Max-Haste Mode Enabled--------------')
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif ( (buffactive[33] or buffactive.march == 2 or buffactive[580]) and buffactive['haste samba'] ) then
        add_to_chat(8, '-------------Haste 35%-------------')
        classes.CustomMeleeGroups:append('Haste_35')
    elseif ( ( buffactive[580] or buffactive[33] or buffactive.march == 2 ) or
                ( buffactive.march == 1 and buffactive[604] ) ) then
        add_to_chat(8, '-------------Haste 30%-------------')
        classes.CustomMeleeGroups:append('Haste_30')
    elseif ( buffactive.march == 1 or buffactive[604] ) then
        add_to_chat(8, '-------------Haste 15%-------------')
        classes.CustomMeleeGroups:append('Haste_15')
    end

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'None' then
            enable('main','sub','range')
        else
            disable('main','sub','range')
        end

	elseif stateField == 'Weapon Mode' then
        if newValue == 'DPS' then
            equip(sets.dps)
        elseif newValue == 'SwordMA' then
            equip(sets.dps.matt)
		elseif newValue == 'ClubMA' then
			equip(sets.matt)
		elseif newValue == 'TH' then
			equip(sets.TH)	
        end
    end

end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
function display_current_job_state(eventArgs)
    local msg = ''
    msg = msg .. 'WEAPONMODE: '..state.WeaponMode.current
    add_to_chat(122, msg)
    eventArgs.handled = true
end

function update_combat_form()
    --Check for H2H or single-wielding
    if player.equipment.sub == "Genbu's Shield" or player.equipment.sub == 'empty' then
        state.CombatForm:reset()
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 7)
    else
        set_macro_page(1, 16)
    end
end


