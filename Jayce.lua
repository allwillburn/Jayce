local ver = "0.01"

if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end

if GetObjectName(GetMyHero()) ~= "Jayce" then return end

require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Jayce/master/Jayce.lua', SCRIPT_PATH .. 'Jayce.lua', function() PrintChat('<font color = "#00FFFF">Jayce Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No Jayce updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Jayce/master/Jayce.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local JayceMenu = Menu("Jayce", "Jayce")

JayceMenu:SubMenu("Combo", "Combo")

JayceMenu.Combo:Boolean("Q", "Use Q in combo", true)
JayceMenu.Combo:Boolean("W", "Use W in combo", true)
JayceMenu.Combo:Boolean("E", "Use E in combo", true)
JayceMenu.Combo:Boolean("R", "Use R in combo", true)
JayceMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
JayceMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
JayceMenu.Combo:Boolean("RHydra", "Use RHydra", true)
JayceMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
JayceMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)

JayceMenu:SubMenu("AutoMode", "AutoMode")
JayceMenu.AutoMode:Boolean("Level", "Auto level spells", false)
JayceMenu.AutoMode:Boolean("Q", "Auto Q", false)
JayceMenu.AutoMode:Boolean("W", "Auto W", false)
JayceMenu.AutoMode:Boolean("E", "Auto E", false)

JayceMenu:SubMenu("LaneClear", "LaneClear")
JayceMenu.LaneClear:Boolean("Q", "Use Q", true)
JayceMenu.LaneClear:Boolean("W", "Use W", true)
JayceMenu.LaneClear:Boolean("E", "Use E", true)
JayceMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
JayceMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

JayceMenu:SubMenu("Harass", "Harass")
JayceMenu.Harass:Boolean("Q", "Use Q", true)
JayceMenu.Harass:Boolean("E", "Use E", true)

JayceMenu:SubMenu("KillSteal", "KillSteal")
JayceMenu.KillSteal:Boolean("Q", "KS w Q", true)
JayceMenu.KillSteal:Boolean("E", "KS w E", true)


JayceMenu:SubMenu("AutoIgnite", "AutoIgnite")
JayceMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

JayceMenu:SubMenu("Drawings", "Drawings")
JayceMenu.Drawings:Boolean("DQ", "Draw Q Range", true)
JayceMenu.Drawings:Boolean("DE", "Draw E Range", true)


JayceMenu:SubMenu("SkinChanger", "SkinChanger")
JayceMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
JayceMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)

	--AUTO LEVEL UP
	if JayceMenu.AutoMode.Level:Value() then

			spellorder = {_Q, _E, _W, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
                if Mix:Mode() == "Harass" then
            if JayceMenu.Harass.E:Value() and Ready(_E) and ValidTarget(target, 1200) then           
			CastSkillShot(_E, target.pos) 
            end
            
            if JayceMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1200) then
                        CastSkillShot(_Q, target.pos) 
            end
              
           end

	--COMBO
		if Mix:Mode() == "Combo" then
            if Mix:Mode() == "Combo" then
            if JayceMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if JayceMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 700) then
			CastTargetSpell(target, BOTRK)
            end

            if JayceMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if JayceMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if JayceMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

            if JayceMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 600) then 
                        CastTargetSpell(target, _Q)                                                       
            end

            if JayceMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 240) then			
                        CastTargetSpell(target, _E)
            end
           
            if JayceMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 1050) then           
			CastSkillShot(_E, target.pos) 
            end

            if JayceMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 600) then 
                        CastTargetSpell(target, _Q)                                                       
            end

            if JayceMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1050) then
                        CastSkillShot(_Q, target.pos) 
            end
                        
	    if JayceMenu.Combo.W:Value() and Ready(_W) then
			CastSpell(_W)
	    end

            if JayceMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 240) then			
                        CastTargetSpell(target, _E)
            end
	    
            if JayceMenu.Combo.R:Value() and ValidTarget(target, 600) then
			CastSpell(_R)
            end 

            if JayceMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 600) then 
                        CastTargetSpell(target, _Q)                                                       
            end
           
            
                              
        end 
      

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_E) and ValidTarget(enemy, 1050) and JayceMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSkillShot(_E, target.pos)
                end 

                if IsReady(_Q) and ValidTarget(enemy, 1050) and JayceMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		                      CastSkillShot(_Q, target.pos)  
                end
                  
                if IsReady(_Q) and ValidTarget(enemy, 600) and JayceMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		                      CastTargetSpell(target, _Q)
  
                end
                
                if IsReady(_E) and ValidTarget(enemy, 240) and JayceMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastTargetSpell(target, _E)
                end 
                
      end

      if Mix:Mode() == "LaneClear" then          
      	  for _,closeminion in pairs(minionManager.objects) do           
             if JayceMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 600) then 
                        CastTargetSpell(_Q,closeminion.pos)                                                      
             end

             if JayceMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 1050) then 
                        CastSkillShot(_Q,closeminion.pos)                                                      
             end
          end
      end

        --AutoMode
        if JayceMenu.AutoMode.Q:Value() then        
          if Ready(_E) and ValidTarget(target, 1000) then
		      CastSkillShot(_E, target.pos) 
          end
        end 
        if JayceMenu.AutoMode.W:Value() then        
          if Ready(_Q) and ValidTarget(target, 1000) then
	  	      CastSkillShot(_Q, target.pos)
          end
        end
        if JayceMenu.AutoMode.W:Value() then        
	  if Ready(_E) and ValidTarget(target, 1000) then
		      CastSpell(_W)
	  end
        end
        
                
	
     end
end)

OnDraw(function (myHero)
        
         if JayceMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 1050, 0, 200, GoS.Black)
	 end

         if JayceMenu.Drawings.DE:Value() then
		DrawCircle(GetOrigin(myHero), 650, 0, 150, GoS.Black)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()

        if unit.isMe and spell.name:lower():find("jaycehypercharge") then 
		Mix:ResetAA()	
	end        

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	

end) 


local function SkinChanger()
	if JayceMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Jayce</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')


