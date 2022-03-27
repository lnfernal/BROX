local UNIT_ENUM = {
	['px'] = 1,
	['%'] = 2,
	['em'] = 3,
	['rem'] = 4
};

local Unit = {
	type = "Unit"
};

function Unit.Parse(self: Unit)
	local String = self.UnitString;
	local UnitStringSize = 0;
	for i = #String, 1, -1 do
		if (string.match(string.sub(String, i, i), "%d") == nil) then
			UnitStringSize += 1;
		else
			break;
		end
	end
	local UnitType = string.sub(String, -UnitStringSize, -1);
	local Number = tonumber(string.sub(String, 1, if (#String == 3) then UnitStringSize - 1 else UnitStringSize)); -- dumb fix

	if (not Number) then
		warn("Unable to parse number from unit: " .. String .. "|" ..string.sub(String, 1, UnitStringSize));
		return 0;
	end
	if (UNIT_ENUM[UnitType]) then
		self.Unit = UnitType;
		self.Value = Number;
	else
		warn("Unknown unit '" .. UnitType .. "' using px.");
	end
end

function Unit.GetPixels(self: Unit)
	if (self.Unit == "px") then
		return self.Value;
	else
		error("TODO: Unimplemented");
	end
end

function Unit.fromString(UnitString:string):typeof(Unit.fromString("14px"))
	local self = setmetatable({
		UnitString = UnitString :: string,
		Value = 0 :: number,
		Unit = "px" :: string
	}, {__index = UnitString}) :: Unit;
	Unit:Parse();
	return self;
end
export type Unit = typeof(Unit.fromString("14px"));

return Unit;