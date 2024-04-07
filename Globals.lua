initiativeTable = {
  { name = "Scavenger",       initiative = 0.5 },
  { name = "Bile Spitter",    initiative = 0.5 },
  { name = "Pouncer",         initiative = 1.5 },
  { name = "Hunter",          initiative = 2.5 },
  { name = "Warrior",         initiative = 1.5 },
  { name = "Shrieker",        initiative = 4.5 },
  { name = "Nursing Spewer",  initiative = 2.5 },
  { name = "Bile Spewer",     initiative = 2.5 },
  { name = "Brood Commander", initiative = 2.5 },
  { name = "Hive Guard",      initiative = 2.5 },
  { name = "Stalker",         initiative = 4.5 },
  { name = "Charger",         initiative = 3.5 },
  { name = "Bile Titan",      initiative = 1.5 },
  { name = "Helldiver 1",     initiative = 1.0 }
}



currentInitiative = 0.0
currentTurn = 1
currentCharacterIndex = 1
cooldowns = {}

function addCooldown()
  -- Retrieve values from input fields directly
  local cooldownName = UI.getAttribute("cooldownName", "text")
  local cooldownDurationStr = UI.getAttribute("cooldownAmount", "text")
  
  -- Convert duration from string to number
  local cooldownDuration = tonumber(cooldownDurationStr)
  
  -- Debug print to console for debugging purposes
  print("Attempting to add cooldown: ", cooldownName, cooldownDurationStr)
  
  -- Validate input
  if not cooldownName or cooldownName == "" then
      print("Invalid cooldown name.")
      broadcastToAll("Invalid cooldown name.", {r=1, g=0, b=0})
      return
  end
  
  if not cooldownDuration or cooldownDuration <= 0 then
      print("Invalid cooldown duration.")
      broadcastToAll("Invalid cooldown duration.", {r=1, g=0, b=0})
      return
  end
  
  -- Calculate the expiry turn for the cooldown
  local expiryTurn = currentTurn + cooldownDuration
  
  -- Add the cooldown to a global table for management
  table.insert(cooldowns, {name = cooldownName, expires = expiryTurn})
  
  -- Optional: clear input fields for next use
  UI.setAttribute("cooldownName", "text", "")
  UI.setAttribute("cooldownAmount", "text", "")
  
  -- Update cooldown display
  refreshCooldownDisplay()
  
  print(cooldownName .. " cooldown added for " .. cooldownDuration .. " turns.")
end

function refreshCooldownDisplay()
  local cooldownText = "Cooldown Tracker:\n"
  local hasActiveCooldowns = false
  
  for _, cd in ipairs(cooldowns) do
    if cd.expires >= currentTurn then
      hasActiveCooldowns = true
      cooldownText = cooldownText .. cd.name .. " - Expires on Turn " .. cd.expires .. "\n"
    end
  end
  
  if not hasActiveCooldowns then
    cooldownText = cooldownText .. "No active cooldowns."
  end
  
  -- Update the UI element with the new display text
  UI.setAttribute("cooldownTrackerText", "text", cooldownText)
  -- Force a refresh on the UI in case it's not updating
  Wait.frames(function()
    UI.setValue("cooldownTrackerText", cooldownText)
  end, 1)
  
  -- Debugging: Print the updated display text to console
  print("Cooldown Tracker Updated: \n" .. cooldownText)
end


function increaseTurn()
  currentTurn = currentTurn + 1
  updateTurnDisplay() -- Update turn counter display

  -- Check and update cooldowns
  for i = #cooldowns, 1, -1 do
      if cooldowns[i].expires <= currentTurn then
          table.remove(cooldowns, i) -- Remove expired cooldowns
      end
  end

  refreshCooldownDisplay() -- Refresh the cooldown display
end



function sortInitiativeTable()
  table.sort(initiativeTable, function(a, b) return a.initiative > b.initiative end)
end


function displayCurrentInitiative()
  if initiativeTable[currentInitiativeIndex] then
      -- Assuming you have functions or a way to set UI elements, replace these with the actual function calls
      setUIText("TurnUserText", initiativeTable[currentInitiativeIndex].name)
      setUIText("InitiativeCounterText", tostring(initiativeTable[currentInitiativeIndex].initiative))
  end
end

function toggleInitiativeMenu()
  local isActive = UI.getAttribute("initiativeMenu", "active") == "true"
  UI.setAttribute("initiativeMenu", "active", tostring(not isActive))
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

function closeInitiativeMenu()
  UI.setAttribute("initiativeMenu", "active", "false")
end

function closeInitiativeMenu3()
  UI.setAttribute("AddCoolDownMenu", "active", "false")
end

function decreaseInitiative()
  if currentCharacterIndex < #initiativeTable then
      currentCharacterIndex = currentCharacterIndex + 1
  else
      -- When looping back to the start, increment the turn counter.
      currentCharacterIndex = 1
      increaseTurn()  -- Increment turn and update display.
  end
  updateUI()
end

function increaseInitiative()
  if currentCharacterIndex > 1 then
      currentCharacterIndex = currentCharacterIndex - 1
  else
      -- If adjusting logic to cycle in reverse and reach the beginning.
      currentCharacterIndex = #initiativeTable
      increaseTurn()  -- Increment turn and update display, assuming reverse cycle also indicates a new turn.
  end
  updateUI()
end



function updateUI()
  local currentCharacter = initiativeTable[currentCharacterIndex]
  if currentCharacter then
      -- Update the TurnUserText to show the current character's name.
      UI.setAttribute("TurnUserText", "text", currentCharacter.name)
      -- Update the InitiativeCounterText to show the current character's initiative value.
      UI.setAttribute("InitiativeCounterText", "text", "Initiative: " .. tostring(currentCharacter.initiative))
  else
      print("Error: No character at currentCharacterIndex or initiativeTable is empty.")
  end
end




function updateTurnDisplay()
  UI.setAttribute("TurnCounterText", "text", "Turn: " .. tostring(currentTurn))
end

function updateInitiativeDisplay()
  -- Assuming the initiative number is displayed in a Text element with id "InitiativeCounterText"
  UI.setAttribute("InitiativeCounterText", "text", "Initiative Number: " .. tostring(currentInitiative))
end

function refreshInitiativeList()
  -- Ensure the initiativeTable is sorted in the desired order
  table.sort(initiativeTable, function(a, b) return a.initiative > b.initiative end)

  -- Construct the XML elements for the initiative list
  local enemyElements = {}
  for i, enemy in ipairs(initiativeTable) do
      table.insert(enemyElements, {
          tag = "Text",
          attributes = {
              color = "#000000",
              fontSize = "16"
          },
          value = enemy.name .. ": Initiative " .. tostring(enemy.initiative)
      })
  end

  -- Prepare the new UI XML structure
  local newXml = {
      tag = "VerticalLayout",
      attributes = {
          id = "initiativeListContent",
          padding = "10",
          spacing = "5"
      },
      children = enemyElements
  }

  -- Replace the existing 'initiativeListContent' with the new structure
  local currentUIXmlTable = UI.getXmlTable()
  for i, panel in ipairs(currentUIXmlTable) do
      if panel.attributes.id == "initiativeListMenu" then
          for j, layout in ipairs(panel.children) do
              if layout.attributes.id == "initiativeListContent" then
                  panel.children[j] = newXml
                  break
              end
          end
          break
      end
  end

  -- Update the entire UI XML with the new structure
  UI.setXmlTable(currentUIXmlTable)
end



function getCharactersWithCurrentInitiative()
  local characters = {}
  for i, character in ipairs(initiativeTable) do
    if character.initiative == currentInitiative then
      table.insert(characters, character)
    end
  end
  return characters
end

function updateTurnUserLabel()
  local characters = getCharactersWithCurrentInitiative()
  if #characters > 0 then
    currentCharacterIndex = (currentCharacterIndex % #characters) + 1
    local currentCharacter = characters[currentCharacterIndex]
    UI.setAttribute("TurnUserText", "text", "Name: " .. currentCharacter.name)
  else
    UI.setAttribute("TurnUserText", "text", "Name: ")  -- If no characters found, clear the name label
  end
end


function handleInputChange(_, value, id)
  -- Update the text attribute of the input field with the new value
  UI.setAttribute(id, "text", value)
end

function handleInputChangeCooldown(_, value, id)
  -- Update the text attribute of the input field with the new value
  UI.setAttribute(id, "text", value)
end

function registerPlayer(player, value, id)
  local playerName = UI.getAttribute("playerNameInput", "text")
  local playerInitiativeStr = UI.getAttribute("initiativeInput", "text")

  -- Debug print to console for debugging purposes
  print("Attempting to register: ", playerName, playerInitiativeStr)

  -- Validate input for player name
  if not playerName or playerName == "" then
      print("Invalid character name. Please enter a character name.")
      broadcastToAll("Invalid character name. Please enter a character name.", {r=1, g=0, b=0})
      return
  end

  -- Validate input for initiative (must be a number)
  local playerInitiative = tonumber(playerInitiativeStr)
  if not playerInitiative or playerInitiative <= 0 then
      print("Invalid initiative. Please enter a valid initiative number.")
      broadcastToAll("Invalid initiative. Please enter a valid initiative number.", {r=1, g=0, b=0})
      return
  end

  -- Add the new character to the initiativeTable
  table.insert(initiativeTable, { name = playerName, initiative = playerInitiative })

  -- Sort the initiativeTable since we've added a new character
  sortInitiativeTable()

  -- Refresh the initiative list to show the new character
  refreshInitiativeList()

  -- Clear the input fields after successful registration
  UI.setAttribute("playerNameInput", "text", "")
  UI.setAttribute("initiativeInput", "text", "")

  print(playerName .. " has been added with initiative " .. playerInitiative)
end




function onLoad()
  if initiativeTable and #initiativeTable > 0 then
      sortInitiativeTable()
      currentCharacterIndex = 1  -- Start at the character with the highest initiative.
      updateUI()  -- Update the display for the first character.
      
      refreshInitiativeList()  -- Show sorted initiative list.
      updateTurnDisplay()  -- Show the initial turn.
  else
      print("Error: initiativeTable is not defined or empty.")
  end
end