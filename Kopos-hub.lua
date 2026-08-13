local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Interfaz Principal
local gui = Instance.new("ScreenGui")
gui.Name = "KoposHub"
gui.ResetOnSpawn = false

-- Asignación segura del Parent (evita fallos de permisos en Delta)
local setParentSuccess = pcall(function()
    gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
end)

if not setParentSuccess or not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

-- BOTÓN PERSISTENTE (Nunca se oculta)
local openButton = Instance.new("TextButton")
openButton.Name = "ToggleButton"
openButton.Size = UDim2.new(0, 130, 0, 40)
openButton.Position = UDim2.new(0, 20, 0, 20)
openButton.Text = "KOPOS HUB"
openButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Font = Enum.Font.SourceSansBold
openButton.TextSize = 15
openButton.Parent = gui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 8)
openCorner.Parent = openButton

-- VENTANA DEL MENÚ
local menu = Instance.new("Frame")
menu.Name = "MainFrame"
menu.Size = UDim2.new(0, 370, 0, 160)
menu.Position = UDim2.new(0, 20, 0, 70)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menu

-- Mostrar / Ocultar Menú
openButton.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    openButton.Text = menu.Visible and "CERRAR" or "KOPOS HUB"
end)

-- Botón Go To Sky
local skyButton = Instance.new("TextButton")
skyButton.Size = UDim2.new(1, -20, 0, 32)
skyButton.Position = UDim2.new(0, 10, 0, 10)
skyButton.Text = "Go To Sky (+100 Studs)"
skyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
skyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
skyButton.Font = Enum.Font.SourceSansBold
skyButton.TextSize = 14
skyButton.Parent = menu

local skyCorner = Instance.new("UICorner")
skyCorner.CornerRadius = UDim.new(0, 6)
skyCorner.Parent = skyButton

skyButton.MouseButton1Click:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    character:PivotTo(character:GetPivot() * CFrame.new(0, 100, 0))
end)

-- Divisor Vertical Central
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0, 2, 0, 80)
divider.Position = UDim2.new(0.5, -1, 0, 55)
divider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
divider.BorderSizePixel = 0
divider.Parent = menu

-- Creador de Sliders
local function createSlider(title, posX, posY, width, minVal, maxVal, defaultVal, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, width, 0, 20)
    label.Position = UDim2.new(0, posX, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = title .. ": " .. tostring(defaultVal)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Parent = menu

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, width, 0, 8)
    track.Position = UDim2.new(0, posX, 0, posY + 25)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    track.Parent = menu

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local knob = Instance.new("ImageButton")
    knob.Size = UDim2.new(0, 20, 0, 20)
    
    local initialPct = (defaultVal - minVal) / (maxVal - minVal)
    knob.Position = UDim2.new(initialPct, -10, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    knob.Parent = track

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local dragging = false

    local function updateInput(input)
        local posXTrack = track.AbsolutePosition.X
        local mouseX = input.Position.X
        local pct = math.clamp((mouseX - posXTrack) / track.AbsoluteSize.X, 0, 1)
        knob.Position = UDim2.new(pct, -10, 0.5, -10)
        
        local value = math.floor(minVal + (maxVal - minVal) * pct)
        label.Text = title .. ": " .. tostring(value)
        callback(value)
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input)
        end
    end)
end

local function getHumanoid()
    local character = player.Character or player.CharacterAdded:Wait()
    return character:FindFirstChildOfClass("Humanoid")
end

-- COLUMNA IZQUIERDA: Correr
createSlider("Correr", 15, 60, 150, 0, 1000, 16, function(value)
    local hum = getHumanoid()
    if hum then hum.WalkSpeed = value end
end)

-- COLUMNA DERECHA: Salto
createSlider("Salto", 205, 60, 150, 0, 1000, 50, function(value)
    local hum = getHumanoid()
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = value
    end
end)
