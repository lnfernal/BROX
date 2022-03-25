local function SplitWhiteSpace(String: string): {string}
	local Res = {}
	for substring in string.gmatch(String, "%S+") do
		Res[#Res + 1] = substring;
	end
	return Res;
end
local function IsSpace(s:string) return s:gsub("%s+", "") ~= s; end;
local function TrimAround(String: string)
	local L = 0;
	local R = 0;
	for i = 1, #String do
		if (IsSpace(string.sub(String, i, i))) then
			L += 1;
		else
			break;
		end
	end
	for i = #String, 1, -1 do
		if (IsSpace(string.sub(String, i, i))) then
			R += 1;
		else
			break;
		end
	end
	return string.sub(String, L + 1, -R - 1);
end
local function Trim(String: string): string
	local A = string.gsub(String, "%s+", " ");
	TrimAround(A);
	return A;
end

local function FindFirst(String:string, From:number, ...:string): number?
	--local FromString = string.sub(String, From, -1);
	local ToFind = {...};
	
	for i = From, #String do
		for _, Find in ipairs(ToFind) do
			if (string.sub(String, i, i) == Find) then
				return i;
			end
		end
	end	
	return nil;
end

local function FindFirstString(String:string, From:number, ...:string): number?
	local FromString = string.sub(String, From, -1);
	local ToFind = {...};
	for _, ToFind in ipairs(ToFind) do
		local Find = string.find(FromString, ToFind);
		if (Find) then
			return Find;
		end
	end
end

local function FindFirstBackwards(String:string, From:number, ...:string): number?
	--local FromString = string.sub(String, From, -1);
	local ToFind = {...};

	for i = From, 1, -1 do
		for _, Find in ipairs(ToFind) do
			if (string.sub(String, i, i) == Find) then
				return i;
			end
		end
	end	
	return nil;
end

return {
	SplitWhiteSpace = SplitWhiteSpace,
	IsSpace = IsSpace,
	TrimAround = TrimAround,
	Trim = Trim,
	FindFirst = FindFirst,
	FindFirstString = FindFirstString,
	FindFirstBackwards = FindFirstBackwards
};
