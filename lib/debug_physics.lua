local seed = 123
local rng = love.math.newRandomGenerator(seed)

local setColor
if love._version_major > 0 then
  function setColor(r, g, b, a)
    love.graphics.setColor(r/255, g/255, b/255, a and a/255)
  end
else
  setColor = love.graphics.setColor
end

local function drawFixture(fixture)
	local shape = fixture:getShape()
	local shapeType = shape:getType()
	
	if (fixture:isSensor()) then
		setColor(0,0,255,96)
	else
		setColor(rng:random(32,255),rng:random(32,255),rng:random(32,255),96)
	end
	
	if (shapeType == "circle") then
		local x,y = shape:getPoint()
		local radius = shape:getRadius()
		love.graphics.circle("fill",x,y,radius,15)
		setColor(0,0,0,255)
		love.graphics.circle("line",x,y,radius,15)
		local eyeRadius = radius/4
		setColor(0,0,0,255)
--		love.graphics.circle("fill",x,y-radius+eyeRadius,eyeRadius,10)
	elseif (shapeType == "polygon") then
		local points = {shape:getPoints()}
		love.graphics.polygon("fill",points)
		setColor(0,0,0,255)
		love.graphics.polygon("line",points)
	elseif (shapeType == "edge") then
		setColor(0,0,0,255)
		love.graphics.line(shape:getPoints())
	elseif (shapeType == "chain") then
		setColor(0,0,0,255)
		love.graphics.line(shape:getPoints())
	end
end

local function drawBody(body)
	local bx,by = body:getPosition()
	local bodyAngle = body:getAngle()
	
	love.graphics.push()
	love.graphics.translate(bx,by)
	love.graphics.rotate(bodyAngle)
	
	rng:setSeed(seed)
	
	local fixtures = body.getFixtures and body:getFixtures() or body:getFixtureList()
	for i=1,#fixtures do
		drawFixture(fixtures[i])
	end
	love.graphics.pop()
end

local drawnBodies = {}
local function debugWorldDraw_scissor_callback(fixture)
	drawnBodies[fixture:getBody()] = true
	return true --search continues until false
end

local function debugWorldDraw(world,topLeft_x,topLeft_y,width,height)
	love.graphics.push("all")
	drawnBodies = {}
	world:queryBoundingBox(topLeft_x,topLeft_y,topLeft_x+width,topLeft_y+height,debugWorldDraw_scissor_callback)
	
	love.graphics.setLineWidth(1)
	for body in pairs(drawnBodies) do
		drawnBodies[body] = nil
		drawBody(body)
	end
	
	setColor(0,255,0,255)
	love.graphics.setLineWidth(3)
	local joints = world.getJoints and world:getJoints() or world:getJointList()
	for i=1,#joints do
		local x1,y1,x2,y2 = joints[i]:getAnchors()
		if (x1 and x2) then
			love.graphics.line(x1,y1,x2,y2)
		else
			if (x1) then
				love.graphics.rectangle("fill",x1-1,y1-1,3,3)
			end
			if (x2) then
				love.graphics.rectangle("fill",x1-1,y1-1,3,3)
			end
		end
	end
	
	setColor(255,0,0,255)
	local contacts = world.getContacts and world:getContacts() or world:getContactList()
	for i=1,#contacts do
		local x1,y1,x2,y2 = contacts[i]:getPositions()
		if (x1) then
			love.graphics.rectangle("fill",x1-1,y1-1,3,3)
		end
		if (x2) then
			love.graphics.rectangle("fill",x2-1,y2-1,3,3)
		end
	end
	love.graphics.pop()
end

return debugWorldDraw