
--[[

    Beta MC Heimer v0.29
    
    v0.26 -  release
    
    v0.28 - Improved Combo Logic
          - Added Harass Button
          - Little finetune on the dodge Logic
          - Fixed bug with cast spells
          - Option on the Menu to enable or disable minion collision on W (enable as default)
    
    v0.29 - Improved Combo Logic
          - Added Auto Killsteal
          - Added Draw damage after combo (not working as expected)
    
    v0.29a - Open Source Code
    
--]]

if myHero.charName ~= "Heimerdinger" then return end

require 'VPrediction'
require 'SOW'
require 'SourceLib'
require 'FTER_SOW'
require 'Prodiction'

local version = "0.29"

Champions = {
	["Blitzcrank"] = {charName = "Blitzcrank", skillshots = {
       ["RocketGrabMissile"] = {name = "(Q) Rocket Grab", spellName = "RocketGrabMissile", castDelay = 250, projectileSpeed = 1800, range = 1050, radius = 70, blockable = true, interrupt = false}
    }},
	["Brand"] = {charName = "Brand", skillshots = {
        ["BrandBlaze"] = {name = "(Q) Sear", spellName = "BrandBlaze", castDelay = 250, projectileSpeed = 1600, range = 1100, radius = 80, blockable = true, interrupt = false},
    }},
	["Caitlyn"] = {charName = "Caitlyn", skillshots = {
        ["CaitlynEntrapment"] = {name = "(E) Caitlyn Entrapment", spellName = "CaitlynEntrapment", castDelay = 150, projectileSpeed = 2000, range = 950, radius = 80, blockable = true, interrupt = false},
        ["CaitlynHeadshotMissile"] = {name = "(R) Ace in the Hole", spellName = "CaitlynHeadshotMissile", range = 3000, blockable = false, interrupt = true},
    }},
	["Corki"] = {charName = "Corki", skillshots = {
        ["MissileBarrage"] = {name = "(R) Missile Barrage", spellName = "MissileBarrage", castDelay = 250, projectileSpeed = 2000, range = 1300, radius = 40, blockable = true, interrupt = false},
    }},
	["DrMundo"] = {charName = "DrMundo", skillshots = {
        ["InfectedCleaverMissile"] = {name = "(Q) Infected Cleaver", spellName = "InfectedCleaverMissile", castDelay = 250, projectileSpeed = 2000, range = 1050, radius = 75, blockable = true, interrupt = false},
    }},
	["Elise"] = {charName = "Elise", skillshots = {
        ["EliseHumanE"] = {name = "(E) Cocoon", spellName = "EliseHumanE", castDelay = 250, projectileName = "Elise_human_E_mis.troy", projectileSpeed = 1450, range = 1100, radius = 70, blockable = true, interrupt = false}
    }},
	["Ezreal"] = {charName = "Ezreal", skillshots = {
        ["EzrealMysticShot"] = {name = "(Q) Mystic Shot", spellName = "EzrealMysticShot", castDelay = 250, projectileName = "Ezreal_mysticshot_mis.troy",  projectileSpeed = 2000, range = 1200,  radius = 80,  blockable = true, interrupt = false},
        ["EzrealMysticShotPulse"] = {name = "(Q) Mystic Shot", spellName = "EzrealMysticShotPulse", castDelay = 250, projectileName = "Ezreal_mysticshot_mis.troy",  projectileSpeed = 2000, range = 1200,  radius = 80,  blockable = true, interrupt = false},
    }},
	["FiddleSticks"] = {charName = "FiddleSticks", skillshots = {
        ["DrainChannel"] = {name = "(W) Drain", spellName="DrainChannel", blockable = false, interrupt = true, range=575},
		["Crowstorm"] = {name = "(R) Crowstorm", spellName="Crowstorm", blockable = false, interrupt = true, range=800},
   }},   
	["Galio"] = {charName = "Galio", skillshots = {
        ["GalioIdolOfDurand"] =  {name = "(R) Idol of Durand", spellName = "GalioIdolOfDurand", castDelay = 500, projectileSpeed = 850, range = 560, radius = 560, blockable = false, interrupt = true},
    }},
	["Jinx"] = {charName = "Jinx", skillshots = {
        ["JinxWMissile"] =  {name = "(W) Zap!", spellName = "JinxWMissile", castDelay = 600, projectileSpeed = 3300, range = 1450, radius = 70, blockable = false, interrupt = false},
    }},
	["Karma"] = {charName = "Karma", skillshots = {
        ["KarmaQ"] = {name = "(Q) Inner Flame/Soulflare", spellName = "KarmaQ", castDelay = 250, projectileSpeed = 1700, range = 1050, radius = 90, blockable = true, interrupt = false},
    }},
	["Karthus"] = {charName = "Karthus", skillshots = {
        ["FallenOne"] = {name = "(R) Requiem", spellName = "FallenOne", range = 550, blockable = false, interrupt = true},
    }},
	["Katarina"] = {charName = "Katarina", skillshots = {
        ["KatarinaR"] = {name = "(R) Death Lotus", spellName = "KatarinaR", range = 550, blockable = true, interrupt = true},
    }},
	["Kennen"] = {charName = "Kennen", skillshots = {
        ["KennenShurikenHurlMissile1"] = {name = "(Q) Thundering Shuriken", spellName = "KennenShurikenHurlMissile1", castDelay = 180, projectileSpeed = 1700, range = 1050, radius = 50, blockable = true, interrupt = false}
    }},
	 ["Khazix"] = {charName = "Khazix", skillshots = {
        ["KhazixW"] = {name = "(W) Void Spike", spellName = "KhazixW", castDelay = 250, projectileSpeed = 1700, range = 1025, radius = 70, blockable = true, interrupt = false},
    }},
	["LeeSin"] = {charName = "LeeSin", skillshots = {
        ["BlindMonkQOne"] = {name = "(Q) Sonic Wave", spellName = "BlindMonkQOne", castDelay = 250, projectileSpeed = 1800, range = 1100, radius = 60+10, blockable = true, interrupt = false}
    }},
	["Lucian"] = {charName = "Lucian", skillshots = {
        ["LucianW"] =  {name = "(W) Ardent Blaze", spellName = "LucianW", castDelay = 300, projectileSpeed = 1600, range = 1000, radius = 80, blockable = true, interrupt = false},
    }},
	["Malzahar"] = {charName = "Malzahar", skillshots = {
        ["AlZaharNetherGrasp"] = {name = "(R) Nether Grasp", spellName = "AlZaharNetherGrasp", castDelay = 500, projectileSpeed = math.huge, range = 700, blockable = false, interrupt = true}
    }},
	["MissFortune"] = {charName = "MissFortune", skillshots = {
        ["MissFortuneBulletTime"] = {name = "(R) Bullet Time", spellName = "MissFortuneBulletTime", castDelay = 500, projectileSpeed = math.huge, range = 1400, blockable = false, interrupt = true}
    }},
	["Morgana"] = {charName = "Morgana", skillshots = {
        ["DarkBindingMissile"] = {name = "(Q) Dark Binding", spellName = "DarkBindingMissile", castDelay = 250, projectileSpeed = 1200, range = 1300, radius = 80, blockable = true, interrupt = false},
	}},
	["Nautilus"] = {charName = "Nautilus", skillshots = {
        ["NautilusAnchorDrag"] = {name = "(Q) Dredge Line", spellName = "NautilusAnchorDrag", castDelay = 250, projectileSpeed = 2000, range = 1080, radius = 80, blockable = true, interrupt = false},
    }},
	["Nidalee"] = {charName = "Nidalee", skillshots = {
        ["JavelinToss"] = {name = "(Q) Javelin Toss", spellName = "JavelinToss", castDelay = 125, projectileSpeed = 1300, range = 1500, radius = 60, blockable = true, interrupt = false}
    }},
	["Nunu"] = {charName = "Nunu", skillshots = {
        ["AbsoluteZero"] = {name = "(R) AbsoluteZero", spellName = "AbsoluteZero", castDelay = 500, projectileSpeed = math.huge, range = 650, blockable = false, interrupt = true}
    }},
	["Quinn"] = {charName = "Quinn", skillshots = {
        ["QuinnQ"] = {name = "(Q) Blinding Assault", spellName = "QuinnQ", castDelay = 250, projectileSpeed = 1550, range = 1050, radius = 80, blockable = true, interrupt = false}
    }},
	["Sivir"] = {charName = "Sivir", skillshots = {
        ["SivirQ"] = {name = "(Q) Boomerang Blade", spellName = "SivirQ", castDelay = 250, projectileSpeed = 1350, range = 1175, radius = 101, blockable = true, interrupt = false},
    }},
	["Thresh"] = {charName = "Thresh", skillshots = {
        ["ThreshQ"] = {name = "(Q) Death Sentence", spellName = "ThreshQ", castDelay = 500, projectileSpeed = 1900, range = 1100, radius = 65, blockable = true, interrupt = false}
    }},
	["Warwick"] = {charName = "Warwick", skillshots = {
        ["InfiniteDuress"] = {name = "(R) Infinite Duress", spellName = "InfiniteDuress", castDelay = 500, projectileSpeed = math.huge, range = 700, blockable = false, interrupt = true}
    }},
 }
 
 local Qrange, Qwidth, Qspeed, Qdelay = 450, 0, math.huge, 0.5
 local Wrange, Wwidth, Wspeed, Wdelay = 1350, 200, 902, 0.5
 local Erange, Ewidth, Espeed, Edelay = 925, 120, 2500, 0.5
 local ts = {}
 local Config = {}
 local Col = nil
 local LastCastedSpell = {}
 local lastSkin = 0
 local RActivated = false
 local MainCombo = {_E, _W, Q, R}
  
 function OnLoad()  
VP = VPrediction()
ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 970, MAGIC_DAMAGE)
DLib = DamageLib()
DManager = DrawManager()
 
HeimerConfig = scriptConfig("MC Heimer", "MC Heimer")

  HeimerConfig:addTS(ts)
    ts.name = "Heimerdinger"

  HeimerConfig:addSubMenu("Orbwalk", "Orbwalk")
	
  HeimerConfig.Orbwalk:addParam("orbmode", "Orbwalk (Require Reload)", SCRIPT_PARAM_LIST, 2, { "FTER_SOW", "SOW" })
		if HeimerConfig.Orbwalk.orbmode == 1 then
			Orbwalker = FTER_SOW(VP)
		end
		if HeimerConfig.Orbwalk.orbmode == 2 then
			Orbwalker = SOW(VP)
		end
      
  Orbwalker:LoadToMenu(HeimerConfig.Orbwalk)
  
  HeimerConfig:addSubMenu("Spells", "cspells")
    
    HeimerConfig.cspells:addSubMenu("Q - Turret", "Q")
      HeimerConfig.cspells.Q:addParam("Qcombo", "Combo Mode", SCRIPT_PARAM_ONOFF, true)
      HeimerConfig.cspells.Q:addParam("Qharass", "Harass Mode", SCRIPT_PARAM_ONOFF, false)
      --HeimerConfig.cspells.Q:addParam("Qult", "R + Q", SCRIPT_PARAM_ONOFF, true)
      
    HeimerConfig.cspells:addSubMenu("W - Rocket", "W")
      HeimerConfig.cspells.W:addParam("Wcombo", "Combo Mode", SCRIPT_PARAM_ONOFF, true)
      HeimerConfig.cspells.W:addParam("Wcheck", "Check for minion Collision", SCRIPT_PARAM_ONOFF, false)
      HeimerConfig.cspells.W:addParam("Wharass", "Harass Mode", SCRIPT_PARAM_ONOFF, true)
      HeimerConfig.cspells.W:addParam("Whitc", "Hitchance",  SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
  
  
    HeimerConfig.cspells:addSubMenu("E - Grenade", "E")
      HeimerConfig.cspells.E:addParam("Ecombo", "Combo Mode", SCRIPT_PARAM_ONOFF, true)
      HeimerConfig.cspells.E:addParam("Eharass", "Harass Mode", SCRIPT_PARAM_ONOFF, true)
      --HeimerConfig.cspells.E:addParam("Eult", "R + E", SCRIPT_PARAM_ONOFF, true)
      HeimerConfig.cspells.E:addParam("Ehitc", "Hitchance",  SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
  
    HeimerConfig.cspells:addSubMenu("R - Upgrade", "R")
      HeimerConfig.cspells.R:addParam("Rcombo", "Combo Mode", SCRIPT_PARAM_ONOFF, true)
      HeimerConfig.cspells.R:addParam("Rharass", "Harass Mode", SCRIPT_PARAM_ONOFF, false)
      
  HeimerConfig:addSubMenu("Auto-Interrupt", "AutoInterrupt")
    HeimerConfig.AutoInterrupt:addParam("autoE", "Auto Granade (E)", SCRIPT_PARAM_ONOFF, true)
    HeimerConfig.AutoInterrupt:addParam("info", " ", SCRIPT_PARAM_INFO, "  " )
 
    for i = 1, heroManager.iCount,1 do
        local hero = heroManager:getHero(i)
        if hero.team ~= player.team then
            if Champions[hero.charName] ~= nil then
                for index, skillshot in pairs(Champions[hero.charName].skillshots) do
                    if skillshot.interrupt == true then
                        HeimerConfig.AutoInterrupt:addParam(skillshot.spellName, hero.charName .. " - " .. skillshot.name, SCRIPT_PARAM_ONOFF, true)
                    end
                end
            end
        end
    end
    
  HeimerConfig:addSubMenu("Evade", "dodge")
    HeimerConfig.dodge:addParam("autoQ", "Auto Turret (Q)", SCRIPT_PARAM_ONOFF, true)
    HeimerConfig.dodge:addParam("info", " ", SCRIPT_PARAM_INFO, "  " )

	for i = 1, heroManager.iCount,1 do
        local hero = heroManager:getHero(i)
        if hero.team ~= player.team then
            if Champions[hero.charName] ~= nil then
                for index, skillshot in pairs(Champions[hero.charName].skillshots) do
                    if skillshot.blockable == true then
                        HeimerConfig.dodge:addParam(skillshot.spellName, hero.charName .. " - " .. skillshot.name, SCRIPT_PARAM_ONOFF, true)
                    end
                end
            end
        end
    end
    
  HeimerConfig:addSubMenu("Miscelanneous", "Misc")
		HeimerConfig.Misc:addParam("skin", "SkinHax by Shalzuth", SCRIPT_PARAM_LIST, 6, { "Alien Invader", "Blast Zone", "Piltover Customs", "Snowmerdinger", "Hazmat", "Classic Skin" })
  
  HeimerConfig:addSubMenu("Drawings", "draw")
    DManager:CreateCircle(myHero, Qrange, 1, {255, 255, 255, 255}):AddToMenu(HeimerConfig.draw, "Q range", true, true, true)
    DManager:CreateCircle(myHero, Wrange, 1, {255, 255, 255, 255}):AddToMenu(HeimerConfig.draw, "W range", true, true, true)
    DManager:CreateCircle(myHero, Erange, 1, {255, 255, 255, 255}):AddToMenu(HeimerConfig.draw, "E range", true, true, true)
    
  DLib:AddToMenu(HeimerConfig.draw, MainCombo)  
    
	HeimerConfig:addParam("mode", "Predictions", SCRIPT_PARAM_LIST, 2, { "VPrediction", "Prodiction" })
  
  HeimerConfig:addParam("combo", "Smart Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
  HeimerConfig:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, 67)
  
  print("<b><font color=\"#00F5FF\">MC Heimerdinger: (</font></b><font color=\"#00F5FF\">".. tostring(version)..")</font><font color=\"#FFFFFF\"> loaded!</font>")

end

function OnTick()
  ts:update()
  Checks()
  AutoInterrupt()
  DmgLib()
  KillSteal()
  
  
  if HeimerConfig.Misc.skin ~= lastSkin then
	lastSkin = HeimerConfig.Misc.skin
	GenModelPacket("Heimerdinger", HeimerConfig.Misc.skin)
	end
  
  if ts.target ~= nil and HeimerConfig.combo then
		Combo(ts.target)
	end
  
  if ts.target ~= nil and HeimerConfig.harass then
		Harass(ts.target)
	end
  
end

function CastQ(Target)
  
  -- Prodiction -- 
  
		if ts.target ~= nil and HeimerConfig.mode == 2 then
      if Qready and Rready then
        local pos, info = Prodiction.GetPrediction(ts.target, Qrange, Qspeed, Qdelay, Qwidth)
        if pos then
          CastSpell(_R, myHero.x, myHero.z)
          CastSpell(_Q, pos.x, pos.z)
        end
      end
      if Qready and not Rready then
        local pos, info = Prodiction.GetPrediction(ts.target, Qrange, Qspeed, Qdelay, Qwidth)
        if pos then
          CastSpell(_Q, pos.x, pos.z)
        end
      end
    end
    
  -- VPrediction --
    
    if ts.target ~= nil and HeimerConfig.mode == 1 then
      if Qready and Rready then
        local CastPosition, HitChance, Pos = VP:GetLineCastPosition(ts.target, Edelay, Ewidth, Erange, Espeed, myHero, false)
        if HitChance >= 2 and GetDistance(CastPosition) < Qrange then
          CastSpell(_R, myHero.x, myHero.z)
          CastSpell(_Q, CastPosition.x, CastPosition.z)
        end
      end
      if Qready and not Rready then
        local CastPosition, HitChance, Pos = VP:GetLineCastPosition(ts.target, Edelay, Ewidth, Erange, Espeed, myHero, false)
          if HitChance >= 2 and GetDistance(CastPosition) < Qrange then
            CastSpell(_Q, CastPosition.x, CastPosition.z)
          end
      end
    end
    
    
end
 
function CastW(Target)
 
 -- Prodiction --

	if ts.target ~= nil and HeimerConfig.mode == 2 then
      if HeimerConfig.cspells.W.Wcheck then
        local pos, info = Prodiction.GetPrediction(ts.target, Wrange, Wspeed, Wdelay, Wwidth) 
        if pos and not info.mCollision() then
          CastSpell(_W, pos.x, pos.z)
        end
      end
      
      if not HeimerConfig.cspells.W.Wcheck then
        local pos, info = Prodiction.GetPrediction(ts.target, Wrange, Wspeed, Wdelay, Wwidth)
        if pos then
          CastSpell(_W, pos.x, pos.z)
        end
      end
  end
	
  -- VPrediction -- 
  
	if ts.target ~= nil and HeimerConfig.mode == 1 then
		if Wready and HeimerConfig.cspells.W.Wcheck then
			local CastPosition, HitChance, Pos = VP:GetLineCastPosition(ts.target, Wdelay, Wwidth, Wrange, Wspeed, myHero, true)
			if HitChance >= HeimerConfig.cspells.W.Whitc and GetDistance(CastPosition) < Wrange then
				CastSpell(_W, CastPosition.x, CastPosition.z)
			end
		end
		if Wready and not HeimerConfig.cspells.W.Wcheck then
			local CastPosition, HitChance, Pos = VP:GetLineCastPosition(ts.target, Wdelay, Wwidth, Wrange, Wspeed, myHero, false)
			if HitChance >= HeimerConfig.cspells.W.Whitc and GetDistance(CastPosition) < Wrange then
         CastSpell(_W, CastPosition.x, CastPosition.z)
			end
		end
	end
	
end
 
function CastE(Target)
 
 -- Prodiction --
 
	if ts.target ~= nil and HeimerConfig.mode == 2 and Eready then
    local pos, info = Prodiction.GetPrediction(ts.target, Erange, Espeed, Edelay, Ewidth)
      if pos then
        CastSpell(_E, pos.x, pos.z)
      end
  end
	
  -- VPrediction --
  
 
  if Eready and ts.target ~= nil and HeimerConfig.mode == 1 then
			local CastPosition, HitChance, Pos = VP:GetCircularCastPosition(ts.target, Edelay, Ewidth, Erange, Espeed, myHero, false)
			if HitChance >= 2 and GetDistance(CastPosition) < Erange then
         CastSpell(_E, CastPosition.x, CastPosition.z)
			end
	end
	
end
 
 function CastR()
		CastSpell(_R, myHero.x, myHero.z)

end

 function Combo(Target)
  
  Resists = (100/(100 + ((Target.magicArmor * myHero.magicPenPercent) - myHero.magicPen)))
  
  if HeimerConfig.cspells.E.Ecombo and DistanceToHit(Target) < Erange then
		CastE(Target)
	end   
   
  if HeimerConfig.cspells.E.Ecombo and HeimerConfig.cspells.W.Wcombo and HeimerConfig.cspells.R.Rcombo and Wready then
    if DistanceToHit(Target) < Wrange and not Rready then
      CastW(Target)
    end
    if (RWdmg + Edmg)* Resists > Target.health and Eready and Rready then
    end
  end    
 
	if Qready and  HeimerConfig.cspells.Q.Qcombo and Rready and  HeimerConfig.cspells.R.Rcombo and myHero.mana >= Qmana + Rmana and DistanceToHit(Target) < Qrange then
		CastQ(Target)
    
	end
 
	if Qready and HeimerConfig.cspells.Q.Qcombo and not Rready and DistanceToHit(Target) < Qrange then
    CastQ(Target)
	end
	
end

function Harass(Target)
 
	if HeimerConfig.cspells.E.Eharass and DistanceToHit(Target) < Erange then
		CastE(Target)
	end
	
  if Wready and  HeimerConfig.cspells.W.Wharass and DistanceToHit(Target) < Wrange then
    CastW(Target)
   end
  
	if Qready and  HeimerConfig.cspells.Q.Qharass and Rready and  HeimerConfig.cspells.R.Rharass and DistanceToHit(Target) < Qrange then
		CastQ(Target)
	end
 
	if Qready and HeimerConfig.cspells.Q.Qharass and not Rready and DistanceToHit(Target) < Qrange then
		CastQ(Target)
	end
	
end

function KillSteal()
  Checks()
    
  local Enemies = GetEnemyHeroes()
    for i, enemy in pairs(Enemies) do
      if ValidTarget(enemy, 1000) and not enemy.dead and GetDistance(enemy) < 1000 then
        Resists = (100/(100 + ((enemy.magicArmor * myHero.magicPenPercent) - myHero.magicPen)))
        if Edmg > enemy.health and GetDistance(enemy) < Erange then
          CastE(enemy)
        elseif Wready and Rready and myHero.mana >= Wmana + Rmana then
          if RWdmg * Resists > enemy.health and GetDistance(enemy) < Wrange then
            if HeimerConfig.mode == 2 then
             local pos, info = Prodiction.GetPrediction(enemy, Wrange, Wspeed, Wdelay, Wwidth) 
              if pos and not info.mCollision() and info.hitchance >= 3 then
                CastSpell(_R, myHero.x, myHero.z)
                CastSpell(_W, pos.x, pos.z)
              end
            end
            if HeimerConfig.mode == 1 then
              local CastPosition, HitChance, Pos = VP:GetLineCastPosition(enemy, Wdelay, Wwidth, Wrange, Wspeed, myHero, true)
              if HitChance >= 3 and GetDistance(CastPosition) < Wrange then
                --print("W Ks VP c")
                CastSpell(_R, myHero.x, myHero.z)
                CastSpell(_W, CastPosition.x, CastPosition.z)
              end
            end
          end
          if RWdmgc * Resists > enemy.health and GetDistance(enemy) < Wrange then
            if HeimerConfig.mode == 2 then 
              local pos, info = Prodiction.GetPrediction(enemy, Wrange, Wspeed, Wdelay, Wwidth)
              if pos and info.hitchance >= 4 then
                CastSpell(_R, myHero.x, myHero.z)
                CastSpell(_W, pos.x, pos.z)
              end
            end
            if HeimerConfig.mode == 1 then
              local CastPosition, HitChance, Pos = VP:GetLineCastPosition(enemy, Wdelay, Wwidth, Wrange, Wspeed, myHero, false)
              if HitChance >= 4 and GetDistance(CastPosition) < Wrange then
                --print("W Ks VP")
                CastSpell(_R, myHero.x, myHero.z)
                CastSpell(_W, CastPosition.x, CastPosition.z)
              end
            end
          end
        end
      end
    end
    
end

function AutoInterrupt()
  
  if Eready then
		for i = 1, heroManager.iCount,1 do
			local hero = heroManager:getHero(i)
			if hero.team ~= player.team then
				if Champions[hero.charName] ~= nil then
					for index, spell in pairs(Champions[hero.charName].skillshots) do
						if HeimerConfig.AutoInterrupt[spell.spellName] and HeimerConfig.AutoInterrupt.autoE then
							for j, LastCast in pairs(LastCastedSpell) do
								if LastCast.name == spell.spellName:lower() and (os.clock() - LastCast.time) < 3 and GetDistance(LastCast.caster.visionPos, myHero.visionPos) < Erange and ValidTarget(LastCast.caster) then
								CastE(Target)
								break
								end
							end
						end
					end
				end
			end
		end
	end
  
end
 
function OnProcessSpell(unit,spell)

	if myHero.dead then return end

	local function VectorFrom3D(p)
		return Vector(p.x, p.z)
end

	if HeimerConfig.dodge.autoQ and Qready then
		if unit.team ~= player.team and string.find(spell.name, "Basic") == nil then
			if Champions[unit.charName] ~= nil then
				skillshot = Champions[unit.charName].skillshots[spell.name]
				if skillshot ~= nil and skillshot.blockable == true then
					range = skillshot.range
					if GetDistance(spell.endPos) <= 3000 and HeimerConfig.dodge[skillshot.spellName] then

						local startpos, endpos = VectorFrom3D(spell.startPos), VectorFrom3D(spell.endPos)

						local v1 = VectorFrom3D(myHero.visionPos)
						
						local v2 = VectorPointProjectionOnLineSegment(startpos, endpos, v1)
   
      
						if v2 ~= nil then
							
							if GetDistance(v1,v2) <= 200 then
							
							local dir = (v2-v1):normalized()
							
							local castpos = v1 + (startpos-v1):normalized() * 110
							CastSpell(_Q, castpos.x, castpos.y)
							
							end
						end
					end
				end
			end
		end
	end
	
	if unit.team ~= myHero.team and unit.type == myHero.type then
		LastCastedSpell[unit.networkID] = {name = spell.name:lower(), time = os.clock(), caster = unit}
	end

end  
 
function Checks()
    
  Qready = myHero:CanUseSpell(_Q) == READY
	Wready = myHero:CanUseSpell(_W) == READY
	Eready = myHero:CanUseSpell(_E) == READY
	Rready = myHero:CanUseSpell(_R) == READY
	Qmana = myHero:GetSpellData(_Q).mana
	Wmana = myHero:GetSpellData(_W).mana
	Emana = myHero:GetSpellData(_E).mana
	Rmana = myHero:GetSpellData(_R).mana
  
  Rlevel = GetSpellData(_R).level
  Elevel = GetSpellData(_E).level
  
  RWdmg = (320+(Rlevel*180))+(myHero.ap*1.85)
  RWdmgc = (90+(Rlevel*45))+(myHero.ap*0.45)
  Edmg = (20+(Elevel*40))+(myHero.ap*0.60)
  
end

function getHitBoxRadius(target)
	return GetDistance(target, target.minBBox)
end
-- BotHappy -- 
function DistanceToHit(Target)
	Distance = GetDistance(Target) - getHitBoxRadius(Target)/2
	return Distance
end
-- end --

function DmgLib()
  
  if Rready then
    DLib:RegisterDamageSource(_Q, _MAGIC, 148, 72, _MAGIC, _AP, 1.90, function() return (player:CanUseSpell(_Q) == READY) end)
    DLib:RegisterDamageSource(_W, _MAGIC, 60, 30, _MAGIC, _AP, 0.45, function() return (player:CanUseSpell(_W) == READY) end)
    DLib:RegisterDamageSource(_E, _MAGIC, 60, 40, _MAGIC, _AP, 0.60, function() return (player:CanUseSpell(_E) == READY) end)
    DLib:RegisterDamageSource(_R, _MAGIC, 250, 80, _MAGIC, _AP, 6.00, function() return (player:CanUseSpell(_E) == READY) end)
  else
    DLib:RegisterDamageSource(_Q, _MAGIC, 148, 72, _MAGIC, _AP, 1.55, function() return (player:CanUseSpell(_Q) == READY) end)
    DLib:RegisterDamageSource(_W, _MAGIC, 60, 30, _MAGIC, _AP, 0.45, function() return (player:CanUseSpell(_W) == READY) end)
    DLib:RegisterDamageSource(_E, _MAGIC, 60, 40, _MAGIC, _AP, 0.60, function() return (player:CanUseSpell(_E) == READY) end)
  end

end

function OnDraw()
		if ts.target ~= nil then
                local dist = getHitBoxRadius(ts.target)/2
                DrawCircle3D(myHero.x, myHero.y, myHero.z, 1175, 1, ARGB(0,0,0,0))
                if GetDistance(ts.target) - dist < 1175 then
                        DrawCircle3D(myHero.x, myHero.y, myHero.z, 1175, 1, ARGB(0,0,0,0))
                end
        end
end

function GenModelPacket(champ, skinId)
	p = CLoLPacket(0x97)
	p:EncodeF(myHero.networkID)
	p.pos = 1
	t1 = p:Decode1()
	t2 = p:Decode1()
	t3 = p:Decode1()
	t4 = p:Decode1()
	p:Encode1(t1)
	p:Encode1(t2)
	p:Encode1(t3)
	p:Encode1(bit32.band(t4,0xB))
	p:Encode1(1)--hardcode 1 bitfield
	p:Encode4(skinId)
	for i = 1, #champ do
		p:Encode1(string.byte(champ:sub(i,i)))
	end
	for i = #champ + 1, 64 do
		p:Encode1(0)
	end
	p:Hide()
	RecvPacket(p)
end
