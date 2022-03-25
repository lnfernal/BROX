--!strict

local Node = {};
local HTMLParser = require(script.Parent:WaitForChild("HTMLParser"));

function Node.__new():Node
	return setmetatable({
		nodeName = "#Node" :: string,
		childNodes = {} :: {Node},
		attributes = {} :: {[string]: boolean | number | string},
		value = "" ::string,
		parentNode = nil :: Node?
	}, { __index = Node });
end
export type Node = typeof(Node.__new());
function Node.fromPsuedo(Psuedo: HTMLParser.PsuedoElement): Node
	local node = Node.__new();
	node.nodeName = Psuedo.Name;
	node.value = Psuedo.Value;
	node.attributes = Psuedo.Attributes;
	node.childNodes = {};
	for _, child in ipairs(Psuedo.Children) do
		node.childNodes[#node.childNodes + 1] = Node.fromPsuedo(child);
		node.childNodes[#node.childNodes].parentNode = node;
	end	
	
	return node;
end

return Node;