local c = app.fgColor;
local FileName;
local line_number = 0;
---------------------------
local dlg = Dialog("Atlas Editior")
dlg   :separator{ text="SubTextureInfo:" }
      :entry{ id="Texture_name", label="Name:", text="DuctTape"}
	  :file{ 
		id="Phile",
		label="Atlas:",
		open=true,
		filetypes={ "xml" },
		onchange=function()
			FileName = dlg.data.Phile -- Gets file name
			if (FileName ~= "") then
				dlg:modify{ title = "Atlas Editior - " .. FileName} -- Shows what file name you use.
			else
				dlg:modify{ title = "Atlas Editior"}
			end
		end
		}

	  :button{ text="Generate From Selection", -- Edits Atlas
            onclick=function()
			
						if (FileName and FileName ~= "") then
							local rectangle = app.activeSprite.selection.bounds -- Get selection box
							line_number = 0
							-- app.alert("Opening: " .. FileName)
							local file, err = io.open(FileName, "r")
							-- For whatever reason, file always returns nil, along with nil.
							if (file ~= nil) then
								local _ = {}

								for line in file:lines() do 
									table.insert(_, line)
								end
								file:close()
								for i, line in pairs(_) do -- iterate over each line in the file
									if string.find(line, "<SubTexture name=\"" .. dlg.data["Texture_name"] .."\"") then -- Checks for value
										line_number = i
										line = line:gsub('x="[%d%.%-]+"', 'x="' .. rectangle.x .. '"') -- Subs Values
										line = line:gsub('y="[%d%.%-]+"', 'y="' .. rectangle.y .. '"')
										line = line:gsub('width="[%d%.%-]+"', 'width="' .. rectangle.width .. '"')
										line = line:gsub('height="[%d%.%-]+"', 'height="' .. rectangle.height .. '"')
										_[i] = line
										break
									end
								end
								if (line_number == 0) then
									for i, line in pairs(_) do 
										if string.find(line, "</TextureAtlas>") then 
											local NewLine = "	<SubTexture name=\"" .. dlg.data["Texture_name"] .."\" x=\"".. rectangle.x .."\" y=\"".. rectangle.y .."\" width=\"".. rectangle.width .."\" height=\"".. rectangle.height .."\"/>" -- Inserts new subtexture with formatting (I hope)
											table.insert(_, i, NewLine)
											break
										end
									end
								end
								file, err = io.open(FileName, "w")
								for i,line in ipairs(_) do 
									file:write(line .. '\n')
								end
								file:close()
							else
								app.alert("Couldn't open file: " .. err) 
							end
						else
							app.alert("Please select a file")
						end
                    end }
      :show{wait=false}
---------------------------------------

