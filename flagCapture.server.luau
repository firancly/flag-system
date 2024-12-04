local flag = workspace:WaitForChild("ZoneW")
local textLabel =
	flag:WaitForChild("LabelTeam"):WaitForChild("Billioard"):WaitForChild("entregarFrame"):WaitForChild("entregar")
local textLabel2 =
	flag:WaitForChild("Label"):WaitForChild("Billioard"):WaitForChild("entregarFrame"):WaitForChild("entregar")

local zone = flag:WaitForChild("Zone")
local captureTime = 5
local captureProgress = 0
local charactersInZone = {}
local currentTeam = nil
local excludedTeamName = "Civil"

local function updateAllPlayersUI(newTeamName, teamColor)
	for _, player in ipairs(game.Players:GetPlayers()) do
		local playerGui = player.PlayerGui
		if playerGui then
			local percentageDisplay = playerGui:FindFirstChild("PercentageDisplay")
			if percentageDisplay then
				local teamUI = percentageDisplay:FindFirstChild("TeamUI")
				local zoneUI = percentageDisplay:FindFirstChild("Zone")

				if teamUI and teamUI:FindFirstChild("TextoEquipo") then
					teamUI.TextoEquipo.Text = newTeamName
					teamUI.TextoEquipo.TextColor3 = teamColor
				end

				if zoneUI and zoneUI:FindFirstChild("Texto") and zoneUI:FindFirstChild("UIStroke") then
					zoneUI.Texto.TextColor3 = teamColor
					zoneUI.UIStroke.Color = teamColor
				end
			end
		end
	end
end

local function updateTimer(deltaTime)
	for i = #charactersInZone, 1, -1 do
		local character = charactersInZone[i]
		if character and character:FindFirstChild("Humanoid") then
			local player = game.Players:GetPlayerFromCharacter(character)
			if player then
				if player.Team and player.Team.Name == excludedTeamName then
					return
				end

				if currentTeam == player.Team then
					return
				end

				captureProgress = captureProgress + deltaTime

				-- Percentage
				for _, p in ipairs(game.Players:GetPlayers()) do
					local screenLabel = p.PlayerGui
						:WaitForChild("PercentageDisplay")
						:WaitForChild("Percentage")
						:WaitForChild("TextLabel")

					screenLabel.Visible = true
					screenLabel.Text = string.format(
						"Cargando..." .. "%d/100",
						math.min(math.floor(captureProgress / captureTime * 100), 100)
					)
				end

				task.wait(1)

				-- Team name
				for _, p in ipairs(game.Players:GetPlayers()) do
					local screenLabel = p.PlayerGui
						:WaitForChild("PercentageDisplay")
						:WaitForChild("Percentage")
						:WaitForChild("TextLabel")
					screenLabel.Text = player.Team.Name
				end

				task.wait(2)

				-- Hide progress
				for _, p in ipairs(game.Players:GetPlayers()) do
					local screenLabel = p.PlayerGui
						:WaitForChild("PercentageDisplay")
						:WaitForChild("Percentage")
						:WaitForChild("TextLabel")
					screenLabel.Visible = false
				end

				if captureProgress >= captureTime then
					currentTeam = player.Team

					textLabel.Text = player.Team.Name
					textLabel.TextColor3 = player.TeamColor.Color
					textLabel2.TextColor3 = player.TeamColor.Color

					updateAllPlayersUI(player.Team.Name, player.TeamColor.Color)
				end
			end
		else
			table.remove(charactersInZone, i)
		end
	end
end

local function addCharacterToZone(character)
	if not character or not character:FindFirstChild("Humanoid") then
		return
	end

	local player = game.Players:GetPlayerFromCharacter(character)
	if not player then
		return
	end

	if player.Team and player.Team.Name == excludedTeamName then
		return
	end

	if #charactersInZone == 0 then
		captureProgress = 0
	end

	if not table.find(charactersInZone, character) then
		table.insert(charactersInZone, character)
	end
end

local function removeCharacterFromZone(character)
	local index = table.find(charactersInZone, character)
	if index then
		table.remove(charactersInZone, index)
	end

	if #charactersInZone == 0 then
		captureProgress = 0
	end
end

zone.Touched:Connect(function(hit)
	local character = hit.Parent
	if character:FindFirstChild("Humanoid") and not table.find(charactersInZone, character) then
		addCharacterToZone(character)
	end
end)

zone.TouchEnded:Connect(function(hit)
	local character = hit.Parent
	if table.find(charactersInZone, character) then
		removeCharacterFromZone(character)
	end
end)

game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
	updateTimer(deltaTime)
end)
