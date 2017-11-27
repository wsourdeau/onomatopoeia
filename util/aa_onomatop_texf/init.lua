-- this is a minetest mod which approximately tells the nodenames with the
-- top and side texture

local function get_tex_from_tab(t)
	if t.animation then
		return "unknown_node.png"
	end
	return t.name
end

local function no_modifier(name)
	local p = name:find"%^"
	if not p then
		return name
	end
	local base = name:sub(1, p-1)
	-- coal ore etc. are shown as stone
	return base
end

minetest.after(0, function()
local s = ""
for name,def in pairs(minetest.registered_nodes) do
	local tiles = def.tiles or def.tile_images
	if tiles then
		-- visible node (no air and no ignore)
		local top = tiles[1]
		if type(top) == "table" then
			top = get_tex_from_tab(top)
		end
		local side = tiles[3] or tiles[2] or top
		if type(side) == "table" then
			side = get_tex_from_tab(side)
		end
		top = no_modifier(top)
		side = no_modifier(side)
		s = s .. '"' .. name .. '": ("' .. top .. '", "' .. side .. '"),\n'
	end
end

print(s)
end)

--[[
mark the result after removing texture modifiers, then run
$ (xsel -o | cut -f4 -d'"'; xsel -o | cut -f6 -d'"') | sort -u
to get all texture names

to copy the textures:
$ for name in $(xsel -o); do for tfold in mods/*/textures; do p=$tfold/$name; if [ -e $p ]; then echo $p; cp -i $p ~/Downloads/tmp_mem/text/$name; break; fi; done; done

also, don't forget unknown_node.png
]]
