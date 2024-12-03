local ProgressModule = {}

function ProgressModule.startProgressBar(player, flag, duration, callback)
	local progress = 0
	local increment = 1 / duration

	game:GetService("ReplicatedStorage").RemoteEvents.StartProgressBar:FireClient(player, true)

	local connection
	connection = game:GetService("RunService").Stepped:Connect(function(_, dt)
		if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (player.Character.HumanoidRootPart.Position - flag.Position).Magnitude
			if distance > 10 then
				connection:Disconnect()
				game:GetService("ReplicatedStorage").RemoteEvents.StartProgressBar:FireClient(player, false)
				if callback then callback(false) end
			else
				progress = progress + increment * dt
				game:GetService("ReplicatedStorage").RemoteEvents.UpdateProgressBar:FireClient(player, progress)
				if progress >= 1 then
					connection:Disconnect()
					game:GetService("ReplicatedStorage").RemoteEvents.StartProgressBar:FireClient(player, false)
					if callback then callback(true) end
				end
			end
		else
			connection:Disconnect()
			game:GetService("ReplicatedStorage").RemoteEvents.StartProgressBar:FireClient(player, false)
			if callback then callback(false) end
		end
	end)
end

return ProgressModule
