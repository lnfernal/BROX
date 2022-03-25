local Node = require(script.Parent:WaitForChild("Node"));
local StringUtil = require(script.Parent:WaitForChild("StringUtil"));
local Convert = require(script:WaitForChild("Convert"));
local StyleType = require(script:WaitForChild("StyleType"));

type TagStyle = StyleType.TagStyle; --[[{
	Font: Enum.Font?,
	TextSize: number?,
	Color: Color3?,
	BackgroundColor: Color3?
};]]

local CSS = {
	DefaultStylesheet = {
		body = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			Size = UDim2.new(0, 500, 0, 500),
			
			__children = {
				["UIListLayout"] = {
					FillDirection = Enum.FillDirection.Vertical,
					Sortorder = Enum.SortOrder.LayoutOrder,
				},
				["UIPadding"] = {
					PaddingTop = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8)
				}
			}
		},
		h1 = {
			Font = Enum.Font.Arial,
			TextSize = 24,
			TextColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		},
		p = {
			Font = Enum.Font.Arial,
			TextSize = 12,
			TextColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}
	} :: {[string]: TagStyle},
};
--TODO: Convert .css files to above format ^
for i = 1, 6 do -- Generate styles
	print("h"..i, (6 - i) * 2 + 12);
	CSS.DefaultStylesheet['h'.. (i)] = {
		Font = Enum.Font.Arial,
		TextSize = (6 - i) * 1.5 + 16,
		TextColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	};
end
local Stylesheets = { CSS.DefaultStylesheet };
function CSS:QueryProperty(TagName: string, ClassName: string, Property: string)
	print(Stylesheets);
	for _, Stylesheet in ipairs(Stylesheets) do
		if (Stylesheet[TagName]) then
			if (Stylesheet[TagName][Property]) then
				return Stylesheet[TagName][Property];
			end
		end
	end
end

function CSS:GetStyles(TagName: string, ClassName: string)
	for _, Stylesheet in pairs(Stylesheets) do
		if (Stylesheet[TagName]) then
			if (Stylesheet[TagName]) then
				return Stylesheet[TagName];
			end
		end
	end
end

function CSS:ApplyStyle(Object:Instance, Element: Node.Node?, Style: TagStyle?)
	--TODO: Element Class Name
	local Styles = Style;
	if (Element) then
		Styles = self:GetStyles(Element.nodeName, "");
	end
	if (not Styles) then
		warn("No styles for '" .. (Element.nodeName or "##ERROR##") .. "'");
		return;
	end
	for Property, Value in pairs(Styles) do
		if (Property == "__children") then
			for class, childStyle in pairs(Value) do
				local childInstance = Instance.new(class);
				print("Applying child style", childStyle);
				self:ApplyStyle(childInstance, nil, childStyle);
				childInstance.Parent = Object;
			end
			continue;
		end
		xpcall(function()
			Object[Property] = Value;
		end, function(err)
			warn(err)
		end)
	end
end
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
function CSS:ConvertCSS(CSS:string)
	CSS = '\n' .. CSS;
	local Stylesheet: {[string]: StyleType} = {};
	
	local Skip = 0;
	for i = 1, #CSS do
		if (i < Skip) then continue; end;
		local char = string.sub(CSS, i, i);
		if (char == '/') then
			local char_next = string.sub(CSS, i + 1, i + 1);
			if (char_next == '*') then
				local CommentEnd = StringUtil.FindFirstString(CSS, i, "*/");
				if (CommentEnd) then
					Skip = CommentEnd;
				else
					error("Expected '*/' to close comment."); -- TODO: log line
				end
			end
		end
		if (char == '{') then
			local ClassNameStart = StringUtil.FindFirstBackwards(CSS, i, "\n", "}");
			assert(ClassNameStart ~= nil, "Expected style name before '{'");
			local ClassName = string.sub(CSS, ClassNameStart, i - 1);
			ClassName = StringUtil.TrimAround(ClassName);
			local ClassEnd = StringUtil.FindFirst(CSS, i, "}"); -- FIXME: Ignore strings
			assert(ClassEnd ~= nil, "Expected '}' to close style."); -- TODO: log line
			local Class = string.sub(CSS, i, ClassEnd);
			
			local OutStyle = {__children = {}};
			
			local Lines = string.split(string.sub(Class, 2, -2), ";");
			for _, Line in ipairs(Lines) do
				local Line = StringUtil.TrimAround(Line);
				local Decleration = string.split(Line, ':');
				if (Decleration[1] and Decleration[2]) then
					if (Convert[Decleration[1]]) then
						Convert[Decleration[1]](Decleration[2], OutStyle, Decleration[1]);
					end
				else
					warn("Nothing on line");
				end
			end
			Stylesheet[ClassName] = OutStyle;
			
			Skip = ClassEnd;
		end
	end
	
	print("Inserted css", Stylesheet);
	table.insert(Stylesheets, 1, Stylesheet);
end

return CSS;