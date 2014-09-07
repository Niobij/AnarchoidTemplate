function OnAfterSceneLoaded()
  if G.mainMovie == nil then
	  G.mainMovie = Scaleform:LoadMovie("Flash/mainmenu.gfx", 0, 0)
    if Application:GetPlatformName()== "WIN32DX9" then
      GUI:LoadResourceFile("GUI/MenuSystem.xml")
      GUI:SetCursorVisible(true)
      Scaleform:SetAbsoluteCursorPositioning(true)
    end
  end  
  
  G.mainMovie:Invoke("_root.OpenMainMenu")
end


function OnBeforeSceneUnloaded()
  if (Application:IsInEditor()) then
    GUI:SetCursorVisible(false)
    G.mainMovie = nil
	  Scaleform:UnloadAllMovies()
  end
end


-- movie: movie name; command: command string;
-- argTable: table with arguments, length: #argTable;
function OnExternalInterfaceCall(movie, command, argTable)
  if command == "startgame" then
    Debug:PrintLine("starting the game")
    Application:LoadScene("Scenes/Level01.vscene")
  end
end
