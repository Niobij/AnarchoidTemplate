G.useRemoteInput = false and (Application:GetPlatformName() == "WIN32DX9")

G.lives = 3
G.levels = {"Scenes/Level01.vscene", "Scenes/Level02.vscene", "Scenes/Level03.vscene", "Scenes/Level04.vscene"}
G.currentLevel = 1

function LoadLevel(levelNumber)
  G.currentLevel = levelNumber
  Application:LoadScene(G.levels[levelNumber])
end

function OnBeforeSceneLoaded()
  G.aliveBlocks = 0
end 

function OnAfterSceneLoaded()
  
  if G.useRemoteInput then
    RemoteInput:StartServer('RemoteGui')
    RemoteInput:InitEmulatedDevices()
  end

  local camShape = Game:GetEntity("camPosEntity")
  local mainCam = Game:GetCamera()
  mainCam:SetUseEulerAngles(true)
  mainCam:SetPosition(camShape:GetPosition())
  mainCam:SetOrientation(camShape:GetOrientation())
  
  G.won = false
  
  Debug:Enable(true)
  Debug:SetupLines(5,2)
  
  if G.mainMovie == nil then
  G.mainMovie = Scaleform:LoadMovie("Flash/mainmenu.gfx", 0, 0)
    if Application:GetPlatformName()== "WIN32DX9" then
      GUI:LoadResourceFile("GUI/MenuSystem.xml")
      GUI:SetCursorVisible(true)
      Scaleform:SetAbsoluteCursorPositioning(true)
    end
  end  
  
  G.mainMovie:Invoke("_root.OpenHUD")
end

function OnUpdateSceneBegin()

  if Input:IsKeyPressed(Vision.KEY_N) then
    G.aliveBlocks = 0
  end
  
  if G.aliveBlocks == 0 and G.won == false then
    G.won = true
    local ball = Game:GetEntity("ball")
    local ballRB = ball:GetComponentOfType("vHavokRigidBody")
    ball:SetPosition(-250, -1150, 150)
    ballRB:SetMotionType(Physics.MOTIONTYPE_FIXED)
  end
  
  if G.won == true then
    if G.currentLevel < table.getn(G.levels) then
      G.mainMovie:Invoke("_root.OpenNextLevelScreen")
    else
      G.mainMovie:Invoke("_root.OpenWonScreen")
    end
  end
  
  if G.lives == 0 then
    G.mainMovie:Invoke("_root.OpenGameOverScreen")
    G.lives = 3
  end
  
end

function OnBeforeSceneUnloaded()
  if G.useRemoteInput then
    RemoteInput:StopServer()
    RemoteInput:DeinitEmulatedDevices()
  end
  
  Timer:SetFrozen(false)
  
  if (Application:IsInEditor()) then
    GUI:SetCursorVisible(false)
    G.mainMovie = nil
	  Scaleform:UnloadAllMovies()
  end
end


-- movie: movie name; command: command string;
-- argTable: table with arguments, length: #argTable;
function OnExternalInterfaceCall(movie, command, argTable)
	if command == "freezegame" then
    Timer:SetFrozen(true)
  elseif command == "resumegame" then
    Timer:SetFrozen(false)
  elseif command == "mainmenu" then
    Application:LoadScene("Scenes/mainmenu.vscene")
  elseif command == "restartgame" then
    LoadLevel(1)
  elseif command == "nextlevel" then  
    LoadLevel(G.currentLevel + 1)
  end
  
end
