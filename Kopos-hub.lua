--[[ 
    ===========================================================================
    KOPOS-HUB - ELITE MODERN EDITION v30.1 (CORREGIDO)
    THEME: HAJIME KASHIMO (GOD OF LIGHTNING) - ZIYA UI STYLE
    ===========================================================================
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- // 1. CORE ENGINE: KASHIMO LIGHTNING VFX // --
local function CreateLightningAura(obj)
    local aura = Instance.new("UIStroke", obj)
    aura.Color = Color3.fromRGB(0, 220, 255)
    aura.Thickness = 1.5
    aura.Transparency = 0.3
    task.spawn(function()
        while true do
            for i = 1, 10 do aura.Thickness = aura.Thickness + 0.15; task.wait(0.08) end
            for i = 1, 10 do aura.Thickness = aura.Thickness - 0.15; task.wait(0.08) end
        end
    end)
end

-- // 2. MAIN WINDOW SETUP // --
local gui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
gui.Name = "KoposHubElite"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 520, 0, 340)
main.Position = UDim2.new(0.5, -260, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.Visible = false
main.Draggable = true
CreateLightningAura(main)

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 10)

-- Top Header
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
topBar.BorderSizePixel = 0

local topCorner = Instance.new("UICorner", topBar)
topCorner.CornerRadius = UDim.new(0, 10)

local titleLbl = Instance.new("TextLabel", topBar)
titleLbl.Size = UDim2.new(1, -100, 1, 0)
titleLbl.Position = UDim2.new(0, 14, 0, 0)
titleLbl.Text = "⚡ Kopos Hub  |  Universal Edition"
titleLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 13
titleLbl.BackgroundTransparency = 1
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -36, 0, 2)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(160, 160, 180)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- // 3. CATEGORY SELECTOR // --
local catContainer = Instance.new("Frame", main)
catContainer.Size = UDim2.new(1, -20, 0, 36)
catContainer.Position = UDim2.new(0, 10, 0, 46)
catContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 28)

local catCorner = Instance.new("UICorner", catContainer)
catCorner.CornerRadius = UDim.new(0, 8)

local catLayout = Instance.new("UIListLayout", catContainer)
catLayout.FillDirection = Enum.FillDirection.Horizontal
catLayout.SortOrder = Enum.SortOrder.LayoutOrder
catLayout.Padding = UDim.new(0, 6)

local function createCategoryPill(name, defaultActive)
    local pill = Instance.new("TextButton", catContainer)
    pill.Size = UDim2.new(0, 95, 1, 0)
    pill.BackgroundColor3 = defaultActive and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(30, 30, 40)
    pill.Text = name
    pill.TextColor3 = defaultActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 170, 190)
    pill.Font = Enum.Font.GothamMedium
    pill.TextSize = 11
    
    local pCorner = Instance.new("UICorner", pill)
    pCorner.CornerRadius = UDim.new(0, 6)
    return pill
end

-- // 4. CONTENT AREA & PAGES // --
local contentArea = Instance.new("Frame", main)
contentArea.Size = UDim2.new(1, -20, 1, -95)
contentArea.Position = UDim2.new(0, 10, 0, 88)
contentArea.BackgroundTransparency = 1

local function createPage()
    local scroll = Instance.new("ScrollingFrame", contentArea)
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 2.2, 0)
    scroll.ScrollBarThickness = 3
    scroll.Visible = false
    
    local list = Instance.new("UIListLayout", scroll)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)
    return scroll
end

local pageMovement = createPage()
local pageCombat = createPage()
local pageVisuals = createPage()
local pageMisc = createPage()
pageMovement.Visible = true

local pill1 = createCategoryPill("Movement", true)
local pill2 = createCategoryPill("Combat", false)
local pill3 = createCategoryPill("Visuals", false)
local pill4 = createCategoryPill("Misc", false)

local function switchPage(activePill, targetPage)
    for _, p in pairs({pageMovement, pageCombat, pageVisuals, pageMisc}) do p.Visible = false end
    for _, pl in pairs({pill1, pill2, pill3, pill4}) do 
        pl.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        pl.TextColor3 = Color3.fromRGB(170, 170, 190)
    end
    activePill.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    activePill.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetPage.Visible = true
end

pill1.MouseButton1Click:Connect(function() switchPage(pill1, pageMovement) end)
pill2.MouseButton1Click:Connect(function() switchPage(pill2, pageCombat) end)
pill3.MouseButton1Click:Connect(function() switchPage(pill3, pageVisuals) end)
pill4.MouseButton1Click:Connect(function() switchPage(pill4, pageMisc) end)

-- // 5. UI COMPONENTS // --
local function addToggle(page, text, callback)
    local item = Instance.new("Frame", page)
    item.Size = UDim2.new(1, 0, 0, 38)
    item.BackgroundColor3 = Color3.fromRGB(25, 25, 33)

    local corner = Instance.new("UICorner", item)
    corner.CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", item)
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = true
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", item)
    toggleBtn.Size = UDim2.new(0, 42, 0, 22)
    toggleBtn.Position = UDim2.new(1, -48, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
    toggleBtn.Text = ""

    local tCorner = Instance.new("UICorner", toggleBtn)
    tCorner.CornerRadius = UDim.new(0, 11)

    local circle = Instance.new("Frame", toggleBtn)
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0, 2, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(160, 160, 180)

    local cCorner = Instance.new("UICorner", circle)
    cCorner.CornerRadius = UDim.new(0, 9)

    local active = false
    toggleBtn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            circle:TweenPosition(UDim2.new(1, -20, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
            circle.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
            circle:TweenPosition(UDim2.new(0, 2, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        end
        callback(active)
    end)
end

local function addButton(page, text, callback)
    local item = Instance.new("TextButton", page)
    item.Size = UDim2.new(1, 0, 0, 38)
    item.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
    item.Text = "  " .. text
    item.TextColor3 = Color3.fromRGB(220, 220, 230)
    item.Font = Enum.Font.GothamMedium
    item.TextSize = 12
    item.TextXAlignment = Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner", item)
    corner.CornerRadius = UDim.new(0, 6)

    local hint = Instance.new("TextLabel", item)
    hint.Size = UDim2.new(0, 60, 1, 0)
    hint.Position = UDim2.new(1, -65, 0, 0)
    hint.BackgroundTransparency = true
    hint.Text = "button"
    hint.TextColor3 = Color3.fromRGB(110, 110, 130)
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 11

    item.MouseButton1Click:Connect(callback)
end

-- // 6. POPULATE FUNCTIONS // --
-- Movement
addToggle(pageMovement, "Noclip Mode", function(v)
    local char = player.Character
    if char then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = not v end end
    end
end)
addButton(pageMovement, "Speed Boost (WalkSpeed 50)", function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = 50 end
end)
addButton(pageMovement, "Reset Speed (16)", function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = 16 end
end)
addButton(pageMovement, "Zero Gravity (50)", function() workspace.Gravity = 50 end)
addButton(pageMovement, "Reset Gravity (196.2)", function() workspace.Gravity = 196.2 end)

-- Combat
addToggle(pageCombat, "Expand Hitboxes (15x)", function(v)
    task.spawn(function()
        while v and task.wait(1) do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(15, 15, 15)
                    p.Character.HumanoidRootPart.Transparency = 0.7
                    p.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end)
end)

-- Visuals
addToggle(pageVisuals, "Player ESP Highlight", function(v)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if v then
                local h = Instance.new("Highlight", p.Character)
                h.Name = "KoposESP"
            else
                if p.Character:FindFirstChild("KoposESP") then p.Character.KoposESP:Destroy() end
            end
        end
    end
end)
addToggle(pageVisuals, "Anti-Lag Mode", function(v)
    Lighting.GlobalShadows = not v
    settings().Rendering.QualityLevel = v and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
end)

-- Misc
addButton(pageMisc, "Dance 1 Emote", function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local anim = Instance.new("Animation"); anim.AnimationId = "rbxassetid://507771019"
        player.Character.Humanoid:LoadAnimation(anim):Play()
    end
end)
addButton(pageMisc, "Stop All Animations", function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        for _, t in pairs(player.Character.Humanoid:GetPlayingAnimationTracks()) do t:Stop() end
    end
end)
addButton(pageMisc, "Rejoin Current Server", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

-- // 7. FLOATING TOGGLE BUTTON // --
local floatGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local openBtn = Instance.new("TextButton", floatGui)
openBtn.Size = UDim2.new(0, 44, 0, 44)
openBtn.Position = UDim2.new(0, 25, 0, 130)
openBtn.Text = "⚡"
openBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 20

local fCorner = Instance.new("UICorner", openBtn)
fCorner.CornerRadius = UDim.new(0, 22)

openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
