/*
2018 - Silly Toys by Hens

Do not re-upload or re-use content with permission of the owner.
All custom assets created by Hens.

*/

print("= Loaded SILLY TOYS by Hens =")

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

LoadAllFiles( "sillytoys/" )