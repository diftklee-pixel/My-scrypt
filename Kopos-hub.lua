local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- INTERFAZ PRINCIPAL
local gui = Instance.new("ScreenGui")
gui.Name = "KoposHub"
gui.ResetOnSpawn = false

-- Asignación segura del Parent
local setParentSuccess = pcall(function()
    gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
end)
if not setParentSuccess or not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

-- BOTÓN PERSISTENTE (Circular, pequeño y arrastrable)
local openButton = Instance.new("TextButton")
openButton.Name = "ToggleButton"
openButton.Size = UDim2.new(0, 36, 0, 36)
openButton.Position = UDim2.new(0, 20, 0, 20)
openButton.Text = "K"
openButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Font = Enum.Font.SourceSansBold
openButton.TextSize = 16
openButton.Parent = gui

-- Esquinas redondeadas (Círculo perfecto)
local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openButton

-- LÓGICA DE ARRASTRE DEL BOTÓN CIRCULAR
local dragging = false
local dragStart, startPos

openButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = openButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        openButton.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- VENTANA DEL MENÚ (Tamaño ampliado para que quepan todos los botones)
local menu = Instance.new("Frame")
menu.Name = "MainFrame"
menu.Size = UDim2.new(0, 370, 0, 250)
menu.Position = UDim2.new(0, 20, 0, 70)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menu

-- Acción del botón circular (Abrir / Cerrar)
openButton.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    openButton.Text = menu.Visible and "✕" or "K"
end)

-- BOTÓN: GO TO SKY
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

-- DIVISOR CENTRAL
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0, 2, 0, 80)
divider.Position = UDim2.new(0.5, -1, 0, 55)
divider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
divider.BorderSizePixel = 0
divider.Parent = menu

-- FUNCIÓN CREADORA DE SLIDERS
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
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("ImageButton")
    knob.Size = UDim2.new(0, 20, 0, 20)
    local initialPct = (defaultVal - minVal) / (maxVal - minVal)
    knob.Position = UDim2.new(initialPct, -10, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local draggingKnob = false

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingKnob = true
        end
    end)

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingKnob = true
            local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            knob.Position = UDim2.new(pct, -10, 0.5, -10)
            local value = math.floor(minVal + (maxVal - minVal) * pct)
            label.Text = title .. ": " .. tostring(value)
            callback(value)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingKnob = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingKnob and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            knob.Position = UDim2.new(pct, -10, 0.5, -10)
            local value = math.floor(minVal + (maxVal - minVal) * pct)
            label.Text = title .. ": " .. tostring(value)
            callback(value)
        end
    end)
end

-- CREACIÓN DE SLIDERS (Correr / Salto)
createSlider("Correr", 15, 60, 150, 0, 1000, 16, function(value)
    local character = player.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
    end
end)

createSlider("Salto", 205, 60, 150, 0, 1000, 50, function(value)
    local character = player.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        local hum = character:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.JumpPower = value
    end
end)

-- BOTÓN: SUPER IMPULSO
local launchButton = Instance.new("TextButton")
launchButton.Size = UDim2.new(1, -20, 0, 35)
launchButton.Position = UDim2.new(0, 10, 0, 160)
launchButton.Text = "Super Impulso (Lanzar Personaje)"
launchButton.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
launchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
launchButton.Font = Enum.Font.SourceSansBold
launchButton.TextSize = 14
launchButton.Parent = menu

local launchCorner = Instance.new("UICorner")
launchCorner.CornerRadius = UDim.new(0, 6)
launchCorner.Parent = launchButton

launchButton.MouseButton1Click:Connect(function()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, 300, 0)
    end
end)

-- BOTÓN EXTRA DE OPCIONES
local actionButton = Instance.new("TextButton")
actionButton.Size = UDim2.new(1, -20, 0, 35)
actionButton.Position = UDim2.new(0, 10, 0, 205)
actionButton.Text = "Opciones de Jugador"
actionButton.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
actionButton.Font = Enum.Font.SourceSansBold
actionButton.TextSize = 14
actionButton.Parent = menu

local actionCorner = Instance.new("UICorner")
actionCorner.CornerRadius = UDim.new(0, 6)
actionCorner.Parent = actionButton

actionButton.MouseButton1Click:Connect(function()
    print("Menú de opciones abierto")
end)
