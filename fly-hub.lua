local Players = game:GetService("Players")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "FlyHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Botón principal
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 150, 0, 45)
openButton.Position = UDim2.new(0, 20, 0.5, -22)
openButton.Text = "☰ FLY HUB"
openButton.Parent = gui

-- Ventana
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 250, 0, 140)
menu.Position = UDim2.new(0, 20, 0.5, 30)
menu.Visible = false
menu.Parent = gui

-- Botón Go To Sky
local skyButton = Instance.new("TextButton")
skyButton.Size = UDim2.new(1, -20, 0, 50)
skyButton.Position = UDim2.new(0, 10, 0, 10)
skyButton.Text = "☁️ Go To Sky"
skyButton.Parent = menu

-- Abrir / cerrar
openButton.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- Subir 100 studs
skyButton.MouseButton1Click:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    character:PivotTo(
        character:GetPivot() + Vector3.new(0, 100, 0)
    )
end)
