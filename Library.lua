local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Bảng màu chi tiết
local Theme = {
	Main = Color3.fromRGB(25, 25, 30),
	Header = Color3.fromRGB(20, 20, 25),
	Sidebar = Color3.fromRGB(30, 30, 35),
	Accent = Color3.fromRGB(0, 170, 255),
	Outline = Color3.fromRGB(50, 50, 55),
	Text = Color3.fromRGB(255, 255, 255),
	TextDark = Color3.fromRGB(160, 160, 165),
	Element = Color3.fromRGB(35, 35, 40),
	ElementHover = Color3.fromRGB(45, 45, 50)
}

-- Hàm tạo Tween nhanh
local function Ripple(obj)
	spawn(function()
		local Mouse = Player:GetMouse()
		local Circle = Instance.new("ImageLabel")
		Circle.Name = "Ripple"
		Circle.Parent = obj
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1
		Circle.Image = "rbxassetid://274574285"
		Circle.ImageColor3 = Color3.fromRGB(255, 255, 255)
		Circle.ImageTransparency = 0.8
		local TopX = Mouse.X - Circle.AbsolutePosition.X
		local TopY = Mouse.Y - Circle.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, TopX, 0, TopY)
		Circle.Size = UDim2.new(0, 0, 0, 0)
		
		Circle:TweenSizeAndPosition(UDim2.new(0, 200, 0, 200), UDim2.new(0, TopX - 100, 0, TopY - 100), "Out", "Quad", 0.5, false)
		for i = 1, 10 do
			Circle.ImageTransparency = 0.8 + (i * 0.02)
			task.wait(0.05)
		end
		Circle:Destroy()
	end)
end

-- Hàm Kéo thả mượt (Fix tuyệt đối)
local function MakeDraggable(topbarObject, object)
	local Dragging = false
	local DragInput, DragStart, StartPosition

	topbarObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarObject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			local Delta = input.Position - DragStart
			local targetPos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
			TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.OutQuad), {Position = targetPos}):Play()
		end
	end)
end

function Library:Window(titleText)
	local UI = {CurrentTab = nil, Tabs = {}}
	
	-- Root Gui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Gemini_V5_Ultimate"
	ScreenGui.Parent = (gethui and gethui()) or CoreGui
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- Notification Area
	local NotifyArea = Instance.new("Frame")
	NotifyArea.Name = "Notifications"
	NotifyArea.Size = UDim2.new(0, 280, 1, -20)
	NotifyArea.Position = UDim2.new(1, -290, 0, 10)
	NotifyArea.BackgroundTransparency = 1
	NotifyArea.Parent = ScreenGui
	
	local NotifyLayout = Instance.new("UIListLayout")
	NotifyLayout.Parent = NotifyArea
	NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NotifyLayout.Padding = UDim.new(0, 8)

	-- Main Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 650, 0, 420)
	MainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
	MainFrame.BackgroundColor3 = Theme.Main
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 12)
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = Theme.Outline
	MainStroke.Thickness = 1.5
	MainStroke.Parent = MainFrame

	-- Header
	local Header = Instance.new("Frame")
	Header.Name = "Header"
	Header.Size = UDim2.new(1, 0, 0, 45)
	Header.BackgroundColor3 = Theme.Header
	Header.BorderSizePixel = 0
	Header.Parent = MainFrame
	
	Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)
	MakeDraggable(Header, MainFrame)

	local Title = Instance.new("TextLabel")
	Title.Text = "   " .. tostring(titleText)
	Title.Size = UDim2.new(0.5, 0, 1, 0)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.GothamBold
	Title.TextColor3 = Theme.Text
	Title.TextSize = 18
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Header

	-- Tab Sidebar
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 160, 1, -45)
	Sidebar.Position = UDim2.new(0, 0, 0, 45)
	Sidebar.BackgroundColor3 = Theme.Sidebar
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = MainFrame

	local SideLayout = Instance.new("UIListLayout")
	SideLayout.Parent = Sidebar
	SideLayout.Padding = UDim.new(0, 6)
	SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local SidePadding = Instance.new("UIPadding")
	SidePadding.PaddingTop = UDim.new(0, 10)
	SidePadding.Parent = Sidebar

	-- Content Area
	local Container = Instance.new("Frame")
	Container.Name = "Container"
	Container.Size = UDim2.new(1, -170, 1, -55)
	Container.Position = UDim2.new(0, 165, 0, 50)
	Container.BackgroundTransparency = 1
	Container.Parent = MainFrame

	-- Hàm Notification chi tiết
	function UI:Notification(title, text, duration)
		local NFrame = Instance.new("Frame")
		NFrame.Size = UDim2.new(1, 0, 0, 70)
		NFrame.BackgroundColor3 = Theme.Header
		NFrame.Parent = NotifyArea
		
		Instance.new("UICorner", NFrame)
		Instance.new("UIStroke", NFrame).Color = Theme.Accent

		local NT = Instance.new("TextLabel")
		NT.Text = title
		NT.Size = UDim2.new(1, -20, 0, 30)
		NT.Position = UDim2.new(0, 10, 0, 5)
		NT.TextColor3 = Theme.Accent
		NT.Font = "GothamBold"
		NT.BackgroundTransparency = 1
		NT.TextXAlignment = "Left"
		NT.Parent = NFrame

		local ND = Instance.new("TextLabel")
		ND.Text = text
		ND.Size = UDim2.new(1, -20, 1, -30)
		ND.Position = UDim2.new(0, 10, 0, 25)
		ND.TextColor3 = Theme.Text
		ND.Font = "Gotham"
		ND.TextWrapped = true
		ND.BackgroundTransparency = 1
		ND.TextXAlignment = "Left"
		ND.Parent = NFrame

		NFrame.Position = UDim2.new(1, 10, 0, 0)
		TweenService:Create(NFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play()
		
		task.delay(duration or 4, function()
			TweenService:Create(NFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
			TweenService:Create(NT, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
			TweenService:Create(ND, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
			task.wait(0.5)
			NFrame:Destroy()
		end)
	end

	-- Hàm Transparency bậc cao
	function UI:SetTransparency(val)
		local t = val / 100
		MainFrame.BackgroundTransparency = t
		Header.BackgroundTransparency = t
		Sidebar.BackgroundTransparency = t
		MainStroke.Transparency = t
	end

	-- Tab System
	function UI:Tab(name, iconID)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Name = name .. "_Btn"
		TabBtn.Size = UDim2.new(0.9, 0, 0, 38)
		TabBtn.BackgroundColor3 = Theme.Element
		TabBtn.Text = "   " .. name
		TabBtn.Font = Enum.Font.GothamSemibold
		TabBtn.TextColor3 = Theme.TextDark
		TabBtn.TextSize = 14
		TabBtn.TextXAlignment = Enum.TextXAlignment.Left
		TabBtn.Parent = Sidebar
		
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

		local Page = Instance.new("ScrollingFrame")
		Page.Name = name .. "_Page"
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 3
		Page.ScrollBarImageColor3 = Theme.Accent
		Page.Parent = Container

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Parent = Page
		PageLayout.Padding = UDim.new(0, 10)
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
		end)

		TabBtn.MouseButton1Click:Connect(function()
			for _, t in pairs(Sidebar:GetChildren()) do
				if t:IsA("TextButton") then
					TweenService:Create(t, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Element, TextColor3 = Theme.TextDark}):Play()
				end
			end
			for _, p in pairs(Container:GetChildren()) do
				p.Visible = false
			end
			
			Page.Visible = true
			TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text}):Play()
			Ripple(TabBtn)
		end)

		if UI.CurrentTab == nil then
			UI.CurrentTab = Page
			Page.Visible = true
			TabBtn.BackgroundColor3 = Theme.Accent
			TabBtn.TextColor3 = Theme.Text
		end

		local Items = {}

		-- [1. Button]
		function Items:Button(text, callback)
			local BFrame = Instance.new("Frame")
			BFrame.Size = UDim2.new(1, -10, 0, 40)
			BFrame.BackgroundColor3 = Theme.Element
			BFrame.Parent = Page
			Instance.new("UICorner", BFrame)
			
			local B = Instance.new("TextButton")
			B.Text = text
			B.Size = UDim2.new(1, 0, 1, 0)
			B.BackgroundTransparency = 1
			B.Font = "Gotham"
			B.TextColor3 = Theme.Text
			B.Parent = BFrame
			
			B.MouseButton1Click:Connect(function()
				Ripple(BFrame)
				callback()
			end)
		end

		-- [2. Toggle]
		function Items:Toggle(text, default, callback)
			local Toggled = default
			local TFrame = Instance.new("Frame")
			TFrame.Size = UDim2.new(1, -10, 0, 40)
			TFrame.BackgroundColor3 = Theme.Element
			TFrame.Parent = Page
			Instance.new("UICorner", TFrame)

			local L = Instance.new("TextLabel")
			L.Text = "   " .. text
			L.Size = UDim2.new(1, 0, 1, 0)
			L.BackgroundTransparency = 1
			L.TextColor3 = Theme.Text
			L.Font = "Gotham"
			L.TextXAlignment = "Left"
			L.Parent = TFrame

			local Bg = Instance.new("Frame")
			Bg.Size = UDim2.new(0, 40, 0, 20)
			Bg.Position = UDim2.new(1, -50, 0.5, -10)
			Bg.BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(60,60,65)
			Bg.Parent = TFrame
			Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)

			local Ball = Instance.new("Frame")
			Ball.Size = UDim2.new(0, 16, 0, 16)
			Ball.Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
			Ball.BackgroundColor3 = Color3.new(1, 1, 1)
			Ball.Parent = Bg
			Instance.new("UICorner", Ball).CornerRadius = UDim.new(1, 0)

			local B = Instance.new("TextButton")
			B.Size = UDim2.new(1, 0, 1, 0)
			B.BackgroundTransparency = 1
			B.Text = ""
			B.Parent = TFrame
			
			B.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				TweenService:Create(Bg, TweenInfo.new(0.3), {BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(60,60,65)}):Play()
				TweenService:Create(Ball, TweenInfo.new(0.3), {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
				callback(Toggled)
			end)
		end

		-- [3. Slider]
		function Items:Slider(text, min, max, default, callback)
			local SFrame = Instance.new("Frame")
			SFrame.Size = UDim2.new(1, -10, 0, 50)
			SFrame.BackgroundColor3 = Theme.Element
			SFrame.Parent = Page
			Instance.new("UICorner", SFrame)

			local L = Instance.new("TextLabel")
			L.Text = "   " .. text
			L.Size = UDim2.new(1, 0, 0, 30)
			L.BackgroundTransparency = 1
			L.TextColor3 = Theme.Text
			L.Font = "Gotham"
			L.TextXAlignment = "Left"
			L.Parent = SFrame

			local V = Instance.new("TextLabel")
			V.Text = tostring(default) .. " "
			V.Size = UDim2.new(1, -10, 0, 30)
			V.BackgroundTransparency = 1
			V.TextColor3 = Theme.Accent
			V.Font = "GothamBold"
			V.TextXAlignment = "Right"
			V.Parent = SFrame

			local MainBar = Instance.new("Frame")
			MainBar.Size = UDim2.new(1, -30, 0, 6)
			MainBar.Position = UDim2.new(0, 15, 0, 35)
			MainBar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			MainBar.Parent = SFrame
			Instance.new("UICorner", MainBar)

			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
			Fill.BackgroundColor3 = Theme.Accent
			Fill.Parent = MainBar
			Instance.new("UICorner", Fill)

			local Dragging = false
			local function Update()
				local mPos = UserInputService:GetMouseLocation().X
				local bPos = MainBar.AbsolutePosition.X
				local bSize = MainBar.AbsoluteSize.X
				local percent = math.clamp((mPos - bPos) / bSize, 0, 1)
				Fill.Size = UDim2.new(percent, 0, 1, 0)
				local val = math.floor(min + (max - min) * percent)
				V.Text = tostring(val)
				callback(val)
			end

			SFrame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Dragging = true
					Update()
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Dragging = false
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					Update()
				end
			end)
		end

		-- [4. Dropdown]
		function Items:Dropdown(text, options, callback)
			local Expanded = false
			local DFrame = Instance.new("Frame")
			DFrame.Size = UDim2.new(1, -10, 0, 40)
			DFrame.BackgroundColor3 = Theme.Element
			DFrame.ClipsDescendants = true
			DFrame.Parent = Page
			Instance.new("UICorner", DFrame)

			local B = Instance.new("TextButton")
			B.Size = UDim2.new(1, 0, 0, 40)
			B.BackgroundTransparency = 1
			B.Text = "   " .. text .. " : ..."
			B.Font = "Gotham"
			B.TextColor3 = Theme.Text
			B.TextXAlignment = "Left"
			B.Parent = DFrame

			local List = Instance.new("Frame")
			List.Position = UDim2.new(0, 0, 0, 40)
			List.Size = UDim2.new(1, 0, 1, -40)
			List.BackgroundTransparency = 1
			List.Parent = DFrame
			Instance.new("UIListLayout", List)

			for _, opt in pairs(options) do
				local O = Instance.new("TextButton")
				O.Size = UDim2.new(1, 0, 0, 30)
				O.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
				O.BorderSizePixel = 0
				O.Text = opt
				O.Font = "Gotham"
				O.TextColor3 = Theme.TextDark
				O.Parent = List
				O.MouseButton1Click:Connect(function()
					B.Text = "   " .. text .. " : " .. opt
					Expanded = false
					DFrame:TweenSize(UDim2.new(1, -10, 0, 40), "Out", "Quad", 0.3)
					callback(opt)
				end)
			end

			B.MouseButton1Click:Connect(function()
				Expanded = not Expanded
				DFrame:TweenSize(Expanded and UDim2.new(1, -10, 0, 40 + (#options * 30)) or UDim2.new(1, -10, 0, 40), "Out", "Quad", 0.3)
			end)
		end

		-- [5. Paragraph]
		function Items:Paragraph(title, content)
			local PFrame = Instance.new("Frame")
			PFrame.BackgroundColor3 = Theme.Element
			PFrame.Size = UDim2.new(1, -10, 0, 60)
			PFrame.Parent = Page
			Instance.new("UICorner", PFrame)

			local T = Instance.new("TextLabel")
			T.Text = "   " .. title
			T.Size = UDim2.new(1, 0, 0, 30)
			T.TextColor3 = Theme.Accent
			T.Font = "GothamBold"
			T.BackgroundTransparency = 1
			T.TextXAlignment = "Left"
			T.Parent = PFrame

			local C = Instance.new("TextLabel")
			C.Text = "   " .. content
			C.Size = UDim2.new(1, -10, 1, -30)
			C.Position = UDim2.new(0, 0, 0, 25)
			C.TextColor3 = Theme.Text
			C.Font = "Gotham"
			C.TextWrapped = true
			C.BackgroundTransparency = 1
			C.TextXAlignment = "Left"
			C.TextYAlignment = "Top"
			C.Parent = PFrame
			
			PFrame.Size = UDim2.new(1, -10, 0, C.TextBounds.Y + 45)
		end

		return Items
	end

	return UI
end

return Library
