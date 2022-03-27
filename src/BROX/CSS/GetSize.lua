
local function GetValue(Val)
	if (type(Val) == "table") then
		if (Val.type == "Unit") then
			return Val:GetPixels();
		else
			warn("Unknown table value type");
		end
	end
	return Val;
end

function CalculateFitContent(Element)
	print("called CalculateFitContent");
	local MinX:number, MinY:number,
		MaxX:number, MaxY: number = math.huge, math.huge,
																-math.huge, -math.huge;
	local function Recurse(childNode)
		if (childNode.parent.internal.Display) then
			childNode.parent.internal.Display:Compute();
		end
		local Position = childNode.internal.Position :: Vector2;
		local Size = childNode.internal.Instance:WaitForChild("__text").TextBounds;
		local BottomRight = Position + Size;

		MaxX = if (BottomRight.X > MaxX) then BottomRight.X else MaxX;
		MaxY = if (BottomRight.Y > MaxY) then BottomRight.Y else MaxY;
		MinY = if (BottomRight.X < MinX) then BottomRight.X else MaxX;
		MinY = if (BottomRight.Y > MinY) then BottomRight.Y else MaxY;

		MaxX = if (Position.X > MaxX) then Position.X else MaxX;
		MaxY = if (Position.Y > MaxY) then Position.Y else MaxY;
		MinY = if (Position.X < MinX) then Position.X else MaxX;
		MinY = if (Position.Y > MinY) then Position.Y else MaxY;

		for _, child in ipairs(childNode) do
			Recurse(child);
		end
	end
	if (#Element.childNodes == 0) then
		print("returning text bounds");
		return Element.internal.Instance:WaitForChild("__text").TextBounds;
	else
		for _, child in ipairs(Element.childNodes) do
			Recurse(child);
		end
	end
	return Vector2.new(MaxX - MinX, MaxY - MinY);
end

function GetSize(Element):Vector2
	task.wait();
	print("Called");
	local Width = Element.internal.Style.width or "fit-content";
	local Height = Element.internal.Style.height or "fit-content";
	Width, Height = GetValue(Width), GetValue(Height);

	local WidthN:number, HeightN:number = 0, 0;
	local FitContentCache: Vector2? = nil;
	if (type(Width) == "number") then
		WidthN = Width;
	elseif (Width == "fit-content") then
		FitContentCache = CalculateFitContent(Element);
		WidthN = FitContentCache.X;
	end
	if (type(Height) == "number") then
		HeightN = Height;
	elseif (Height == "fit-content") then
		if (not FitContentCache) then
			FitContentCache = CalculateFitContent(Element);
		end
		HeightN = FitContentCache.Y;
	end

	return Vector2.new(WidthN, HeightN);
end


return GetSize;