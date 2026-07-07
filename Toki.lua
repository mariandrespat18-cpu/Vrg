-- ================= NOTIFICACIÓN DE CARGA =================
local function showNotification()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "LoadNotificationGui"
	
	-- Alojar en CoreGui para mayor seguridad, o PlayerGui como plan B
	local success = pcall(function()
		screenGui.Parent = game:GetService("CoreGui")
	end)
	if not success then
		screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	end

	local textLabel = Instance.new("TextLabel")
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.Position = UDim2.new(0.5, 0, 0.85, 0) -- Centrado en la parte inferior de la pantalla
	textLabel.Size = UDim2.new(0, 350, 0, 50)
	textLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	textLabel.BackgroundTransparency = 0.3
	textLabel.BorderSizePixel = 0
	textLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 22
	textLabel.Text = "Script Cargado correctamente!"
	
	-- Bordes redondeados para que se vea estético
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = textLabel
	
	textLabel.Parent = screenGui

	-- Eliminar la notificación automáticamente después de 2 segundos
	task.delay(2, function()
		if screenGui then
			screenGui:Destroy()
		end
	end)
end

-- Ejecutar la notificación al instante
showNotification()

-- ================= ESP DE ANIMAL REPETITIVO E INDESTRUCTIBLE =================
local CoreGui = game:GetService("CoreGui")
local TargetAnimalName = "Bufalino Boomberino" -- Cambia esto por el animal que necesites
local TargetNameLower = string.lower(TargetAnimalName) -- Convertimos el objetivo a minúsculas para ignorar Mayúsculas

local activeTargets = {} 
local espFolder = Instance.new("Folder")
espFolder.Name = "SpecificAnimalESPFolder"

-- Alojar el ESP en una zona segura del executor para que el juego no lo borre
local success = pcall(function()
	espFolder.Parent = CoreGui
end)
if not success then
	-- Plan B por si el executor no soporta CoreGui
	espFolder.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local function getAnimalName(part)
	if not part or not part.Parent then return nil end
	local animalOverhead = part:FindFirstChild("AnimalOverhead")
	if not animalOverhead or not animalOverhead:IsA("SurfaceGui") then return nil end
	local displayNameLabel = animalOverhead:FindFirstChild("DisplayName")
	if not displayNameLabel then return nil end
	return displayNameLabel.Text
end

local function ensureESP(data, index)
	local part = data.part
	
	-- Si el símbolo no existe o fue eliminado de alguna forma, lo recreamos al instante
	if not data.esp or not data.esp.Parent then
		local billboardGui = Instance.new("BillboardGui")
		billboardGui.Name = "ESP_" .. tostring(index)
		billboardGui.Adornee = part -- Esto asegura que siga a la pieza pase lo que pase
		billboardGui.Size = UDim2.new(0, 50, 0, 50)
		billboardGui.StudsOffset = Vector3.new(0, 4, 0)
		billboardGui.AlwaysOnTop = true
		billboardGui.Parent = espFolder

		local symbolLabel = Instance.new("TextLabel")
		symbolLabel.Name = "Symbol"
		symbolLabel.Size = UDim2.new(1, 0, 1, 0)
		symbolLabel.BackgroundTransparency = 1
		symbolLabel.Text = "+"
		symbolLabel.TextStrokeTransparency = 0
		symbolLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		symbolLabel.Font = Enum.Font.GothamBlack
		symbolLabel.TextSize = 40
		symbolLabel.Parent = billboardGui

		data.esp = billboardGui
	end

	-- Lógica matemática para el patrón infinito (1-2 Rojo, 3-4 Verde, 5-6 Rojo, 7-8 Verde...)
	local pairIndex = math.ceil(index / 2)
	local isRed = (pairIndex % 2 ~= 0)

	local symbolLabel = data.esp:FindFirstChild("Symbol")
	if symbolLabel then
		if isRed then
			symbolLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Rojo
		else
			symbolLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Verde
		end
	end
end

-- Bucle principal que blinda el ESP
task.spawn(function()
	while task.wait(0.1) do
		local debris = workspace:FindFirstChild("Debris")
		if not debris then continue end

		-- 1. Escanear y registrar los animales nuevos
		for _, part in ipairs(debris:GetChildren()) do
			if part.Name == "FastOverheadTemplate" and part:IsA("BasePart") then
				local animalName = getAnimalName(part)
				-- Convertimos el nombre detectado a minúsculas y comparamos
				if animalName and string.lower(animalName) == TargetNameLower then
					local alreadyTracked = false
					for _, data in ipairs(activeTargets) do
						if data.part == part then
							alreadyTracked = true
							break
						end
					end
					
					-- Si es nuevo, lo añadimos al final de la fila
					if not alreadyTracked then
						table.insert(activeTargets, { part = part, esp = nil })
					end
				end
			end
		end

		-- 2. Limpiar los muertos/reiniciados y actualizar colores y posiciones
		local newActiveTargets = {}
		local currentIndex = 1

		for _, data in ipairs(activeTargets) do
			-- Comprobamos si la pieza sigue existiendo y mantiene el nombre ignorando mayúsculas/minúsculas
			local currentAnimalName = getAnimalName(data.part)
			
			if data.part and data.part.Parent and currentAnimalName and string.lower(currentAnimalName) == TargetNameLower then
				ensureESP(data, currentIndex)
				table.insert(newActiveTargets, data)
				currentIndex += 1
			else
				-- Si desapareció, borramos su ESP para liberar espacio
				if data.esp then
					pcall(function() data.esp:Destroy() end)
				end
			end
		end

		-- 3. Actualizamos la lista. Los que quedaron atrás suben de puesto automáticamente.
		activeTargets = newActiveTargets
	end
end)
