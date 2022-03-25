--!strict

local Node = require(script.Parent:WaitForChild("Node"));
local CSS = require(script.Parent:WaitForChild("CSS"));
local Render = {};

local Instances = {
	h1 = "TextLabel",
	p = "TextLabel",
	body = "Frame"	,
	code = "TextLabel",
	pre = "TextLabel"
};

for i = 1, 6  do
	Instances["h"..tostring(i)] = "TextLabel";
end

function Render:RenderNode(Node: Node.Node)
	local Player = game.Players:GetPlayers()[1] or game.Players.PlayerAdded:Wait();
	local RootParent = Player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui");
	
	warn("Rendering");
	CSS:ConvertCSS([[
	h1 {
		font-size: 12px;
		width: fit-content;
		height: fit-content;
		background-color: transparent;
		color: rgb(46, 46, 46);
		padding: 6px;
	}
	code {
		font-family: Code;
		font-size: 14px;
		width: fit-content;
		height: fit-content;
		background-color: rgba(0, 0, 0, 0.15);
		color: black;
		padding: 6px;
		border-radius: 6px;
	}
	pre {
		font-family: Code;
		font-size: 12px;
		width: fit-content;
		height: fit-content;
		background-color: transparent;
		color: black;
		text-align: left;
		padding: 12px;
	}
	]]);
	
	local i = 0;
	local function Recurse(rNode: Node.Node, Parent: Instance)
		i += 1;
		local class = Instances[rNode.nodeName];
		if (class) then
			local new = Instance.new(class);
			print("New instance", class);
			if (class == "TextLabel") then
				new.Text = rNode.value;
			end
			CSS:ApplyStyle(new, rNode);
			new.Parent = Parent;
			new.LayoutOrder = i;
			Parent = new;
		end
		for _, v in pairs(rNode.childNodes) do
			Recurse(v, Parent);
		end
	end
	Recurse(Node, RootParent);
	print(Node);
end

return Render;