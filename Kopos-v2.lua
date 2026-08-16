local Players = game:GetService('Players')
local player = Players.LocalPlayer

function unlockAllItems()
    for _, item in pairs(game.ServerStorage.Items:GetChildren()) do
        if item:IsA('Tool') then
            local clone = item:Clone()
            clone.Parent = player.Backpack
        end
    end
end

unlockAllItems()
