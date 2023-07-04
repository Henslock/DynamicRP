AddCSLuaFile("weapons/crft_axe/sv_plrstats.lua")
AddCSLuaFile("weapons/crft_axe/cl_inventory.lua")

local function LoadAllFiles( fdir )

	local files,dirs = file.Find( fdir.."*", "LUA" )
	
	for _,file in ipairs( files ) do
		if string.match( file, ".lua" ) then

			if SERVER then AddCSLuaFile( fdir..file ) end
			include( fdir..file )
		end	
	end
	
	for _,dir in ipairs( dirs ) do
		LoadAllFiles( fdir..dir.."/" )
	
	end
	
end

LoadAllFiles( "craftsmanship/" )