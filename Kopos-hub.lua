-- // KOPOS HUB - ELITE EDITION [PRO VERSION] // --
-- // CARACTERÍSTICAS: ESP, TP PLAYERS, CLICK TP, MOVEMENT // --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Kopos Hub | Elite Pro",
   LoadingTitle = "Cargando Kopos Hub...",
   LoadingSubtitle = "by Diftklee",
   ConfigurationSaving = { Enabled = true, FileName = "KoposConfig" },
   KeySystem = false
})

-- // TABS // --
local MainTab = Window:CreateTab("Movement", 4483362458)
local VisualsTab = Window:CreateTab("Visuals & Players", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Mouse = LocalPlayer:GetMouse()
local SavedPos = nil

-- // 1. MOVEMENT // --
MainTab:CreateSlider({
   Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16,
   Callback = function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = v end end
})

MainTab:CreateSlider({
   Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50,
   Callback = function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = v end end
})

MainTab:CreateToggle({
   Name = "Noclip", CurrentValue = false,
   Callback = function(v)
      _G.Noclip = v
      RunService.Stepped:Connect(function()
         if _G.Noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
               if v:IsA("BasePart") then v.CanCollide = false end
            end
         end
      end)
   end,
})

-- // 2. VISUALS & PLAYERS // --
-- ESP Toggle
VisualsTab:CreateToggle({
   Name = "Player ESP", CurrentValue = false,
   Callback = function(v)
      _G.ESP = v
      while _G.ESP do
         for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
               if not p.Character:FindFirstChild("KoposESP") then
                  local h = Instance.new("Highlight", p.Character)
                  h.Name = "KoposESP"
                  h.FillColor = Color3.fromRGB(0, 255, 255)
               end
            end
         end
         task.wait(1)
         for _, p in pairs(Players:GetPlayers()) do
             if p.Character and p.Character:FindFirstChild("KoposESP") and not _G.ESP then
                 p.Character.KoposESP:Destroy()
             end
         end
      end
      -- Cleanup
      for _, p in pairs(Players:GetPlayers()) do
          if p.Character and p.Character:FindFirstChild("KoposESP") then p.Character.KoposESP:Destroy() end
      end
   end,
})

-- TP to Player Dropdown
local PlayerList = {}
for _, p in pairs(Players:GetPlayers()) do table.insert(PlayerList, p.Name) end

local Dropdown = VisualsTab:CreateDropdown({
   Name = "Teleportar a Jugador",
   Options = PlayerList,
   Callback = function(Option)
      local Target = Players:FindFirstChild(Option)
      if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
      end
   end,
})

-- Refresh players button
VisualsTab:CreateButton({
   Name = "Actualizar Lista de Jugadores",
   Callback = function()
      PlayerList = {}
      for _, p in pairs(Players:GetPlayers()) do table.insert(PlayerList, p.Name) end
      Dropdown:Refresh(PlayerList, true)
   end,
})

-- // 3. MISC // --
MiscTab:CreateButton({
   Name = "Guardar Checkpoint",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         SavedPos = LocalPlayer.Character.HumanoidRootPart.CFrame
         Rayfield:Notify({Title = "Kopos Hub", Content = "Checkpoint Guardado!", Duration = 3})
      end
   end,
})

MiscTab:CreateButton({
   Name = "Ir al Checkpoint",
   Callback = function()
      if SavedPos then LocalPlayer.Character.HumanoidRootPart.CFrame = SavedPos end
   end,
})

MiscTab:CreateToggle({
   Name = "Click TP (Ctrl + Click)",
   CurrentValue = false,
   Callback = function(v)
      _G.ClickTP = v
      UserInputService.InputBegan:Connect(function(input, gpe)
         if not gpe and _G.ClickTP and input.UserInputType == Enum.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local pos = Mouse.Hit.Position
            if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) end
         end
      end)
   end,
})

Rayfield:LoadConfiguration()
