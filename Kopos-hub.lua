--[[ 
    KOPOS HUB - ELITE v42.0 [STABLE EDITION]
    Incluye: Sliders, Checkpoints, ClickTP, ESP, Noclip.
]]

local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // LIMPIEZA DE UI ANTIGUA // --
if CoreGui:FindFirstChild("KoposHub") then CoreGui:FindFirstChild("KoposHub"):Destroy() end

-- // UI BASE // --
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "KoposHub"
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 400); Main.Position = UDim2.new(0.5, -150, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Main.Draggable = true; Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- // HEADER // --
local Header = Instance.new("Frame", Main); Header.Size = UDim2.new(1, 0, 0, 40); Header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)
local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(1, 0, 1, 0); Title.Text = "KOPOS HUB ELITE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.BackgroundTransparency = 1

-- // SCROLL CONTAINER // --
local Scroll = Instance.new("ScrollingFrame", Main); Scroll.Size = UDim2.new(1, -10, 1, -50); Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 2; Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 5)

-- // VARIABLES GLOBALES DE FUNCIONES // --
local NoclipEnabled = false
local ClickTPEnabled = false
local SavedCFrame = nil

-- // COMPONENTES // --
local function CreateBtn(text, func)
    local b = Instance.new("TextButton", Scroll); b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.Text = text; b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(func)
end

local function CreateToggle(text, callback)
    local t = false; local b = Instance.new("TextButton", Scroll); b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.Text = text; b.TextColor3 = Color3.fromRGB(200, 200, 200); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function() t = not t; b.BackgroundColor3 = t and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 50); callback(t) end)
end

local function CreateSlider(text, min, max, callback)
    local f = Instance.new("Frame", Scroll); f.Size = UDim2.new(1, 0, 0, 45); f.BackgroundColor3 = Color3.fromRGB(40, 40, 50); Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 20); l.Text = text; l.TextColor3 = Color3.fromRGB(255, 255, 255); l.BackgroundTransparency = 1
    local bar = Instance.new("Frame", f); bar.Size = UDim2.new(0.9, 0, 0, 6); bar.Position = UDim2.new(0.05, 0, 0.6, 0); bar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    local fill = Instance.new("Frame", bar); fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    
    local function move(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        callback(math.floor(min + (pos * (max - min))))
    end
    bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then move(input) end end)
end

-- // LÓGICA DE FEATURES // --
CreateSlider("Velocidad (WalkSpeed)", 16, 250, function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = v end end)
CreateSlider("Salto (JumpPower)", 50, 500, function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = v end end)

CreateToggle("Noclip", function(v) NoclipEnabled = v end)
CreateToggle("Click TP (Ctrl + Click)", function(v) ClickTPEnabled = v end)

CreateBtn("Guardar Checkpoint", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        SavedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        print("Checkpoint guardado")
    end
end)

CreateBtn("Ir al Checkpoint", function()
    if SavedCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SavedCFrame
    end
end)

-- // BUCLE DE PROCESAMIENTO // --
RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if ClickTPEnabled and input.UserInputType == Enum.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local pos = Mouse.Hit.Position
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        end
    end
end)

print("Kopos Hub Cargado Correctamente")

