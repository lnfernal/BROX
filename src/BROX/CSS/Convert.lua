local SampleCSS = [[
/* Applies to the entire body of the HTML document (except where overridden by more specific
	selectors). */
body {
	margin: 25px;
	background-color: rgb(240,240,240);
	font-family: arial, sans-serif;
	font-size: 14px;
}

/* Applies to all <h1>...</h1> elements. */
h1 {
	font-size: 35px;
	font-weight: normal;
	margin-top: 5px;
}

/* Applies to all elements with <... class="someclass"> specified. */
.someclass { color: red; }

/* Applies to the element with <... id="someid"> specified. */
#someid { color: green; }
]]

local function warnf(s, ...)
	warn(s:format(...));
end

local StringUtil = require(script.Parent.Parent:WaitForChild("StringUtil"));
local StyleType = require(script.Parent:WaitForChild("StyleType"));
local DefaultColors = require(script.Parent:WaitForChild("DefaultColors"));
type Style = StyleType.TagStyle;

--[[
	FORMAT:
		['css-variable-name'] = function(Assignment: string, OutStyle: Style, css_variable_name: string)
]]

local function ParseUnit(String: string): number
	--local Unit = "";
	local UnitStringSize = 0;
	for i = #String, 1, -1 do
		if (string.match(string.sub(String, i, i), "%d") == nil) then
			UnitStringSize += 1;
		else
			break;
		end
	end
	local Unit = string.sub(String, -UnitStringSize, -1);
	local Number = tonumber(string.sub(String, 1, if (#String == 3) then UnitStringSize - 1 else UnitStringSize)); -- dumb fix
	print(Unit, UnitStringSize);
	if (not Number) then
		warn("Unable to parse number from unit: " .. String .. "|" ..string.sub(String, 1, UnitStringSize));
		return 0;
	end
	if (Unit == 'px') then
		return Number;
	elseif (Unit == 'em') then
		return Number * 16;
	elseif (Unit == 'rem') then
		return Number * 16;
	else
		warnf("Unimplemented unit %q returning %dpx.", Unit, Number);
		return Number;
	end
end

local function ParseColor(Color:string): (Color3?, number?)
	if (DefaultColors[Color]) then
		return DefaultColors[Color], 0;
	end
	if (Color == "transparent") then
		return Color3.new(0, 0, 0), 1;
	end
	if (string.sub(Color, 1, 1) == '#') then -- TODO: Parse transparency in hex ex: #ffffff*aa*
		return Color3.fromHex(Color); -- TODO: Gracefully error if error
	else
		if (string.sub(Color, 1, 4) == 'rgba') then
			local Values = string.split(string.sub(Color, 6, -2), ",");
			if (#Values ~= 4) then
				warn("Unable to parse color (rgba): ".. Color);
				return nil;
			end
			for i, Value in ipairs(Values) do
				local number = tonumber(Value);
				if (not number) then
					warn("Unable to cast value number " .. i .. " in color to number: " .. Value);
					return nil;
				end
				Values[i] = number;
			end
			return Color3.new(Values[1], Values[2], Values[3]), 1 - Values[4];
		elseif (string.sub(Color, 1, 3) == 'rgb') then
			local Values = string.split(string.sub(Color, 4, -2), ",");
			if (#Values ~= 3) then
				warn("Unable to parse color (rgb): ".. Color);
				return nil;
			end
			for i, Value in ipairs(Values) do
				local number = tonumber(Value);
				if (not number) then
					warn("Unable to cast " .. i .. " value in color to number (rgb): " .. Value);
					return nil;
				end
				Values[i] = number;
			end
			return Color3.fromRGB(table.unpack(Values)), 0;
		end
	end
end
--print(ParseColor("rgba(47, 47, 47, 0.5)"))
--error()

local ALL_FONTS = Enum.Font:GetEnumItems();
return {
	['color'] = function(Assignment: string, OutStyle: Style, CSSVariableName: string)
		local Color, Transparency = ParseColor(StringUtil.TrimAround(Assignment));
		if (Color ~= nil) then
			OutStyle['TextColor3'] = Color;
			OutStyle.TextTransparency = Transparency or 0;
		end
	end,
	['background-color'] = function(Assignment: string, OutStyle: Style, CSSVariableName: string)
		warn(Assignment);
		local Color, Transparency = ParseColor(StringUtil.TrimAround(Assignment));
		if (Color ~= nil) then
			print("background-color set to", Color, Transparency);
			OutStyle['BackgroundColor3'] = Color;
			OutStyle.BackgroundTransparency = Transparency;
		else
			warn("Didnt parse color");
		end
	end,
	['font-size'] = function(Assignment: string, OutStyle: Style, CSSVariableName: string)
		local PX = ParseUnit(StringUtil.TrimAround(Assignment));
		print("Parsed font-size:", PX, Assignment);
		if (PX) then
			OutStyle.TextSize = PX;
		end
	end,
	['width'] = function(Assignment: string, OutStyle: Style, CSSVariableName: string)
		if (StringUtil.TrimAround(Assignment) == 'fit-content') then
			if (OutStyle.AutomaticSize == Enum.AutomaticSize.Y) then
				OutStyle.AutomaticSize = Enum.AutomaticSize.XY;
			else
				OutStyle.AutomaticSize = Enum.AutomaticSize.X;
			end
		else
			warn("NOt implemeneted");
		end
	end,
	['height'] = function(Assignment: string, OutStyle: Style, CSSVariableName: string)
		if (StringUtil.TrimAround(Assignment) == 'fit-content') then
			if (OutStyle.AutomaticSize == Enum.AutomaticSize.X) then
				OutStyle.AutomaticSize = Enum.AutomaticSize.XY;
			else
				OutStyle.AutomaticSize = Enum.AutomaticSize.Y;
			end
		else
			warn("NOt implemeneted");
		end
	end,
	['font-family'] = function(Assignment: string, OutStyle: Style, CSSVariableName: string)
		Assignment = StringUtil.TrimAround(Assignment);
		xpcall(function()
			OutStyle.Font = Enum.Font[Assignment];
		end, function(err)
			warn("Failed setting font.", err)
		end)
	end,
	['text-align'] = function(Assignment: string, OutStyle: Style, CSSVariableName: string)
		Assignment = StringUtil.TrimAround(Assignment);
		if (Assignment == 'left') then
			OutStyle.TextXAlignment = Enum.TextXAlignment.Left;
		elseif (Assignment == 'right') then
			OutStyle.TextXAlignment = Enum.TextXAlignment.Right;
		elseif (Assignment == 'center') then
			OutStyle.TextXAlignment = Enum.TextXAlignment.Center;
		elseif (Assignment == 'justify') then
			warn("Text allignment 'justify' not implemented.");
		else
			warn("Text allignment '" .. Assignment .. "' unknown.");
		end
	end,
	['padding'] = function(Assignment:string, OutStyle: Style, CSSVariableName: string)
		Assignment = StringUtil.TrimAround(Assignment);
		local Data = string.split(Assignment, " ");
		if (#Data == 1) then
			local Amount = ParseUnit(Data[1]);
			OutStyle.__children = OutStyle.__children or {};
			OutStyle.__children.UIPadding = {
				PaddingLeft = UDim.new(0, Amount),
				PaddingRight = UDim.new(0, Amount),
				PaddingBottom = UDim.new(0, Amount),
				PaddingTop = UDim.new(0, Amount)
			};
		else
			warn("Not implemented");
		end
	end,
	['border-radius'] = function(Assignment:string, OutStyle: Style, CSSVariableName: string)
		Assignment = StringUtil.TrimAround(Assignment);
		local Data = string.split(Assignment, " ");
		if (#Data == 0) then warn("???", CSSVariableName, Assignment); return; end;
		local Amount = ParseUnit(StringUtil.TrimAround(Data[1]));
		print("Added border-radius", Amount, Data[1]);
		OutStyle.__children = OutStyle.__children or {};
		OutStyle.__children.UICorner = {
			CornerRadius = UDim.new(0, Amount),
		};
		if (#Data > 1) then
			warn("Only one border radius is supported due to roblox, using first one provided.");
		end
	end,
} :: {[string]: (Assignment: string, OutStyle: Style, CSSVariableName: string) -> ()}