--!strict

local Node = require(script.Parent:WaitForChild("Node"));
local CSS = require(script.Parent:WaitForChild("CSS"));
local Render = {};

type Node = Node.Node;
Color3.fromRGB()

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

function Render:CreateInstance(rNode: Node.Node)
	local Frame = Instance.new("Frame");
	Frame.Name = rNode.nodeName or "#Node";
	local Text = Instance.new("TextLabel");
	Text.Name = "__text";
	Text.Parent = Frame;
	if (rNode.value) then
		Text.Text = rNode.value;
	end
	rNode.internal.Instance = Frame;
	if (rNode.parentNode) then
		rNode.internal.Instance.Parent = rNode.parentNode.internal.Instance;
	end
end

function Render:RenderNode(Node: Node)
	local Player = game.Players:GetPlayers()[1] or game.Players.PlayerAdded:Wait();
	local RootParent = Player:WaitForChild("PlayerGui"):FindFirstChild("ScreenGui") or Instance.new("ScreenGui", Player.PlayerGui);

	warn("Rendering");
	--[[CSS:ConvertCSS([[
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
	\]\]);]]

	local function Recurse(rNode: Node, Parent: Instance, index: number)
		rNode.internal = {};
		rNode.internal.Style = {};
		rNode.internal.Size = Vector2.new();
		rNode.internal.Position = Vector2.new();
		self:CreateInstance(rNode);
		CSS:ApplyStyle(rNode);
		print("Applied style");
		print(rNode);
		rNode.internal.UpdateStyles();

		for i, v in ipairs(rNode.childNodes) do
			Recurse(v, Parent, i);
		end
	end
	Recurse(Node, RootParent, 0);

	Recurse = function(rNode: Node, Parent: Instance, index: number)
		print("!!");
		if (rNode.parentNode) then
			if (rNode.parentNode.internal.Display) then
				rNode.parentNode.internal.Display:Compute(); -- Update positions
			else
				warn("No display found for node parent.");
			end
			rNode.internal.Instance.Position = UDim2.fromOffset(rNode.internal.Position.X, rNode.internal.Position.Y);
		end
		for i, v in ipairs(rNode.childNodes) do
			Recurse(v, Parent, i);
		end
	end
	Recurse(Node, RootParent, 0);
	Node.internal.Instance.Parent = RootParent;
end

return Render;