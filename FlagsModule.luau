-- FlagModule.lua

local FlagModule = {}

function FlagModule.new(flagName, owner, point)
	local flag = Instance.new("StringValue")
	flag.Name = flagName
	flag.Value = "Flag"
	flag:SetAttribute("Owner", owner or "Neutral")
	flag:SetAttribute("Point", point or 0)
	return flag
end

function FlagModule.getOwner(flag)
	if flag then
		return flag:GetAttribute("Owner")
	else
		warn("Invalid flag.")
		return nil
	end
end

function FlagModule.setOwner(flag, owner)
	if flag then
		flag:SetAttribute("Owner", owner)
	else
		warn("Invalid flag.")
	end
end

function FlagModule.getPoint(flag)
	if flag then
		return flag:GetAttribute("Point")
	else
		warn("Invalid flag.")
		return nil
	end
end

function FlagModule.setPoint(flag, point)
	if flag then
		flag:SetAttribute("Point", point)
	else
		warn("Invalid flag.")
	end
end

return FlagModule
