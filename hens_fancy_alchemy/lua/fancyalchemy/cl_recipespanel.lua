if SERVER then return end

local potionTypes = {
	["health"] = {
		color = Color(255, 91, 94)
	},
	["speed"] = {
		color = Color(153, 255, 137)
	}, 
	["gravity"] = {
		color = Color(231, 135, 255)
	}, 
	["poison"] = {
		color = Color(255, 112, 183)
	},
	["armor"] = {
		color = Color(130, 150, 255)
	},
	["wealth"] = {
		color = Color(249, 248, 142)
	},
	["mystery"] = {
		color = Color(255, 255, 255)
	}
}
local potionQualities = {
[1] = "Simple", 
[2] = "Advanced", 
[3] = "Superb", 
[4] = "Illustrious"
}

local potionConversion = {
["fancyalchemy_health_potion"] = "health",
["fancyalchemy_armor_potion"] = "armor",
["fancyalchemy_gravity_potion"] = "gravity",
["fancyalchemy_mystery_potion"] = "mystery",
["fancyalchemy_poison_potion"] = "poison",
["fancyalchemy_speed_potion"] = "speed",
["fancyalchemy_wealth_potion"] = "wealth"
}

// *RECIPES PANEL* //

local knownRecipes = {}

local PANEL = {}
local bgw, bgh = ScrW()*0.3, ScrH()*0.4
function PANEL:Init()
	--Init look	
	self:MakePopup()
	self:SetDeleteOnClose(true)
	self:SetTitle("")
	self:SetSize(bgw, bgh)
	self:Center()
	self:ShowCloseButton(true)
	self:SetAlpha(0)
	self:AlphaTo(255, 0.3, 0)

	self.Paint = function(self, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 240))	
	end
	
	if(LocalPlayer():GetNWInt("falch_level") == 0) then
		self:Close()
		net.Start("falch_InitData")
			net.WriteEntity(LocalPlayer())
		net.SendToServer()
	end
	
	self.recipePanels = vgui.Create("FA:RecipeCategories", self)
end

vgui.Register("FA:RecipeMainPanel", PANEL, "DFrame")

net.Receive("fa_open_recipes", function()
	knownRecipes = net.ReadTable()
	vgui.Create("FA:RecipeMainPanel")
end)

local PANEL = {}
local categories = {}
local qualities = {}
local dList = {}
local entries = {{},{}}

function PANEL:Init()
	self:Dock(FILL)
	
	for k, v in ipairs(FANCYALCHEMY_RECIPES) do
		local cat = (potionConversion[v.reward])
		if(cat ~= nil) then
			// IF THE PLAYER KNOWS THE RECIPE
			if(knownRecipes[k]) then
				
				if(categories[cat] == nil) then
					categories[cat] = vgui.Create( "DCollapsibleCategory", self )
					categories[cat]:SetExpanded( 0 )
					categories[cat]:Dock(TOP)
					categories[cat]:DockMargin(0, 10, 0, 0)
					categories[cat]:SetLabel(  string.upper(cat) )
					categories[cat].Header:SetFont("FALCH_Tooltip")
					categories[cat].Header:SetTextColor(potionTypes[cat].color)
					
					categories[cat].Paint = function(self, w, h)
						draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 245))
					end
					
					dList[cat] = vgui.Create( "DListLayout", categories[cat] )
					categories[cat] :SetContents( dList[cat] )
					entries[cat] = {}
				end
				
				if(entries[cat][v.quality] == nil) then
					qualities[cat] = vgui.Create( "DCollapsibleCategory", dList[cat]  )
					qualities[cat]:SetExpanded( 0 )
					qualities[cat]:SetLabel(  string.upper(potionQualities[v.quality]) )
					qualities[cat].Header:SetTextColor(Color(0,0,0))
					qualities[cat].Header:SetFont("FALCH_Tooltip")
					qualities[cat].Paint = function(self, w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 100 - (k%2 *30)))
					end
					dList[cat] :Add(qualities[cat])
					entries[cat][v.quality] = vgui.Create( "DListLayout", qualities[cat] )
					qualities[cat]:SetContents( entries[cat][v.quality] )
				end
			
				local recipeLabel = vgui.Create("DLabel", self)
				recipeLabel:SetText("...")
				recipeLabel:SetFont("FALCH_TooltipCost")
				recipeLabel:SetTextColor(Color(255,255,255))
				entries[cat][v.quality]:Add(recipeLabel)
				
				recipeLabel.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 240))
				end
				local recipeString = " "
				for i, j in pairs(v.recipe) do
					local instance = string.upper(string.Replace(i, "_", " "))
					recipeString = recipeString .. " " .. instance .. " x" .. j .. " "
				end
				
				recipeLabel:SetText(recipeString)
			end
		end
	end
	
	table.Empty(categories)
	table.Empty(entries)
	
	local count = 0
	for k, v in pairs(knownRecipes) do
		if( v == true) then count = count + 1 end
	end
	local recipProg = self:Add("DLabel")
	recipProg:SetText("KNOWN RECIPES:    " .. count .. " / " .. #FANCYALCHEMY_RECIPES)
	recipProg:SetFont("FALCH_TooltipCost")
	recipProg:SetTextColor(Color(255,255,255))
	if(count == #knownRecipes) then
		recipProg:SetText("KNOWN RECIPES:    ALL")
		recipProg:SetTextColor(Color(170, 255, 176))
	end
	recipProg:Dock(TOP)
	recipProg:DockMargin(5, 10, 0, 0)
end

vgui.Register("FA:RecipeCategories", PANEL, "DScrollPanel")
