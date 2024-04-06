-- In your Globals.lua or any other Lua script file
function onLoad()
  -- Load the XML from an external file

end

-- This function should be in your Global.lua script

function toggleInitiativeMenu()
  local isActive = UI.getAttribute("initiativeMenu", "active") == "true"
  UI.setAttribute("initiativeMenu", "active", tostring(not isActive))
end

function openEnemyInitiaveMenu()
  local isActive = UI.getAttribute("enemyInitiativeMenu", "active") == "true"
  UI.setAttribute("enemyInitiativeMenu", "active", tostring(not isActive))
end

function toggleInitiativeList()
  local isActive = UI.getAttribute("initiativeListMenu", "active") == "true"
  UI.setAttribute("initiativeListMenu", "active", tostring(not isActive))
end

function toggleCooldownAdderMenu()
  local isActive = UI.getAttribute("AddCoolDownMenu", "active") == "true"
  UI.setAttribute("AddCoolDownMenu", "active", tostring(not isActive))
end

function registerPlayer(player, value, id)
  -- Placeholder for now; put registration logic here later
  print("Register Player button clicked")
end

function registerEnemy(player, value, id)
  -- Placeholder for now; put enemy initiative setting logic here later
  print("Set Enemy Initiative button clicked")
end

function closeInitiativeMenu()
  UI.setAttribute("initiativeMenu", "active", "false")
end

function closeInitiativeMenu2()
  UI.setAttribute("enemyInitiativeMenu", "active", "false")
end

function closeInitiativeMenu3()
  UI.setAttribute("AddCoolDownMenu", "active", "false")
end