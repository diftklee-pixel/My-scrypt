--[[ 
    ===========================================================================
    KOPOS-HUB v31.0 - ELITE MODERN UI
    MEJORAS: TWEENS, DRAGGABLE SMOOTH, SLIDERS PRECISOS
    ===========================================================================
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- // UTILS // --
local function tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2), props):Play()
end

local function makeDraggable(gui)
    local dragging, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- // UI SETUP // --
local gui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
gui.Name = "KoposHub"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.Visible = true
main.ClipsDescendants = true
makeDraggable(main)

local corner = Instance.new("UICorner", main); corner.CornerRadius = UDim.new(0, 12)
local uiStroke = Instance.new("UIStroke", main); uiStroke.Color = Color3.fromRGB(0, 200, 255); uiStroke.Thickness = 2

-- // COMPONENTS FACTORY // --
local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20); label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Text = text; label.Font = Enum.Font.GothamMedium; label.TextSize = 12; label.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("Frame", frame)
    track.Size = UDim2.new(1, -20, 0, 6); track.Position = UDim2.new(0, 10, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 3)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)

    local button = Instance.new("TextButton", track)
    button.Size = UDim2.new(0, 12, 0, 12); button.Position = UDim2.new(0, -6, 0.5, -6)
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255); button.Text = ""
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

    local dragging = false
    button.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = mouse.X
            local trackPos = track.AbsolutePosition.X
            local trackSize = track.AbsoluteSize.X
            local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            button.Position = UDim2.new(percent, -6, 0.5, -6)
            local value = math.floor(min + (percent * (max - min)))
            callback(value)
        end
    end)
end

-- // MAIN PAGE // --
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -10, 1, -40); scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

-- // IMPLEMENTACIÓN // --
-- Velocidad
createSlider(scroll, "WalkSpeed", 16, 150, 16, function(v)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = v
    end
end)

-- Salto
createSlider(scroll, "JumpPower", 50, 1000, 50, function(v)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = v
    end
end)

-- Botón Cerrar
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "X"; close.TextColor3 = Color3.fromRGB(255, 50, 50); close.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() main.Visible = false end)

print("Kopos Hub v31 Cargado Correctamente")
