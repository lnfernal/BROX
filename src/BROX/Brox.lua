--!strict
local Parser = require(script.Parent:WaitForChild("HTMLParser"));
local Node = require(script.Parent:WaitForChild("Node"));
local Render = require(script.Parent:WaitForChild("Render"));

local Brox = {};

function Brox:RunTests()
	local Tests = require(script.Parent:WaitForChild("Tests"));
	local Parsed = (Parser:ParseString(Tests.Simple));
	Render:RenderNode(Node.fromPsuedo(Parsed));
	--print(Node.fromPsuedo(Parsed));
end

return Brox;