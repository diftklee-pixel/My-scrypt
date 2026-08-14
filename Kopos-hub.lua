-- // KOPOS HUB - ELITE EDITION [RAYFIELD UI] // --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Kopos Hub | Elite Edition",
   LoadingTitle = "Cargando Kopos Hub...",
   LoadingSubtitle = "by Diftklee",
   ConfigurationSaving = { Enabled = true, FileName = "KoposHubConfig" },
   KeySystem = false
})

-- // TABS // --
local MainTab = Window:CreateTab("Movement", 4483362458)
local CombatTab = Window:CreateTab("Combat & Misc", 4483362458)

-- // VARIABLES // --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Mouse = LocalPlayer:GetMouse()
local SavedPos = nil

-- // MOVEMENT // --
MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 250},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

MainTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value)
      _G.Noclip = Value
      game:GetService('RunService').Stepped:Connect(function()
         if _G.Noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
               if v:IsA("BasePart") then v.CanCollide = false end
            end
         end
      end)
   end,
})

-- // MISC & TP // --
CombatTab:CreateButton({
   Name = "Guardar Checkpoint",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         SavedPos = LocalPlayer.Character.HumanoidRootPart.CFrame
         Rayfield:Notify({Title = "Checkpoint", Content = "Posición guardada!", Duration = 3})
      end
   end,
})

CombatTab:CreateButton({
   Name = "Teleportar a Checkpoint",
   Callback = function()
      if SavedPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = SavedPos
      end
   end,
})

CombatTab:CreateToggle({
   Name = "Click TP (Ctrl + Click)",
   CurrentValue = false,
   Callback = function(Value)
      _G.ClickTP = Value
      UserInputService.InputBegan:Connect(function(input, gpe)
         if gpe then return end
         if _G.ClickTP and input.UserInputType == Enum.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local pos = Mouse.Hit.Position
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
            end
         end
      end)
   end,
})

Rayfield:LoadConfiguration()
