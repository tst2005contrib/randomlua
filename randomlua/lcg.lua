--[[------------------------------------
RandomLua v0.3.1
Pure Lua Pseudo-Random Numbers Generator
Under the MIT license.
copyright(c) 2017 linux-man
--]]------------------------------------

local math_floor = math.floor

local function normalize(n) --keep numbers at (positive) 32 bits
	return n % 0x80000000
end

local function bit_and(a, b)
	local r = 0
	local m = 0
	for m = 0, 31 do
		if (a % 2 == 1) and (b % 2 == 1) then r = r + 2^m end
		if a % 2 ~= 0 then a = a - 1 end
		if b % 2 ~= 0 then b = b - 1 end
		a = a / 2 b = b / 2
	end
	return normalize(r)
end

local function bit_or(a, b)
	local r = 0
	local m = 0
	for m = 0, 31 do
		if (a % 2 == 1) or (b % 2 == 1) then r = r + 2^m end
		if a % 2 ~= 0 then a = a - 1 end
		if b % 2 ~= 0 then b = b - 1 end
		a = a / 2 b = b / 2
	end
	return normalize(r)
end

local function bit_xor(a, b)
	local r = 0
	local m = 0
	for m = 0, 31 do
		if a % 2 ~= b % 2 then r = r + 2^m end
		if a % 2 ~= 0 then a = a - 1 end
		if b % 2 ~= 0 then b = b - 1 end
		a = a / 2 b = b / 2
	end
	return normalize(r)
end

local function seed()
	--return normalize(tonumber(tostring(os.time()):reverse()))
	return normalize(os.time())
end

--Linear Congruential Generator
local
linear_congruential_generator = {}
linear_congruential_generator.__index = linear_congruential_generator

function linear_congruential_generator:random(a, b)
	local y = (self.a * self.x + self.c) % self.m
	self.x = y
	if not a then return y / 0xffff
	elseif not b then
		if a == 0 then return y
		else return 1 + (y % a) end
	else
		return a + (y % (b - a + 1))
	end
end

function linear_congruential_generator:randomseed(s)
	if not s then s = seed() end
	self.x = normalize(s)
end

local
function lcg(s, r)
	local temp = {}
	setmetatable(temp, linear_congruential_generator)
	temp.a, temp.c, temp.m = 1103515245, 12345, 0x10000  --from Ansi C
	if r then
		if r == 'nr' then temp.a, temp.c, temp.m = 1664525, 1013904223, 0x10000 --from Numerical Recipes.
		elseif r == 'mvc' then temp.a, temp.c, temp.m = 214013, 2531011, 0x10000 end--from MVC
	end
	temp:randomseed(s)
	return temp
end

return lcg
