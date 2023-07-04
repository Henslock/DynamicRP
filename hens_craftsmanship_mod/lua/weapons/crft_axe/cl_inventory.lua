-- Inventory View for Axe -- 

include("craftsmanship/crft_fontgen.lua")
include("sv_plrstats.lua")

local crft_UI_BG =  ( "materials/UI/inventory/invPanel.png" )
local crft_UI_IncIcon =  ( "materials/UI/inventory/invIcon.png" )

local bgw, bgh

--INITIAL PANEL--
local PANEL = {}

function PANEL:Init()
	--Init look
	bgw = 768
	bgh = 512
	
	self:MakePopup()
	self:SetDeleteOnClose(true)
	self:Dock(FILL)
	self:Center()
	self:SetDraggable(false)
	self:SetTitle("")
	self:SetSize(bgw, bgh)
	self:Center()
	self:ShowCloseButton(true)
	self:SetAlpha(0)
	self:AlphaTo(255, 0.3, 0)
	
	
	LocalPlayer():EmitSound( "inv_open", 100, 80, 1, CHAN_AUTO )
	
	self.Paint = function(self, w, h)
	    local blur = Material("pp/blurscreen")
		local function DrawBlurRect(x, y, w, h)
			local X, Y = 0,0

			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(blur)
			
			    for i = 1, 3 do
					blur:SetFloat("$blur", (i / 3) * (5))
					blur:Recompute()

					render.UpdateScreenEffectTexture()

					render.SetScissorRect(x, y, x+w, y+h, true)
					surface.DrawTexturedRect(X * -1, Y * -1, ScrW(), ScrH())
					render.SetScissorRect(0, 0, 0, 0, false)
				end
			surface.SetDrawColor(0,0,0)
			surface.DrawOutlinedRect(x,y,w,h)
		end
		DrawBlurRect(0, 0, w, h)
		draw.RoundedBox(10, (ScrW() / 2) - (bgw/2) , (ScrH() / 2) - (bgh/2), bgw, bgh, Color(0, 0, 0, 0))	
	end
	
	-- Draw Panel BG
	self.invPanelBG = self:Add("DImage")
	self.invPanelBG:SetPos(ScrW() / 2 - bgw*0.5, ScrH()/2 - bgh*0.5 - 75)
	self.invPanelBG:SetSize(bgw, bgh)
	self.invPanelBG:SetImage( crft_UI_BG )
	
	-- User Data
	local userName = LocalPlayer():GetName()
	if(string.len(userName) > 20) then
		userName = string.sub(userName, 0, 20)
		userName = userName.. ".."
	end
	self.invUserName = self:Add("DLabel")
	self.invUserName:SetFont("CRFT_InvFontReg")
	self.invUserName:SetText(userName)
	self.invUserName:SetPos((ScrW() / 2) - (bgw/2) + 40, ScrH()/2 - bgh*0.5 + 70)
	self.invUserName:SizeToContents()
	self.invUserName:SetColor(Color(255,255,255))
	
	self.invUserLevel = self:Add("DLabel")
	self.invUserLevel:SetFont("CRFT_InvFontReg")
	self.invUserLevel:SetText("Lv. "..LocalPlayer():GetNWInt("crft_level"))
	self.invUserLevel:SetPos((ScrW() / 2) - (bgw/2) + 40, ScrH()/2 - bgh*0.5 + 90)
	self.invUserLevel:SizeToContents()
	self.invUserLevel:SetColor(Color(255,255,255))
	
	self.closebtn = vgui.Create("Crafting:InventoryClosingButton", self)
	self.invPanel = vgui.Create("Crafting:Inventory", self)
	
end

vgui.Register("Crafting:InventoryMain", PANEL, "DFrame")

-- CLOSING BUTTON
local PANEL = {}

function PANEL:Init()
	self:SetPos((ScrW() / 2) + (bgw/2) - 45, ScrH()/2 - bgh*0.5 + 50)
	self:SetSize(16, 16)
	self:SetText("")
	self:SetImage("UI/inventory/invCloseBtn.png")
	
	self.DoClick = function (self)
			LocalPlayer():EmitSound( "inv_close", 100, 80, 1, CHAN_AUTO )
			self:GetParent():Close()
		end
end

vgui.Register("Crafting:InventoryClosingButton", PANEL, "DImageButton")

-- INVENTORY PANEL
local PANEL = {}

function PANEL:Init()
	--Init look
	local x,y = self:GetParent():GetSize()
	local posx,posy = self:GetParent():GetPos()
	local topframepad = 155
	
	self:SetSize(x - topframepad*2, y * 0.52)
	self:SetPos(posx + topframepad, posy + 145)
	self:SetVerticalScrollbarEnabled(true)
	
	self.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 0))
	end
	
	--Modify Scroll Bar--
	
	local sbar = self:GetVBar()
	sbar:SetHideButtons(true)
	
	sbar.Paint = function(_, w, h)
		draw.RoundedBox(10, 0, 0, (w/3), h, Color(0, 0, 0, 115))
	end
	
	sbar.btnGrip.Paint = function(_, w, h)
		draw.RoundedBox(10, 0, 0, (w/3), h, Color(50, 50, 50, 255))
	end
	
	------------------------
	local dGrid = self:Add("DGrid")
	dGrid:SetPos(10, 0)
	dGrid:SetCols(3)
	dGrid:SetColWide(150)
	dGrid:SetRowHeight(133)
	
	--CREATE ICONS--
	for k, v in ipairs(CRAFTSMANSHIP_MATS) do
		
		--GUI Icon BG
		local Dpanel = vgui.Create( "DImage" )
		Dpanel:SetSize(124, 124)
		Dpanel:SetImage( crft_UI_IncIcon )
		dGrid:AddItem(Dpanel)
		
		local sk = table.Copy(derma.GetDefaultSkin())
		sk.PaintTooltip = function() end
		derma.DefineSkin("TooltipAids", "Good lord", sk)
		
		--[[TOOLTIPS]]
			local tooltipPanel = vgui.Create("Panel")
			tooltipPanel:SetSize(225, 150)
			tooltipPanel:SetVisible(false)
			tooltipPanel.Paint = function( s, w, h ) 
				draw.RoundedBox( 10, 0, 0, w, h, Color( 0, 0, 0, 245 ) ) 
			end
			tooltipPanel.Think = function(self)
				self:GetParent():SetSkin("TooltipAids")
				self:GetParent():SetPos(gui.MouseX() + 10, gui.MouseY() - 165)
			end
			
			--Name
			local Dlabel = vgui.Create( "DLabel", tooltipPanel )
			surface.SetFont("CRFT_InvFontReg")
			local Dlabeltext = string.upper(v.name)
			local Dlabeltextsize = surface.GetTextSize(Dlabeltext)
			Dlabel:SetFont("CRFT_InvFontReg")
			Dlabel:SetSize(190, 150)
			Dlabel:SetColor(Color(145, 242, 163, 255))
			Dlabel:SetPos(10, -60)
			Dlabel:SetText(Dlabeltext)
			
			--Quantity
			local Dlabel = vgui.Create( "DLabel", tooltipPanel )
			surface.SetFont("CRFT_InvFontReg")
			local Dlabeltext = "x"..LocalPlayer():GetNWInt(v.tag)
			Dlabel:SetFont("CRFT_InvFontReg")
			Dlabel:SetSize(190, 150)
			Dlabel:SetColor(Color(255, 255, 255, 255))
			Dlabel:SetPos(Dlabeltextsize + 15, -60)
			Dlabel:SetText(Dlabeltext)

			--Description
			local Dlabel = vgui.Create( "DLabel", tooltipPanel )
			surface.SetFont("CRFT_InvFontSmall")
			local Dlabeltext = v.desc
			local Dlabeltextsize = surface.GetTextSize(Dlabeltext)
			Dlabel:SetFont("CRFT_InvFontSmall")
			Dlabel:SetSize(190, 150)
			Dlabel:SetColor(Color(205, 235, 225, 255))
			Dlabel:SetPos(10, 24)
			Dlabel:SetWrap(true)
			Dlabel:SetAutoStretchVertical(true)
			Dlabel:SetText(Dlabeltext)
			
			tooltipPanel:SetSize(200, 50 + Dlabeltextsize/12)
		
		--[[END TOOLTIPS]]
		
		--Model
		local Dmodel = vgui.Create( "DModelPanel", Dpanel )
		Dmodel:SetSize(124, 124)
		Dmodel:SetModel(v.model)
		if(v.mat ~= nil) then
			Dmodel.Entity:SetMaterial(v.mat)
		end
		Dmodel:SetCamPos( v.ui_vec )
		Dmodel:SetLookAt(Vector(0,0,0))
		Dmodel:SetAlpha(0)
		Dmodel:AlphaTo(255, 0.5, 0.3)
		Dmodel:SetSkin("TooltipAids")
		Dmodel:SetTooltipPanel(tooltipPanel)

		--Name
		local Dlabel = vgui.Create( "DLabel", Dmodel )
		
		local Dlabeltext = v.name
		surface.SetFont("CRFT_InvFontLarge")
		local Dlabeltextsize = surface.GetTextSize(Dlabeltext)
		Dlabel:SetFont("CRFT_InvFontLarge")
		Dlabel:SetSize(124, 124)
		Dlabel:SetPos(64 - Dlabeltextsize*0.5, -45)
		Dlabel:SetText(Dlabeltext)
		
		
		--Quantity
		local Dlabel = vgui.Create( "DLabel", Dmodel )
		
		local plrHoldAmnt = LocalPlayer():GetNWInt(v.tag)
		local invColor = Color(255, 255, 255)
		
		if(plrHoldAmnt >= v.basecarry) then
			invColor = Color(96, 224, 122)
		end
		local Dlabeltext = plrHoldAmnt.. " / "..v.basecarry
		surface.SetFont("CRFT_InvFontReg")
		local Dlabeltextsize = surface.GetTextSize(Dlabeltext)
		Dlabel:SetFont("CRFT_InvFontReg")
		Dlabel:SetSize(124, 124)
		Dlabel:SetColor(invColor)
		Dlabel:SetPos(Dmodel:GetWide()/2 - Dlabeltextsize*0.5, 50)
		Dlabel:SetText(Dlabeltext)
		
	end
end


vgui.Register("Crafting:Inventory", PANEL, "DScrollPanel")

--KEY REG
hook.Add("Think", "Crafting:Keys", function()
	local ply = LocalPlayer()
	if(ply:GetActiveWeapon():IsValid()) then
		if not vgui.CursorVisible() and ply:GetActiveWeapon():GetClass() == "crft_axe" then
			if input.IsKeyDown(KEY_N) then
				RunConsoleCommand( "crafting_inventory_menu" )
			end	
		end
	end
end)