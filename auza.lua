--//=====================================================
--// RAUSENIA MINI TABS GUI (Teleport + More)
--//=====================================================

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local SavedPos = nil
local GodmodeOn = false
local NoclipOn = false

----------------------------------------------------------
-- GUI
----------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 170)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BackgroundTransparency = 0.1
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0,255,255)
stroke.Thickness = 2

----------------------------------------------------------
-- DRAG (PC + Mobile)
----------------------------------------------------------
local dragging = false
local dragStart, startPos

local function startDrag(input)
	dragging = true
	dragStart = input.Position
	startPos = main.Position
end

local function updateDrag(input)
	if dragging then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 
		or input.UserInputType == Enum.UserInputType.Touch then
		startDrag(input)
	end
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement 
		or input.UserInputType == Enum.UserInputType.Touch then
		updateDrag(input)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

----------------------------------------------------------
-- TAB SCROLL
----------------------------------------------------------
local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Size = UDim2.new(1, 0, 0, 40)
tabScroll.CanvasSize = UDim2.new(0, 400, 0, 0)
tabScroll.BackgroundTransparency = 1
tabScroll.ScrollBarThickness = 4
tabScroll.Parent = main

local tabLayout = Instance.new("UIListLayout", tabScroll)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

----------------------------------------------------------
-- CONTENT
----------------------------------------------------------
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundTransparency = 1
content.Parent = main

local tabs = {}

local function makeTab(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 120, 1, -10)
	btn.Text = name
	btn.Parent = tabScroll
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.TextSize = 14
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,1,0)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Parent = content

	tabs[name] = {button = btn, frame = frame}

	btn.MouseButton1Click:Connect(function()
		for _, t in pairs(tabs) do
			t.frame.Visible = false
			t.button.BackgroundColor3 = Color3.fromRGB(40,40,40)
		end
		frame.Visible = true
		btn.BackgroundColor3 = Color3.fromRGB(0,170,170)
	end)

	return frame
end

----------------------------------------------------------
-- TAB TELEPORT
----------------------------------------------------------
local tpTab = makeTab("TELEPORT")

local function makeBtn(parent, y, txt)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 200, 0, 40)
	b.Position = UDim2.new(0.5, -100, 0, y)
	b.Text = txt
	b.Parent = parent
	b.Font = Enum.Font.GothamBold
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.TextSize = 15
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	local s = Instance.new("UIStroke", b)
	s.Color = Color3.fromRGB(0,255,255)
	s.Thickness = 1.5
	return b
end

-- BUTTON: SET TELEPORT
local setBtn = makeBtn(tpTab, 10, "Set Teleport")
setBtn.MouseButton1Click:Connect(function()
	local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		SavedPos = hrp.Position
		setBtn.Text = "Saved ✔"
		task.wait(1)
		setBtn.Text = "Set Teleport"
	end
end)

-- BUTTON: TELEPORT
local tpBtn = makeBtn(tpTab, 60, "Teleport")
tpBtn.MouseButton1Click:Connect(function()
	local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if hrp and SavedPos then
		hrp.CFrame = CFrame.new(SavedPos)
	else
		tpBtn.Text = "No Pos ❌"
		task.wait(1)
		tpBtn.Text = "Teleport"
	end
end)

----------------------------------------------------------
-- TAB MORE
----------------------------------------------------------
local moreTab = makeTab("MORE")

local function makeToggle(parent, y, text)
	local tgl = Instance.new("TextButton")
	tgl.Size = UDim2.new(0, 200, 0, 40)
	tgl.Position = UDim2.new(0.5, -100, 0, y)
	tgl.Font = Enum.Font.GothamBold
	tgl.TextSize = 15
	tgl.BackgroundColor3 = Color3.fromRGB(50,50,50)
	tgl.TextColor3 = Color3.fromRGB(255,255,255)
	tgl.Text = text.." [OFF]"
	tgl.Parent = parent
	Instance.new("UICorner", tgl).CornerRadius = UDim.new(0,10)
	local s = Instance.new("UIStroke", tgl)
	s.Color = Color3.fromRGB(0,255,255)
	s.Thickness = 1.5
	return tgl
end

----------------------------------------------------------
-- GODMODE V3 FIX
----------------------------------------------------------
local function applyGodmode()
	local char = LP.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	-- FULL HEALTH LOOP
	task.spawn(function()
		while GodmodeOn and hum and hum.Health > 0 do
			hum.Health = hum.MaxHealth
			task.wait(0.1)
		end
	end)

	-- CHẶN DAMAGE
	hum:GetPropertyChangedSignal("Health"):Connect(function()
		if GodmodeOn and hum.Health < hum.MaxHealth then
			hum.Health = hum.MaxHealth
		end
	end)

	hum.BreakJointsOnDeath = false
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
end

local godBtn = makeToggle(moreTab, 10, "Godmode")
godBtn.MouseButton1Click:Connect(function()
	GodmodeOn = not GodmodeOn
	godBtn.Text = "Godmode ["..(GodmodeOn and "ON" or "OFF").."]"

	if GodmodeOn then
		applyGodmode()
	end
end)

LP.CharacterAdded:Connect(function()
	task.wait(1)
	if GodmodeOn then
		applyGodmode()
	end
end)

----------------------------------------------------------
-- NOCLIP FIX
----------------------------------------------------------
local noclipBtn = makeToggle(moreTab, 60, "Noclip")
noclipBtn.MouseButton1Click:Connect(function()
	NoclipOn = not NoclipOn
	noclipBtn.Text = "Noclip ["..(NoclipOn and "ON" or "OFF").."]"
end)

RunService.Stepped:Connect(function()
	if NoclipOn and LP.Character then
		for _, part in pairs(LP.Character:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

----------------------------------------------------------
-- Mặc định mở tab TELEPORT
----------------------------------------------------------
tabs["TELEPORT"].frame.Visible = true
tabs["TELEPORT"].button.BackgroundColor3 = Color3.fromRGB(0,170,170)
