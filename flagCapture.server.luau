local flag = workspace:WaitForChild("ZoneW")
local textLabel =
	flag:WaitForChild("LabelTeam"):WaitForChild("Billioard"):WaitForChild("entregarFrame"):WaitForChild("entregar")
local zone = flag:WaitForChild("Zone")
local captureTime = 5
local captureProgress = 0
local lastUpdateTime = 0
local charactersInZone = {}

local function updateTimer(deltaTime)
	for i = #charactersInZone, 1, -1 do
		local character = charactersInZone[i]
		if character and character:FindFirstChild("Humanoid") then
			local player = game.Players:GetPlayerFromCharacter(character)
			if player then
				captureProgress = captureProgress + deltaTime
				local screenLabel = player.PlayerGui
					:WaitForChild("PercentageDisplay")
					:WaitForChild("Percentage")
					:WaitForChild("TextLabel")

				textLabel.Text = string.format(
					"%s (Capturing: %.1f%%)",
					player.Name,
					math.min(captureProgress / captureTime * 100, 100)
				)
				screenLabel.Visible = true
				screenLabel.Text = string.format(
					"Cargando..." .. "%d/100",
					math.min(math.floor(captureProgress / captureTime * 100), 100)
				)

				if captureProgress >= captureTime then
					textLabel.Text = player.Name .. " (Capturado!)"
					textLabel.TextColor3 = player.TeamColor.Color
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

	if #charactersInZone == 0 then
		captureProgress = 0
	end

	textLabel.Text = player.Name
	textLabel.TextColor3 = player.TeamColor.Color

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
		textLabel.Text = "Uncaptured"
		textLabel.TextColor3 = Color3.new(1, 1, 1)
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
