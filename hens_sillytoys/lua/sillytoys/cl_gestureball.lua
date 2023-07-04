//

if SERVER then return end

local GESTURESTBL = {
	["Thumbs Up"] = ACT_GMOD_GESTURE_AGREE,
	["Come Here"] = ACT_GMOD_GESTURE_BECON,
	["Bow"] = ACT_GMOD_GESTURE_BOW,
	["Cheer"] = ACT_GMOD_TAUNT_CHEER,
	["Dance"] = ACT_GMOD_TAUNT_DANCE,
	["Disagree"] = ACT_GMOD_GESTURE_DISAGREE,
	["Forward Signal"] = ACT_SIGNAL_FORWARD,
	["Group Signal"] = ACT_SIGNAL_GROUP,
	["Halt Signal"] = ACT_SIGNAL_HALT,
	["Laugh"] = ACT_GMOD_TAUNT_LAUGH,
	["Sexy Dance"] = ACT_GMOD_TAUNT_MUSCLE,
	["Karate Kid"] = ACT_GMOD_TAUNT_PERSISTENCE,
	["The Robot"] = ACT_GMOD_TAUNT_ROBOT,
	["Salute"] = ACT_GMOD_TAUNT_SALUTE,
	["Wave"] = ACT_GMOD_GESTURE_WAVE,
	["The Zombie"] = ACT_GMOD_GESTURE_TAUNT_ZOMBIE,
}

surface.CreateFont( "ST_Gesture_FontRegular", {
	font = "Calibri",
	extended = false,
	size = 22,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
} )

surface.CreateFont( "ST_Gesture_FontSmall", {
	font = "Calibri",
	extended = false,
	size = 18,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false ,
} )

// Main Init

local loopToggle = false

local PANEL = {}

function PANEL:Init()
	local w = 192
	local h = 500
	self:SetSize(w, h)
	self:SetPos(ScrW()*0.75, ScrH()/2 - (h/2))
	
	self:MakePopup()
	self:SetDeleteOnClose(true)
	self:SetDraggable(true)
	self:ShowCloseButton(false)
	self:SetTitle("")
	
	self.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	self.scrollBar = vgui.Create("ST_GestureAnims:ScrollBar", self)
	
	local closeBtn = self:Add("DButton")
	closeBtn:SetSize(20, 20)
	closeBtn:SetText("X")
	closeBtn:SetTextColor(Color(0,0,0))
	closeBtn.HoverLerp = 0
	closeBtn:SetPos(160, 0)
	
	closeBtn.Paint = function(_, w, h)
		if closeBtn:IsHovered() then
			closeBtn.HoverLerp = Lerp( FrameTime() * 5, closeBtn.HoverLerp, 1 )
		else
			closeBtn.HoverLerp = Lerp( FrameTime() * 3, closeBtn.HoverLerp, 0.3)
		end
		draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 225 * closeBtn.HoverLerp))
	end
	
	closeBtn.DoClick = function()
		self:Close()
	end
	
	// Loop button
	
	local loopBtn = self:Add("DButton")
	loopBtn:SetSize(20, 20)
	if(loopToggle == true) then
		loopBtn:SetText("X")
	else
		loopBtn:SetText("")
	end
	loopBtn:SetTextColor(Color(0,0,0))
	loopBtn.HoverLerp = 0
	loopBtn:SetPos(15, 0)
	
	loopBtn.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 200 ))
	end
	
	loopBtn.DoClick = function()
		loopToggle = !loopToggle
		
		if(loopToggle == true) then
			loopBtn:SetText("X")
		else
			loopBtn:SetText("")
		end
	end
	
	local loopLbl = self:Add("DLabel")
	local x, y = loopBtn:GetPos()
	loopLbl:SetPos(x + 30, 0) 
	loopLbl:SetText("Loop")
	loopLbl:SetFont("ST_Gesture_FontSmall")
	loopLbl:SetColor(Color(255,255,255))
end

vgui.Register("ST_GestureAnims:Menu", PANEL, "DFrame")

net.Receive("ST_openAnimsMenu", function()
	if(IsValid(gestPanel)) then return end
	gestPanel = vgui.Create("ST_GestureAnims:Menu")
end)

// Scroll Bar

local PANEL = {}

function PANEL:Init()
	
	local x,y = self:GetParent():GetSize()
	self:SetSize(x, y + 60)
	self:SetPos(0, 30)
	
	--Modify Scroll Bar--
	
	local sbar = self:GetVBar()
	sbar:SetHideButtons(true)
	sbar.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, (w/2), h, Color(0, 0, 0, 225))
	end
	
	sbar.btnGrip.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, (w/2), h, Color(255, 255, 255, 255))
	end
	
	self.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	for k, v in pairs(GESTURESTBL) do
		local btn = self:Add("DButton")
		btn:SetSize(150, 50)
		btn:Dock(TOP)
		btn:DockMargin(10, 0, 10, 10)
		
		btn:SetText("")
		
		btn.HoverLerp = 0
		btn.rLerp =0
		btn.gLerp = 0
		btn.bLerp = 0
		btn.Paint = function(_, w, h)
			if btn:IsHovered() then
				btn.HoverLerp = Lerp( FrameTime() * 10, btn.HoverLerp, 1 )
				btn.rLerp = Lerp( FrameTime() * 10, btn.rLerp, 53 )
				btn.gLerp = Lerp( FrameTime() * 10, btn.gLerp, 157 )
				btn.bLerp = Lerp( FrameTime() * 10, btn.bLerp, 225 )
			else
				btn.HoverLerp = Lerp( FrameTime() * 3, btn.HoverLerp, 0.8)
				btn.rLerp = Lerp( FrameTime() * 3, btn.rLerp, 0 )
				btn.gLerp = Lerp( FrameTime() * 3, btn.gLerp, 0 )
				btn.bLerp = Lerp( FrameTime() * 3, btn.bLerp, 0 )
			end
			draw.RoundedBox(0, 0, 0, w, h, Color(btn.rLerp, btn.gLerp, btn.bLerp, 255 * btn.HoverLerp))
		end
		
		btn.PaintOver = function(_, w, h)
			surface.SetDrawColor(Color(255, 255, 255, 125), 1, 1)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
		btn.DoClick = function()
		
			net.Start("ST_gestureAnims")
				net.WriteFloat(v)
				net.WriteBool(loopToggle)
			net.SendToServer()
			
			self:GetParent():Close()
		end
		
		local btnLbl = btn:Add("DLabel")
		btnLbl:SetText(k)
		btnLbl:SetFont("ST_Gesture_FontRegular")
		btnLbl:SizeToContents()
		btnLbl:Center()
		btnLbl:SetColor(Color(255,255,255))
	end
	
	self:Dock(FILL)
	self:DockMargin(0, 0, 0, 10)
end

vgui.Register("ST_GestureAnims:ScrollBar", PANEL, "DScrollPanel")