local GetSize = require(script.Parent.Parent:WaitForChild("GetSize"));

local Block = {
	DisplayType = "block"
};

local function warnf(s, ...)
	warn(s:format(...));
end

function Block.new(Element)
	return setmetatable({
		Element = Element
	}, {__index = Block});
end

function Block:Compute() -- compute position of children
	local Last = self.Element.internal.Position;
	for i, child in ipairs(self.Element.childNodes) do
		local childDisplay = child.internal.Display;
		if (childDisplay) then
			local childSize = GetSize(child);
			print("SIZE: ", childSize);
			if (childDisplay.DisplayType == "block") then
				child.internal.Position = Last + Vector2.new(0, childSize.Y);
				print("Placed child at", child.internal.Position);
				Last = child.internal.Position;
			else
				warnf("Display %q doesn't know how to handle child display: %q", self.DisplayType, childDisplay.DisplayType);
			end
		else
			warn("No child display.");
		end
	end
end

return Block;