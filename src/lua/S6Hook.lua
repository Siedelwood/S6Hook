--[[ S6Hook v0.1a  // by yoq ]]--
--[[ Changes by mcb          ]]--
--[[ Changes by Eisenmonoxid ]]--
--[[ Current Version: 1.0.4  ]]--

	-- "Documentation" by Eisenmonoxid ( If someone wants to do a actual documentation, feel free to do it ;) )
	--[[ 
		S6Hook.EMX_SetMaxStockSize(_entityID, _stockSize) 
			-> Sets the max stock size of a Entity
		S6Hook.EMX_GetMaxStockSize(_entityID) 
			-> Returns the current max stock size of a Entity
		S6Hook.EMX_SetMaxStoreStockSize(_storehouseID, _stockSize) 
			-> Sets the max stock size of the storehouse
		S6Hook.EMX_SetSettlerLimit(_limit) 
			-> Sets a new Settler Limit
		S6Hook.EMX_SetSoldierLimit(_limit) 
			-> Sets a new Soldier Limit
		S6Hook.EMX_SetSermonSettlerLimit(_limit) 
			-> Sets a new Sermon Settler Limit
		S6Hook.EMX_SetMaxBuildingEarnings(_earningsAmount) 
			-> Sets the new max amount of city buildings earnings
		S6Hook.EMX_SetFullBuildingCosts(_buildingType, _Good, _Amount, _Good, _Amount)
			-> Sets new building costs for a building, note that the last two parameters only work when
			   the building already had two goods as costs! Otherwise unexpected things will happen ;)
		S6Hook.EMX_GetTopMostArchive() 
			-> Returns the topmost archive that is currently loaded
		
		S6Hook.Alert(_string) 
			-> Shows a MessageWindow with the specified string
		S6Hook.Eval(_string) 
			-> Evaluates lua code provided as string
		S6Hook.Break() 
			-> Triggers an INT3 (Helpful for Debugging)
	]]--
	
	--[[
		--> Example:
		UseHookFunctions = function()
			if InstallS6Hook() then
				Logic.DEBUG_AddNote("Hook Installed!")
			else
				Logic.DEBUG_AddNote("Hook not Installed! Aborting ...")
				return;
			end
	
			local ID = GetID("Woodcutter") -- Scriptname of building that should be used
			S6Hook.Alert("ID of Building: "..tostring(ID))
			
			Logic.DEBUG_AddNote(S6Hook.EMX_GetMaxStockSize(ID))
			Logic.DEBUG_AddNote(S6Hook.EMX_SetMaxStockSize(ID, 35)) -- New max stock size is 35
			Logic.DEBUG_AddNote(S6Hook.EMX_GetMaxStockSize(ID))
	
			Logic.DEBUG_AddNote(S6Hook.EMX_SetMaxStoreStockSize(Logic.GetStoreHouse(1), 34567)) -- Should also work with all other "Storehouse" Buildings
			
			Logic.DEBUG_AddNote(S6Hook.EMX_GetTopMostArchive()) -- Topmost loaded archive on stack
			Logic.DEBUG_AddNote(S6Hook.EMX_SetSettlerLimit(353)) -- All 6 Levels are updated with this number
			Logic.DEBUG_AddNote(S6Hook.EMX_SetSermonSettlerLimit(32)) -- All 4 Levels are updated with this number
			Logic.DEBUG_AddNote(S6Hook.EMX_SetSoldierLimit(344)) -> All 4 Levels are updated with this number
			Logic.DEBUG_AddNote(S6Hook.EMX_SetMaxBuildingEarnings(554)) -> Sets new max earnings amount
			
			S6Hook.EMX_SetFullBuildingCosts(76, Goods.G_Grain, 15) -> 76 is B_Baths f.e.
		end
	--]]
	
function InstallS6Hook()
	if (nil == string.find(Framework.GetProgramVersion(), "1.71.4289")) or (Network.IsNATReady ~= nil) then
		-- No Patch 1.71 installed or History Edition
		return false;
	end

	local stage1 = "@@stage1.bin@@";
	local stage2 = "@@stage2.yx@@";
	local stage3 = "@@S6Hook.yx@@";
	
	local shrink = function(cc)
		local o, n, max = {}, 1, string.len(cc)
			while n <= max do
				local b = string.byte(cc, n)
				if b >= 97 then b=16*(b-97)+string.byte(cc, n+1)-97; n=n+2; else b=b-65; n=n+1; end
				table.insert(o, string.char(b))
			end
		return table.concat(o)
	end
	
	local eID = Logic.CreateEntity(Entities.A_Chicken, 0, 0, 0, 1)
	Framework.WriteToLog(stage1);
	Logic.SetEntityScriptingValue(eID, -81, 4706264)
	Logic.DestroyEntity(eID, shrink(stage2), shrink(stage3))
	
	return S6Hook ~= nil
end