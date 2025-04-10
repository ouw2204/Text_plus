local Camera = workspace.CurrentCamera
local m = {}

function m.getPixelsPerStud(distanceFromCamera)
	local viewportSize = Camera.ViewportSize
	local fov = Camera.FieldOfView -- In degrees

	-- Calculate pixels per stud using FOV and distance
	local fovRad = math.rad(fov / 2) -- Half FOV in radians
	local screenHeightAtDistance = distanceFromCamera * math.tan(fovRad)
	local pixelsPerStud = (viewportSize.Y / 2) / screenHeightAtDistance

	local calibrationFactor = 4.3 / (((viewportSize.Y / 2) / (87 * math.tan(math.rad(70 / 2)))))
	pixelsPerStud = pixelsPerStud * calibrationFactor
	return pixelsPerStud
end

function m.getBillboardGuiScreenSize(Billboard: BillboardGui)
	if Billboard == nil then return end;
	local Part = Billboard.Adornee or Billboard.Parent;
	if Part == nil then return end;
	local CameraCFrame = Camera.CFrame;
	local Distance = math.max((CameraCFrame.Position-Part.Position).Magnitude,math.max(Billboard.Size.X.Scale,Billboard.Size.Y.Scale)); -- the only thing we want is the Y for text size
	local PixelsPerStud = m.getPixelsPerStud(Distance);
	local Size = Vector2.new(Billboard.Size.X.Scale*PixelsPerStud,Billboard.Size.Y.Scale*PixelsPerStud);
	return Size;
end
return m