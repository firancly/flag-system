-- TeamModule.lua

local TeamModule = {}

function TeamModule.new(name, teamColor, autoAssignable)
	local teams = game:GetService("Teams")

	local team = Instance.new("Team", teams)
	team.Name = name
	team.TeamColor = BrickColor.new(teamColor)
	team.AutoAssignable = autoAssignable
	team:SetAttribute("Point", 0)

	return team
end

function TeamModule.setName(team, name)
	if team and typeof(name) == "string" then
		team.Name = name
	else
		warn("Invalid team or name.")
	end
end

function TeamModule.getName(team)
	if team then
		return team.Name
	else
		warn("Invalid team.")
		return nil
	end
end

function TeamModule.setPoints(team, points)
	if team and typeof(points) == "number" then
		local originalPoints = team:GetAttribute("Point") or 0
		originalPoints = originalPoints + points
		team:SetAttribute("Point", originalPoints)
	else
		warn("Invalid team or points.")
	end
end

function TeamModule.resetPoints(team, points)
	if team and typeof(points) == "number" then
		team:SetAttribute("Point", points)
	else
		warn("Invalid team or points.")
	end
end

function TeamModule.getPoints(team)
	if team then
		return team:GetAttribute("Point") or 0
	else
		warn("Invalid team.")
		return nil
	end
end

return TeamModule
