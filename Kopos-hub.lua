--[[ 
    ===========================================================================
    KOPOS-HUB - THE DEFINITIVE MASTER EDITION v25.0
    THEME: HAJIME KASHIMO (GOD OF LIGHTNING) - ULTIMATE CULLING GAME
    FEATURES: ESP | NOCLIP | HITBOX EXPANDER | CHECKPOINTS | ANTI-LAG | ANIMATIONS
    ===========================================================================
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- // 1. CORE ENGINE: KASHIMO LIGHTNING VFX // --
local function CreateLightningAura(obj)
    local aura = Instance.new("UIStroke", obj)
    aura.Color = Color3.fromRGB(0, 255, 255)
    aura.Thickness = 2
    aura.Transparency = 0.5
    task.spawn(function()
        while true do
            for i = 1, 10 do aura.Thickness = aura.Thickness + 0.2; task.wait(0.05) end
            for i = 1, 10 do aura.Thickness = aura.Thickness - 0.2; task.wait(0.05) end
        end
    end)
end

-- // 2. UI FACTORY // --
local gui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
gui.Name = "KoposHubGui"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 650, 0, 750)
main.Position = UDim2.new(0.5, -325, 0.5, -375)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
main.Visible = false
main.Draggable = true
CreateLightningAura(main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
title.Text = "⚡ KOPOS-HUB - GOD OF LIGHTNING ⚡"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- // 3. CONTAINER & GRID // --
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -90)
scroll.Position = UDim2.new(0, 10, 0, 60)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 15, 0)
scroll.ScrollBarThickness = 8

local layout = Instance.new("UIGridLayout", scroll)
layout.CellSize = UDim2.new(0, 190, 0, 60)
layout.CellPadding = UDim2.new(0, 10, 0, 10)

-- // 4. MODULES IMPLEMENTATION // --
local noclipEnabled = false
local noclipConnection
local function toggleNoclip(active)
    noclipEnabled = active
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end

local hitboxEnabled = false
local hitboxSize = 15
local hitboxConnection
local function toggleHitbox(active)
    hitboxEnabled = active
    if hitboxEnabled then
        hitboxConnection = RunService.RenderStepped:Connect(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        hrp.Transparency = 0.7
                        hrp.BrickColor = BrickColor.new("Cyan")
                        hrp.Material = Enum.Material.Neon
                        hrp.CanCollide = false
                    end
                end
            end
        end)
    else
        if hitboxConnection then hitboxConnection:Disconnect(); hitboxConnection = nil end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.Material = Enum.Material.Plastic
                end
            end
        end
    end
end

local tracking = false
local function toggleESP()
    tracking = not tracking
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if tracking then
                local h = Instance.new("Highlight", p.Character); h.Name = "KoposESP_H"
                local b = Instance.new("BillboardGui", p.Character.Head); b.Name = "KoposESP_N"; b.Size = UDim2.new(0, 100, 0, 50); b.AlwaysOnTop = true
                local n = Instance.new("TextLabel", b); n.Size = UDim2.new(1,0,1,0); n.Text = p.Name; n.TextColor3 = Color3.new(1,1,1); n.TextStrokeTransparency = 0; n.BackgroundTransparency = 1
            else
                if p.Character:FindFirstChild("KoposESP_H") then p.Character.KoposESP_H:Destroy() end
                if p.Character.Head:FindFirstChild("KoposESP_N") then p.Character.Head.KoposESP_N:Destroy() end
            end
        end
    end
end

local antiLagActive = false
local function toggleAntiLag(active)
    antiLagActive = active
    if active then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic end
        end
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        Lighting.GlobalShadows = true
    end
end

-- // 5. BUILD INTERFACE SECTIONS & BUTTONS // --
local function createSectionTitle(text)
    local lbl = Instance.new("TextLabel", scroll)
    lbl.Size = UDim2.new(1, 0, 0, 30)
    lbl.Text = "  " .. text
    lbl.TextColor3 = Color3.fromRGB(0, 255, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function createButton(name, color, callback)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(0, 190, 0, 50)
    btn.Text = name
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createSectionTitle("--- MOVEMENT & PHYSICS ---")
createButton("Speed Boost", Color3.fromRGB(52, 152, 219), function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 50
    end
end)
createButton("Default Speed", Color3.fromRGB(39, 174, 96), function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
end)
local noclipBtn = createButton("Toggle Noclip", Color3.fromRGB(230, 126, 34), function()
    toggleNoclip(not noclipEnabled)
    noclipBtn.Text = noclipEnabled and "Noclip: ON" or "Toggle Noclip"
    noclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(230, 126, 34)
end)
createButton("Zero Gravity", Color3.fromRGB(155, 89, 182), function()
    workspace.Gravity = 50
end)
createButton("Reset Gravity", Color3.fromRGB(192, 57, 43), function()
    workspace.Gravity = 196.2
end)

createSectionTitle("--- COMBAT & VISUALS ---")
local hitboxBtn = createButton("Expand Hitboxes", Color3.fromRGB(241, 196, 15), function()
    toggleHitbox(not hitboxEnabled)
    hitboxBtn.Text = hitboxEnabled and "Hitbox: 15x" or "Expand Hitboxes"
    hitboxBtn.BackgroundColor3 = hitboxEnabled and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(241, 196, 15)
end)
local espBtn = createButton("Toggle ESP", Color3.fromRGB(52, 152, 219), function()
    toggleESP()
    espBtn.Text = tracking and "ESP: ON" or "Toggle ESP"
    espBtn.BackgroundColor3 = tracking and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(52, 152, 219)
end)
local antiLagBtn = createButton("Toggle Anti-Lag", Color3.fromRGB(46, 204, 113), function()
    antiLagActive = not antiLagActive
    toggleAntiLag(antiLagActive)
    antiLagBtn.Text = antiLagActive and "Anti-Lag: ON" or "Toggle Anti-Lag"
    antiLagBtn.BackgroundColor3 = antiLagActive and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(46, 204, 113)
end)

createSectionTitle("--- EMOTES & ANIMATIONS ---")
createButton("Dance 1", Color3.fromRGB(155, 89, 182), function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://507771019"
        local track = player.Character.Humanoid:LoadAnimation(anim)
        track:Play()
    end
end)
createButton("Wave Emote", Color3.fromRGB(155, 89, 182), function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://507776043"
        local track = player.Character.Humanoid:LoadAnimation(anim)
        track:Play()
    end
end)
createButton("Stop All Anims", Color3.fromRGB(192, 57, 43), function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        for _, t in pairs(player.Character.Humanoid:GetPlayingAnimationTracks()) do t:Stop() end
    end
end)

-- // 6. LOGGING FOOTER // --
local logger = Instance.new("TextLabel", main)
logger.Size = UDim2.new(1, 0, 0, 30)
logger.Position = UDim2.new(0, 0, 1, -30)
logger.Text = "KOPOS-HUB READY - GOD OF LIGHTNING EDITION"
logger.TextColor3 = Color3.fromRGB(0, 255, 255)
logger.Font = Enum.Font.Code
logger.TextSize = 12
logger.BackgroundTransparency = 1

-- // 7. TOGGLE BUTTON // --
local toggleGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local openBtn = Instance.new("TextButton", toggleGui)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 50, 0, 50)
openBtn.Text = "⚡"
openBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 22

local toggleCorner = Instance.new("UICorner", openBtn)
toggleCorner.CornerRadius = UDim.new(0, 25)

openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
