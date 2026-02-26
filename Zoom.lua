local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- ===== SETTINGS =====
local DEFAULT_FOV = 70
local MIN_FOV = 1   -- zoom gần nhất có thể
local MAX_FOV = 120

local savedFov = DEFAULT_FOV
local zoomingIn = false
local zoomingOut = false

-- ===== APPLY CAMERA =====
local function applyCamera()
	local cam = workspace.CurrentCamera
	if not cam then return end
	
	cam.FieldOfView = savedFov
	
	-- scale sensitivity theo zoom
	local scale = savedFov / DEFAULT_FOV
	UIS.MouseDeltaSensitivity = math.clamp(scale,0.05,1)
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	task.wait()
	applyCamera()
end)

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,180,0,55)
frame.Position = UDim2.new(0.5,-90,0.85,0)
frame.BackgroundTransparency = 0.25

local function makeButton(text,x)
	local b = Instance.new("TextButton",frame)
	b.Size = UDim2.new(0,60,1,0)
	b.Position = UDim2.new(0,x,0,0)
	b.TextScaled = true
	b.Text = text
	return b
end

local plus = makeButton("+",0)
local minus = makeButton("-",62)
local reset = makeButton("Reset",124)

-- ===== HOLD ZOOM SYSTEM =====
task.spawn(function()
	while true do
		task.wait()
		
		if zoomingIn then
			savedFov = math.max(MIN_FOV, savedFov - 0.8)
			applyCamera()
		end
		
		if zoomingOut then
			savedFov = math.min(MAX_FOV, savedFov + 0.8)
			applyCamera()
		end
	end
end)

-- giữ nút để zoom liên tục
plus.MouseButton1Down:Connect(function() zoomingIn = true end)
plus.MouseButton1Up:Connect(function() zoomingIn = false end)

minus.MouseButton1Down:Connect(function() zoomingOut = true end)
minus.MouseButton1Up:Connect(function() zoomingOut = false end)

reset.MouseButton1Click:Connect(function()
	savedFov = DEFAULT_FOV
	applyCamera()
end)

applyCamera()
