--!strict

local StringUtil = require(script.Parent:WaitForChild("StringUtil"));
local HTMLParser = {};

local TEST1 = [[
<!DOCTYPE html>
<html>
<body>

<h1>My First Heading</h1>

<p>My first paragraph.</p>

</body>
</html>
]]

local function warnf(String: string, ...:string)
	warn(string.format(String, ...));
end
local function errorf(String: string, ...:string)
	error(string.format(String, ...));
end
local function printf(String: string, ...:string)
	print(string.format(String, ...));
end


export type PsuedoElement = {
	Name: string;
	Attributes: {[string]: string | boolean | number};
	AttributeString: string?;
	Children: {PsuedoElement};
	Value: string;
	Parent: PsuedoElement;
};

function HTMLParser:ParseString(String:string)
	local Root_  = {
		Name = "#root",
		Attributes = {},
		Children = {},
		Value = "",
		Parent = nil :: any
	};
	Root_.Parent = Root_;
	local Root: PsuedoElement = Root_ :: PsuedoElement;
	local StackTop: PsuedoElement  = Root;

	local Skip = 1;
	for i = 1, #String do
		if (i < Skip) then
			continue;
		end
		local OpeningTag = StringUtil.FindFirst(String, i, '<');
		if (OpeningTag) then
			local ClosingTag = StringUtil.FindFirst(String, OpeningTag + 1, '>');
			assert(ClosingTag ~= nil, "Expected > to close <"); -- TODO: Log line number
			-- NOTE: Maybe we shouldn't do this in parsing
			if (StackTop.Name == "pre") then -- Dont trim on pre element
				StackTop.Value = StringUtil.TrimAround(string.sub(String, Skip + 1, OpeningTag - 1));
			else
				StackTop.Value = StringUtil.Trim(string.sub(String, Skip + 1, OpeningTag - 1));
			end
			local Tag = string.sub(String, OpeningTag, ClosingTag);
			local TagNameEnd = StringUtil.FindFirst(String, OpeningTag, " ", ">");
			assert(TagNameEnd ~= nil, "Unreachable because we already check for '>' before.");
			local TagName = string.sub(String, OpeningTag + 1, TagNameEnd - 1);
			local AttributeString = string.sub(String, TagNameEnd + 1, ClosingTag - 1);
			local IsClosing = false;
			local IsSpecial = false;
			if (string.sub(TagName, 1, 1) == '/') then
				IsClosing = true;
				TagName = string.sub(TagName, 2, -1);
			elseif (string.sub(TagName, 1, 1) == '!') then
				IsSpecial = true;
			--elseif (string.sub(String, ClosingTag - 1, ClosingTag - 1) == '/') then
			--	IsClosing = true;
			end
			local Element: PsuedoElement = {
				Name = TagName,
				AttributeString = AttributeString,
				Attributes = {}, -- Parse later
				Children = {},
				Value = "",
				Parent = StackTop
			};
			local Sections = StringUtil.SplitWhiteSpace(AttributeString);
			for _, Section in ipairs(Sections) do
				local EqualsSplit = string.split(Section, '=');
				if (#EqualsSplit == 2) then
					local Real = EqualsSplit[2];
					if (string.sub(EqualsSplit[2], 1, 1) == '"') then
						if (string.sub(EqualsSplit[2], -1, -1) == '"') then
							Real = string.sub(EqualsSplit[2], 2, -2);
						else
							errorf("Malformed attribute expression: %q", Section);
						end
					end
					local IsNumber = tonumber(Real);
					local IsBoolean = if Real == 'true' then true elseif Real == 'false' then false else nil;
					if (IsBoolean ~= nil) then
						Element.Attributes[EqualsSplit[1]] = IsBoolean;	
					else
						if (not IsNumber) then
							Element.Attributes[EqualsSplit[1]] = Real;
						else
							Element.Attributes[EqualsSplit[1]] = IsNumber;
						end
					end
				elseif (#EqualsSplit == 1) then
					Element.Attributes[EqualsSplit[1]] = true;
				else
					errorf("Malformed attribute expression: %q", Section);
				end
			end			
			
			if (IsClosing and not IsSpecial) then
				if (StackTop.Parent == StackTop) then
					errorf("%q Attempt to close out of document element.", Tag); -- TODO: Log line number
				end
				if (StackTop.Name ~= TagName) then
					warnf(("Closing tag '</%s>' attempted to close tag %q."):format(TagName, StackTop.Name)); -- TODO: Log line number
					while (StackTop.Parent ~= StackTop) do --! TODO: Check if this even works lmao
						StackTop = StackTop.Parent;
						if (StackTop.Name == TagName) then
							break;
						end
					end
				end
				StackTop = StackTop.Parent;				
			else
				StackTop.Children[#StackTop.Children + 1] = Element;
				if (not IsSpecial) then
					StackTop = Element;
					printf("Setting new top %q", StackTop.Name);
				end
				Skip = ClosingTag;
			end
			Skip = ClosingTag;
		else
			warn("Unreachable?");
		end
	end
	return Root;
end

return HTMLParser;
