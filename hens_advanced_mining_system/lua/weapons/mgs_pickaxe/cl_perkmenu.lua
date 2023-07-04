

--FONT REG

surface.CreateFont("perkFont", {
	font = "Arial",
	size = 32,
	weight = 500,
	antialias = true,
	shadow = false
} )

surface.CreateFont("perkFontLarge", {
	font = "Arial",
	size = 52,
	weight = 500,
	antialias = true,
	shadow = false
} )

surface.CreateFont("perkFontSmall", {
	font = "Arial",
	size = 19,
	weight = 500,
	antialias = true,
	shadow = false
} )

--FONT REG

surface.CreateFont("xpFont", {
	font = "Arial",
	size = 18,
	weight = 600,
	antialias = true,
	shadow = true
} )

surface.CreateFont("statFont", {
	font = "Arial",
	size = 22,
	weight = 1000,
	antialias = true,
	shadow = true
} )

include("sv_playerinfo.lua")

--INITIAL PANEL--
local PANEL = {}

function PANEL:Init()
	--Init look
	local width = 550
	local height = 750
	
	self:MakePopup()
	self:SetDeleteOnClose(true)
	self:Dock(FILL)
	self:Center()
	self:SetDraggable(false)
	self:SetTitle("")
	self:SetSize(width, height)
	self:Center()
	self:ShowCloseButton(false)
	--self:SetBackgroundBlur(true)
	
	--print("Popped up init menu!")
	
	self.Paint = function(self)
		draw.RoundedBox(10, (ScrW() / 2) - (width/2) , (ScrH() / 2) - (height/2), width, height, Color(0, 0, 0, 185))	
	end
	
	self.toppanel = vgui.Create("Pickaxe:TopFrame", self)
	
	self.perkpanel = vgui.Create("Pickaxe:PerkFrame", self)

end

vgui.Register("Pickaxe:Menu", PANEL, "DFrame")

--Prestige Button

local PANEL = {}

function PANEL:Init()
	self:SetPos(375, 30)
	self:SetSize(150, 65)
	self:SetText("")
	
	local plylvl = LocalPlayer():GetNWInt("level") or 0
	self.Paint = function(_, w, h)
		if(LocalPlayer():GetNWInt("level") ==35) then
			if not (self:IsDown()) then
				draw.RoundedBox(15, 0, 0, w, h, Color(109, 202, 255, 255))
			else
				draw.RoundedBox(15, 0, 0, w, h, Color(84, 153, 192, 255))
			end
		else
			draw.RoundedBox(15, 0, 0, w, h, Color(100, 100, 100, 255))
		end
	end
	
	if(plylvl ==35) then
		self:SetEnabled(true)
	else
		self:SetEnabled(false)
	end
	
	self.DoClick = function (self)
			local ply = LocalPlayer()
			plylvl = 0
			net.Start("pickaxePrestige")
			net.SendToServer()
			
			self:GetParent():GetParent():Close()
		end
	
	local Dlabel = vgui.Create( "DLabel", self )
	Dlabel:SetFont("perkFont")
	Dlabel:SetText("PRESTIGE")
	Dlabel:SizeToContents()
	Dlabel:Center()
	Dlabel:SetColor(Color(255,255,255))
	
end

vgui.Register("Pickaxe:Prestige", PANEL, "DButton")

-- Close Button

local PANEL = {}

function PANEL:Init()
	self:SetPos(512, 0)
	self:SetSize(16, 16)
	self:SetText("")
	self:SetImage("ui_close")
	
	self.DoClick = function (self)
			self:GetParent():GetParent():Close()
		end
end

vgui.Register("Pickaxe:CloseButton", PANEL, "DImageButton")



----------------
--Top frame--
----------------

local PANEL = {}

function PANEL:Init()

	--Init look
	local x,y = self:GetParent():GetSize()
	local posx,posy = self:GetParent():GetPos()
	local topframepad = 5
	
	self:SetSize(x - topframepad*2, y / 5)
	self:SetPos(posx + topframepad, posy + topframepad)
	
	self.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	--LABELS
	local Dlabel = vgui.Create( "DLabel", self )
	Dlabel:SetFont("perkFont")
	Dlabel:SetText("You have ")
	Dlabel:SizeToContents()
	Dlabel:SetPos(15, 30)
	Dlabel:SetColor(Color(255,255,255))
	
	surface.SetFont("perkFont")
	local textWidth = surface.GetTextSize("You have ")
	
	local Dlabel = vgui.Create( "DLabel", self )
	Dlabel:SetFont("perkFontLarge")
	Dlabel:SetText(LocalPlayer():GetNWInt("perkpts"))
	Dlabel:SizeToContents()
	Dlabel:SetPos((textWidth + 10), 15)
	Dlabel:SetColor(Color(109,202,255))
	
	surface.SetFont("perkFontLarge")
	textWidth = textWidth + surface.GetTextSize(LocalPlayer():GetNWInt("perkpts"))
	
	local Dlabel = vgui.Create( "DLabel", self )
	Dlabel:SetFont("perkFont")
	Dlabel:SetText(" perk points.")
	Dlabel:SizeToContents()
	Dlabel:SetPos(textWidth + 5, 30)
	Dlabel:SetColor(Color(255,255,255))
	
	local Drect = vgui.Create( "DShape", self)
	Drect:SetType("Rect")
	Drect:SetColor(Color(255, 255, 255))
	Drect:SetPos(0, 75)
	Drect:SetSize(350, 3)
	
	--END LABELS
	
	--BUTTON--
	
	self.prestigebutton = vgui.Create("Pickaxe:Prestige", self)
	
	local bposx, bposy = self.prestigebutton:GetPos()
	local Dlabel = vgui.Create( "DLabel", self )
	Dlabel:SetFont("Arial")
	Dlabel:SetText("Requires Level 35")
	Dlabel:SizeToContents()
	Dlabel:SetPos((bposx + 35), (bposy+70))
	Dlabel:SetColor(Color(255,255,255))
	
	self.closebtn = vgui.Create("Pickaxe:CloseButton", self)
	
	--END BUTTON--
end

vgui.Register("Pickaxe:TopFrame", PANEL, "DPanel")

-------------------
--PERK FRAME--
-------------------

local PANEL = {}

function PANEL:Init()
	--Init look
	local x,y = self:GetParent():GetSize()
	local posx,posy = self:GetParent():GetPos()
	local topframepad = 10
	
	self:SetSize(x - topframepad*2, y * 0.80)
	self:SetPos(posx + topframepad, posy + topframepad*13)
	self:SetVerticalScrollbarEnabled(true)
	
	self.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 180))
	end
	
	--Modify Scroll Bar--
	
	local sbar = self:GetVBar()
	sbar:SetHideButtons(true)
	
	sbar.Paint = function(_, w, h)
		draw.RoundedBox(10, 0, 0, (w/3), h, Color(0, 0, 0, 225))
	end
	
	sbar.btnGrip.Paint = function(_, w, h)
		draw.RoundedBox(10, 0, 0, (w/3), h, Color(255, 255, 255, 255))
	end
	
	
	------------------------
	
	--CREATE PERKS--
	for k, v in pairs(PERKS_TABLE) do
		
		if(PERK_HALLOWEEN_EVENT == false) and (v[2] == "perk_candy") then continue end
		--Does the player own the perk?
		local perkstate = false
		local perkstacks = 0
		
		if(isnumber(LocalPlayer():GetNWInt(v[2])) )then
			perkstacks = LocalPlayer():GetNWInt(v[2])
		end
		
		if(isbool(LocalPlayer():GetNWBool(v[2])) ) then
			perkstate = LocalPlayer():GetNWBool(v[2])
		end
		
		local costformula = (perkstacks * v[7]) + math.Round( (math.exp(0.5 * perkstacks) * v[7]), -4)
		
		--Panel container
		local Dpanel = vgui.Create( "DPanel", self )
		Dpanel:SetSize(0, 125)
		Dpanel:Dock(TOP)
		Dpanel:DockMargin( 15, 15, 10, 0 ) 
		Dpanel.Paint = function(_, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
			end
			
		--
		
		--CONTENTS--
		--Image--
		local Dimage = vgui.Create( "DImage", Dpanel )
		Dimage:SetImage( v[3], "vgui/avatar_default" )
		Dimage:SetSize(100, 100)
		--Create a rainbow border if you own the perk
		if( perkstate or perkstacks>=1 ) then
			Dimage.PaintOver = function(_, w, h)
				surface.SetDrawColor(HSVToColor(RealTime() * 100 % 360, 1, 1))
				surface.DrawOutlinedRect(0, 0, w, h)
				surface.DrawOutlinedRect(1, 1, w-2, h-2)
			end
		end
		--Labels--
		
		local offset = 120
		
			--Perk name
		local Dlabel = vgui.Create( "DLabel", Dpanel )
		Dlabel:SetFont("perkFontSmall")
		Dlabel:SetText(v[4])
		Dlabel:SizeToContents()
		Dlabel:SetPos(offset, 0)
		if(perkstate) then
			Dlabel:SetColor(Color(255,255,255, 105))
		else
			Dlabel:SetColor(Color(255,255,255, 255))
		end
			--Perk description
		local Dlabel = vgui.Create( "DLabel", Dpanel )
		Dlabel:SetFont("perkFontSmall")
		Dlabel:SetText(v[5])
		Dlabel:SetSize( 250, 50 )
		Dlabel:SetPos(offset, 25)
		if(perkstate) then
			Dlabel:SetColor(Color(109,202,255, 105))
		else
			Dlabel:SetColor(Color(109,202,255))
		end
		Dlabel:SetWrap(true)
		Dlabel:SetAutoStretchVertical(true)
		
			--Perk cost
		local Dlabel = vgui.Create( "DLabel", Dpanel )
		local perkcostlbl = string.Comma(v[7])
		if(perkstacks>=1) then
			perkcostlbl = string.Comma(costformula)
		end
		Dlabel:SetFont("perkFontSmall")
		Dlabel:SetText("Costs $"..perkcostlbl.." and 1 perk point.")
		Dlabel:SetSize( 250, 50 )
		Dlabel:SetPos(offset, 81)
		if(perkstate) then
			Dlabel:SetColor(Color(96,255,84, 105))
		else
			Dlabel:SetColor(Color(96,255,84))
		end
		Dlabel:SetWrap(true)
		Dlabel:SetAutoStretchVertical(true)
		
		--Button--
		
		local buyButton = vgui.Create( "DButton", Dpanel)
		
		buyButton:SetPos(375, Dpanel:GetTall()/2 - 50)
		buyButton:SetSize(100, 65)
		buyButton:SetText("")
		buyButton.Paint = function(_, w, h)
			if(perkstate == false) then
				--Color the button differently if its repeatable
				if(perkstacks>=1) then
					if not (buyButton:IsDown()) then
						draw.RoundedBox(15, 0, 0, w, h, Color(215, 110, 239, 255))
					else
						draw.RoundedBox(15, 0, 0, w, h, Color(107, 86, 112))
					end
				else
					if not (buyButton:IsDown()) then
						draw.RoundedBox(15, 0, 0, w, h, Color(255, 110, 110, 255))
					else
						draw.RoundedBox(15, 0, 0, w, h, Color(144, 81, 81, 255))
					end
				end
			else
				draw.RoundedBox(15, 0, 0, w, h, Color(125,125,125, 255))
			end
		end
		
		--print(LocalPlayer():GetNWBool(PERKS_TABLE[k][2]))
		-- Check if player doesn't have the perk
		if(perkstate == false) then
			buyButton:SetEnabled(true)
		else
			buyButton:SetEnabled(false)
		end
		
		--On click purchase
		buyButton.DoClick = function (self)
				local perkpts = LocalPlayer():GetNWInt("perkpts")
				
				if(tonumber(perkpts) > 0 ) then
					if(perkstacks >= 1) then
						if( (LocalPlayer():getDarkRPVar("money") or "0") > costformula) then
							net.Start("pickaxeGainPerk")
							net.WriteString(PERKS_TABLE[k][2])
							net.SendToServer()
							
							self:GetParent():GetParent():GetParent():GetParent():Close()
						else
							chat.AddText(Color(244, 66, 75), ply, "You do not have enough money.")
							surface.PlaySound("buttons/button2.wav")
						end
					else
						if( (LocalPlayer():getDarkRPVar("money") or "0") > v[7]) then
							net.Start("pickaxeGainPerk")
							net.WriteString(PERKS_TABLE[k][2])
							net.SendToServer()
							
							self:GetParent():GetParent():GetParent():GetParent():Close()
						else
							chat.AddText(Color(244, 66, 75), ply, "You do not have enough money.")
							surface.PlaySound("buttons/button2.wav")
						end
					end
				else
					chat.AddText(Color(244, 66, 75), ply, "You do not have enough Perk Points.")
					surface.PlaySound("buttons/button2.wav")
				end
			end
		
		local Dlabel = vgui.Create( "DLabel", buyButton )
		Dlabel:SetFont("perkFont")
		if(perkstate == false) then
			Dlabel:SetFont("perkFont")
			Dlabel:SetText("BUY")
		else
			Dlabel:SetFont("perkFontSmall")
			Dlabel:SetText("OWNED")
		end
		Dlabel:SizeToContents()
		Dlabel:Center()
		Dlabel:SetColor(Color(255,255,255))
		
		--Show stacks if its repeatable
		if(v[8] == 1) then
			local Dlabel = vgui.Create( "DLabel", Dpanel )
			Dlabel:SetFont("perkFontSmall")
			
			-- Hardcoded cuz im bad
			if(v[2] == "perk_voidore") then
				Dlabel:SetText("Bonus: ".. perkstacks*5 .."% ("..perkstacks..")")
			elseif(v[2] == "perk_voidartifacts") then
				Dlabel:SetText("Bonus: ".. perkstacks*20 .."% ("..perkstacks..")")
			elseif(v[2] == "perk_heavenlyjackpots") then
				Dlabel:SetText("Bonus: ".. perkstacks*1.5 .."% ("..perkstacks..")")
			elseif(v[2] == "perk_enhancedmining") then
				Dlabel:SetText("Bonus: ".. perkstacks*30 .."% ("..perkstacks..")")			
			elseif(v[2] == "perk_powersmash") then
				Dlabel:SetText("Bonus: ".. perkstacks*5 .."% ("..perkstacks..")")			
			elseif(v[2] == "perk_powerlevel") then
				Dlabel:SetText("Bonus: ".. perkstacks*8 .."% ("..perkstacks..")")
			else
				Dlabel:SetText("("..perkstacks..")")
			end
			
			Dlabel:SizeToContents()
			local centerwidth = ((buyButton:GetWide() - Dlabel:GetWide())/2)
			Dlabel:SetPos(375 + centerwidth, Dpanel:GetTall()/2 + 20)
			if(perkstacks >= 1) then
				Dlabel:SetColor(Color(228, 109, 255))
			else
				Dlabel:SetColor(Color(255, 255, 255))
			end
		end
		--END

	end
	
end

vgui.Register("Pickaxe:PerkFrame", PANEL, "DScrollPanel")

--KEY REG
hook.Add("Think", "Pickaxe:Keys", function()
	local ply = LocalPlayer()
	if(ply:GetActiveWeapon():IsValid()) then
		if not vgui.CursorVisible() and ply:GetActiveWeapon():GetClass() == "mgs_pickaxe" then
			if input.IsKeyDown(KEY_N) then
				RunConsoleCommand( "pickaxe_prestige_menu" )
			end	
		end
	end
end)
