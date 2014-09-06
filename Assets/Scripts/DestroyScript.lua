function OnObjectEnter(self, object)
  if (object:GetKey() == "ball") then
  
    local effect = Game:CreateEffect(object:GetPosition(), "Particles/explode.xml", "BallExplode")
    effect:SetScaling(3)
  
    local rigidBody = object:GetComponentOfType("vHavokRigidBody")
    if rigidBody ~= nil then
      rigidBody:SetLinearVelocity(Vision.hkvVec3())
      rigidBody:SetPosition(Vision.hkvVec3(-250, -1150, 150))
      
      G.lives = G.lives - 1
      G.mainMovie:Invoke("_root.SetNumberOfLives", G.lives)
      
      local soundObject = Fmod:GetSound("balldestroy")
      soundObject:Play(0, true)
      
      if G.lives == 0 then
        rigidBody:SetMotionType(Physics.MOTIONTYPE_FIXED)
      end
    end
  end
end