function OnCollision(self, info)
  if info.ColliderType == "Entity" then
    if info.ColliderObject ~= nil then
      
      local requiredHits
      if (self:GetKey() == "blockBig") then
        requiredHits = 3
      else
        requiredHits = 1
      end
      
      self.hitCount = self.hitCount + 1
      
      --remove block after 2 hits
      if (self.hitCount >= requiredHits) then
        local rigidBody = self:GetComponentOfType("vHavokRigidBody")
        if rigidBody ~= nil then
          rigidBody:Remove()
          G.aliveBlocks = G.aliveBlocks - 1
        end
        self:SetVisible(false)
        local soundObject = Fmod:GetSound("blockdestroy")
        soundObject:Play(0, true)
      else
        local soundObject = Fmod:GetSound("blockhit")
        soundObject:Play(0, true)
      end
    end
  end
end

function OnAfterSceneLoaded(self)
  self.hitCount = 0
  G.aliveBlocks = G.aliveBlocks + 1
end
