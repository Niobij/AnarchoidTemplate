function OnAfterSceneLoaded(self)
  self.map = Input:CreateMap("CameraMap")
  self.w, self.h = Screen:GetViewportSize()
  self.map:MapTrigger("X", {0, 0, self.w, self.h}, "CT_TOUCH_NORM_X")
  
  local ballEntity = Game:GetEntity("ball")
  self:AddObservedEntity(ballEntity)
end

function OnBeforeSceneUnloaded(self)
  local ballEntity = Game:GetEntity("ball")
  self:RemoveObservedEntity(ballEntity)
end

function OnObjectEnter(self, object)
  local rigidBody = object:GetComponentOfType("vHavokRigidBody")
  local paddleRB = self:GetChild(0):GetComponentOfType("vHavokRigidBody")
  if rigidBody ~= nil and paddleRB ~= nil then
    local vec1 = rigidBody:GetLinearVelocity()
    local vec2 = paddleRB:GetLinearVelocity()
    vec1.y = -vec1.y
    vec2 = vec2 * 0.5
    vec1 = vec1 + vec2
    vec1.z = 0
    vec1:normalize()
    rigidBody:SetLinearVelocity(vec1 * 4000)
    
    local soundObject = Fmod:GetSound("paddlehit")
    soundObject:Play(0, true)
  end
end

function OnThink(self)
  local movedelta = 2000; --movespeed
  local leftborder = -1190
  local rightborder = 690
  
  local x = self.map:GetTrigger("X")
  
  if (x > 0.5) or Input:IsKeyPressed(Vision.KEY_RIGHT) then
    vector = Vision.hkvVec3()
    vector.x = movedelta;
    self:IncPosition(vector * Timer:GetTimeDiff())
    local newpos = self:GetPosition();
    
    --check is not outside
    if (newpos.x >= rightborder) then
      newpos.x = rightborder
      self:SetPosition(newpos)
    end
    
  elseif (x > 0.0) or Input:IsKeyPressed(Vision.KEY_LEFT) then
    vector = Vision.hkvVec3()
    vector.x = -movedelta;
    self:IncPosition(vector * Timer:GetTimeDiff())
    local newpos = self:GetPosition();
    
    --check is not outside
    if (newpos.x <= leftborder) then
      newpos.x = leftborder
      self:SetPosition(newpos)
    end
  end 
end
