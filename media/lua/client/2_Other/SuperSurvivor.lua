
SuperSurvivor = {}
SuperSurvivor.__index = SuperSurvivor

SurvivorVisionCone = 0.90

function SuperSurvivor:new(isFemale,square)
	
	local o = {}	
	setmetatable(o, self)
	self.__index = self
	
	o.DebugMode = false
	o.NumberOfBuildingsLooted = 0
	o.AttackRange = 0.5
	o.UsingFullAuto = false
	o.GroupBraveryBonus = 0
	o.GroupBraveryUpdatedTicks = 0
	o.WaitTicks = 0
	o.TriggerHeldDown = false
	o.player = o:spawnPlayer(square, isFemale)
	o.userName = TextDrawObject.new()
	o.userName:setAllowAnyImage(true);
	o.userName:setDefaultFont(UIFont.Small);
	o.userName:setDefaultColors(255, 255, 255, 255);
	o.userName:ReadString(o.player:getForname())
	
	o.AmmoTypes = {}
	o.AmmoBoxTypes = {}
	o.LastGunUsed = nil
	o.LastMeleUsed = nil
	o.roundChambered = nil
	o.TicksSinceSpoke = 0
	o.JustSpoke = false
	o.SayLine1 = ""
	
	o.LastSurvivorSeen = nil
	o.LastMemberSeen = nil
	o.TicksAtLastDetectNoFood = 0
	o.NoFoodNear = false
	o.TicksAtLastDetectNoWater = 0
	o.NoWaterNear = false
	o.GroupRole = ""
	o.seenCount = 0
	o.dangerSeenCount = 0
	o.MyTaskManager = TaskManager:new(o)
	o.LastEnemeySeen = false
	o.Reducer = ZombRand(1,100)
	o.Container = false
	o.Room = false
	o.Building = false
	o.WalkingPermitted = true
	o.TargetBuilding = nil
	o.TargetSquare = nil
	o.Tree = false
	o.LastSquare = nil
	o.TicksSinceSquareChanged = 0
	o.StuckCount = 0
	o.EnemiesOnMe = 0
	o.BaseBuilding = nil
	o.BravePoints = 0
	o.Shirt = nil
	o.Pants = nil
	o.WasOnScreen = false
	
	o.PathingCounter = 0
	o.GoFindThisCounter = 0
	o.SpokeToRecently = {}
	o.SquareWalkToAttempts = {}
	o.SquaresExplored = {}
	o.SquareContainerSquareLooteds = {}
	for i=1, #LootTypes do o.SquareContainerSquareLooteds[LootTypes[i]] = {} end
	
	o:setBravePoints(SuperSurvivorBravery)
	local Dress = "RandomBasic"
	
	
	if(o.player:getPerkLevel(Perks.FromString("Aiming")) >= 3) then 
		local innerresult = ZombRand(1, 6)
		if(innerresult == 1) then
			Dress = "MarinesCamo"
			if(isModEnabled("Brita")) then
				o:giveWeapon("Brita.M16A3")
			else
				o:giveWeapon("Base.AssaultRifle")
			end
		elseif(innerresult == 2) then
			Dress = "ArmyCamo"
			if(isModEnabled("Brita")) then
				o:giveWeapon("Brita.SCARL")
			else
				o:giveWeapon("Base.AssaultRifle")
			end
		elseif(innerresult == 3) then
			Dress = "Army"
			if(isModEnabled("Brita")) then
				o:giveWeapon("Brita.M4A1")
			else
				o:giveWeapon("Base.AssaultRifle")
			end
		elseif(innerresult == 4) then
			Dress = "Guard"
			if(isModEnabled("Brita")) then
				o:giveWeapon("Brita.G18")
			else
				o:giveWeapon("Base.Pistol3")
			end
		else
			Dress = "Police"
			if(isModEnabled("Brita")) then
				o:giveWeapon("Brita.G18")
			else
				o:giveWeapon("Base.Pistol3")
			end
		end
	elseif(o.player:getPerkLevel(Perks.FromString("Doctor")) >= 3) then
		Dress = "Doctor"	
	elseif(o.player:getPerkLevel(Perks.FromString("Cooking")) >= 3) then
		Dress = "Chef"		
	elseif(o.player:getPerkLevel(Perks.FromString("Farming")) >= 3) then
		Dress = "Farmer"		
	end
		
	o:SuitUp(Dress)
	
	return o
end

function SuperSurvivor:newLoad(ID,square)
	
	local o = {}	
	setmetatable(o, self)
	self.__index = self
		
	o.AttackRange = 0.5
	o.UsingFullAuto = false
	o.GroupBraveryBonus = 0
	o.GroupBraveryUpdatedTicks = 0
	o.DebugMode = false
	o.NumberOfBuildingsLooted = 0
	o.WaitTicks = 0
	o.TriggerHeldDown = false
	o.player = o:loadPlayer(square,ID)
	o.userName = TextDrawObject.new()
	o.userName:setAllowAnyImage(true);
	o.userName:setDefaultFont(UIFont.Small);
	o.userName:setDefaultColors(255, 255, 255, 255);
	o.userName:ReadString(o.player:getForname())
	
	o.AmmoTypes = {}
	o.AmmoBoxTypes = {}
	o.LastGunUsed = nil
	o.LastMeleUsed = nil
	o.roundChambered = nil
	o.TicksSinceSpoke = 0
	o.JustSpoke = false
	o.SayLine1 = ""
		
	o.LastSurvivorSeen = nil
	o.LastMemberSeen = nil
	o.TicksAtLastDetectNoFood = 0
	o.NoFoodNear = false
	o.TicksAtLastDetectNoWater = 0
	o.NoWaterNear = false
	o.GroupRole = ""
	o.seenCount = 0
	o.dangerSeenCount = 0
	o.MyTaskManager = TaskManager:new(o)
	o.LastEnemeySeen = false
	o.Reducer = ZombRand(1,100)
	o.Container = false
	o.Room = false
	o.Building = false
	o.WalkingPermitted = true
	o.TargetBuilding = nil
	o.TargetSquare = nil
	o.Tree = false
	o.LastSquare = nil
	o.TicksSinceSquareChanged = 0
	o.StuckCount = 0
	o.EnemiesOnMe = 0
	o.BaseBuilding = nil
	o.BravePoints = 0
	o.Shirt = nil
	o.Pants = nil
	o.WasOnScreen = false
	
	o.GoFindThisCounter = 0
	o.PathingCounter = 0
	o.SpokeToRecently = {}
	o.SquareWalkToAttempts = {}
	o.SquaresExplored = {}
	o.SquareContainerSquareLooteds = {}
	for i=1, #LootTypes do o.SquareContainerSquareLooteds[LootTypes[i]] = {} end
	o:setBravePoints(SuperSurvivorBravery)
	
	
	
	return o
end

function SuperSurvivor:newSet(player)
	
	local o = {}	
	setmetatable(o, self)
	self.__index = self
		
	o.AttackRange = 0.5
	o.UsingFullAuto = false
	o.DebugMode = false
	o.NumberOfBuildingsLooted = 0
	o.GroupBraveryBonus = 0
	o.GroupBraveryUpdatedTicks = 0
	o.AmmoTypes = {}
	o.AmmoBoxTypes = {}
	o.LastGunUsed = nil
	o.LastMeleUsed = nil
	o.roundChambered = nil
	o.TriggerHeldDown = false
	o.TicksSinceSpoke = 0
	o.JustSpoke = false
	o.SayLine1 = ""
	
	o.GoFindThisCounter = 0
	o.PathingCounter = 0
	o.player = player
	o.WaitTicks = 0
	o.LastSurvivorSeen = nil
	o.LastMemberSeen = nil
	o.TicksAtLastDetectNoFood = 0
	o.NoFoodNear = false
	o.TicksAtLastDetectNoWater = 0
	o.NoWaterNear = false
	o.GroupRole = ""
	o.seenCount = 0
	o.dangerSeenCount = 0
	o.MyTaskManager = TaskManager:new(o)
	o.LastEnemeySeen = false
	o.Reducer = ZombRand(1,100)
	o.Container = false
	o.Room = false
	o.Building = false
	o.WalkingPermitted = true
	o.TargetBuilding = nil
	o.TargetSquare = nil
	o.Tree = false
	o.LastSquare = nil
	o.TicksSinceSquareChanged = 0
	o.StuckCount = 0
	o.EnemiesOnMe = 0
	o.BaseBuilding = nil
	o.SquareWalkToAttempts = {}
	o.SquaresExplored = {}
	o.SpokeToRecently = {}
	o.SquareContainerSquareLooteds = {}
	for i=1, #LootTypes do o.SquareContainerSquareLooteds[LootTypes[i]] = {} end
	
	o:setBravePoints(SuperSurvivorBravery)
	
	return o
end
function SuperSurvivor:Wait(ticks)
 self.WaitTicks = ticks
end

function SuperSurvivor:isInBase()

	if(self:getGroupID() == nil) then return false
	else
		local group = SSGM:Get(self:getGroupID())
		if(group) then
			return group:IsInBounds(self:Get())
		end
	end
	return false
end

function SuperSurvivor:getBaseCenter()

	if(self:getGroupID() == nil) then return false
	else
		local group = SSGM:Get(self:getGroupID())
		if(group) then
			return group:getBaseCenter()
		end
	end
	return nil
end


function SuperSurvivor:getGroupBraveryBonus()

	if(self.GroupBraveryUpdatedTicks % 5 == 0) then

		if(self:getGroupID() == nil) then return 0 end
		local group = SSGM:Get(self:getGroupID())
		if(group) then self.GroupBraveryBonus = group:getMembersThisCloseCount(12, self:Get()) 
		else self.GroupBraveryBonus = 0 end
	else
		self.GroupBraveryUpdatedTicks = self.GroupBraveryUpdatedTicks + 1
	end
	return self.GroupBraveryBonus
end

function SuperSurvivor:isInGroup(thisGuy)

	if(self:getGroupID() == nil) then return false
	elseif(thisGuy:getModData().Group == nil) then return false
	elseif (thisGuy:getModData().Group == self:getGroupID()) then return true
	else return false end

end
function SuperSurvivor:isGroupless(thisGuy)

	if(thisGuy:getModData().Group == nil) then return false
	else return true end

end
function SuperSurvivor:getX()
	return self.player:getX()
end
function SuperSurvivor:getY()
	return self.player:getY()
end
function SuperSurvivor:getZ()
	return self.player:getZ()
end
function SuperSurvivor:getCurrentSquare()
	return self.player:getCurrentSquare()
end
function SuperSurvivor:getModData()
	return self.player:getModData()
end
function SuperSurvivor:getName()
	return self.player:getModData().Name
end

function SuperSurvivor:refreshName()
	if(self.player:getModData().Name ~= nil) then self:setName(self.player:getModData().Name) end
end

function SuperSurvivor:setName(nameToSet)
	
	local desc = self.player:getDescriptor()
	desc:setForename(nameToSet)
	desc:setSurname("")	
	self.player:setForname(nameToSet);
	self.player:setDisplayName(nameToSet);
	if(self.userName) then self.userName:ReadString(nameToSet) end
	
	self.player:getModData().Name = nameToSet
	self.player:getModData().NameRaw = nameToSet
end

function SuperSurvivor:renderName()

	if (not self.userName) or ((not self.JustSpoke) and ((not self:isInCell()) or (self:Get():getAlpha() ~= 1.0) or getSpecificPlayer(0)==nil or (not getSpecificPlayer(0):CanSee(self.player)))) then return false end
	
	if(self.JustSpoke == true) and (self.TicksSinceSpoke == 0) then
		self.TicksSinceSpoke = 250		
		self.userName:ReadString(self.player:getForname() .."\n" .. self.SayLine1)
	elseif(self.TicksSinceSpoke > 0) then
		self.TicksSinceSpoke = self.TicksSinceSpoke - 1
		if(self.TicksSinceSpoke == 0) then
			self.userName:ReadString(self.player:getForname() );
			self.JustSpoke = false
			self.SayLine1 = ""
		end	
	end
		
	local sx = IsoUtils.XToScreen(self:Get():getX(), self:Get():getY(), self:Get():getZ(), 0);
	local sy = IsoUtils.YToScreen(self:Get():getX(), self:Get():getY(), self:Get():getZ(), 0);
	sx = sx - IsoCamera.getOffX() - self:Get():getOffsetX();
	sy = sy - IsoCamera.getOffY() - self:Get():getOffsetY();

	sy = sy - 128

	sx = sx / getCore():getZoom(0)
	sy = sy / getCore():getZoom(0)

	sy = sy - self.userName:getHeight()

	self.userName:AddBatchedDraw(sx, sy, true)

end

function SuperSurvivor:SpokeTo(playerID)

	self.SpokeToRecently[playerID] = true

end
function SuperSurvivor:getSpokeTo(playerID)

	if(self.SpokeToRecently[playerID] ~= nil) then return true
	else return false end

end

function SuperSurvivor:reload()
	local cs = self.player:getCurrentSquare()
	local id = self:getID()
	self:delete()
	self.player = self:spawnPlayer(cs,nil)
	self:loadPlayer(cs,id)
end

function SuperSurvivor:loadPlayer(square, ID)
	-- load from file if save file exists
	
	if (ID ~= nil) and (checkSaveFileExists("Survivor"..tostring(ID))) then
		
		local BuddyDesc = SurvivorFactory.CreateSurvivor();
		--local realplayer = getSpecificPlayer(0);
		local Buddy = IsoPlayer.new(getWorld():getCell(),BuddyDesc,square:getX(),square:getY(),square:getZ());
		--IsoPlayer.setInstance(Buddy);
		--Buddy:update();
		--IsoPlayer.setInstance(realplayer);
		Buddy:getInventory():emptyIt();
		local filename = getSaveDir() .. "Survivor"..tostring(ID);
		Buddy:load( filename );
		
		Buddy:setX(square:getX())
		Buddy:setY(square:getY())
		Buddy:setZ(square:getZ())
		Buddy:getModData().ID = ID
		Buddy:setNPC(true);
		Buddy:setBlockMovement(true)
		Buddy:setSceneCulled(false)
		--Buddy:dressInRandomOutfit()
		--Buddy:dressInNamedOutfit(Buddy:getRandomDefaultOutfit())
		
		
		
		print("loading survivor " .. tostring(ID) .. " from file")
		return Buddy
	else
		print("save file for survivor " .. tostring(ID) .. " does not exist")
	end
	

end

function SuperSurvivor:WearThis(ClothingItemName) -- should already be in inventory

	local ClothingItem
	if(instanceof(ClothingItemName,"InventoryItem")) then ClothingItem = ClothingItemName
	else ClothingItem = instanceItem(ClothingItemName) end
	 
	if not ClothingItem then return false end
	self.player:getInventory():AddItem(ClothingItem)

	if instanceof(ClothingItem, "InventoryContainer") and ClothingItem:canBeEquipped() ~= "" then
		--self.player:setWornItem(ClothingItem:canBeEquipped(), ClothingItem);
		self.player:setClothingItem_Back(ClothingItem)
		getPlayerData(self.player:getPlayerNum()).playerInventory:refreshBackpacks();
		--self.player:initSpritePartsEmpty();
	elseif ClothingItem:getCategory() == "Clothing" then
		if ClothingItem:getBodyLocation() ~= "" then
			--print(ClothingItem:getDisplayName() .. " " ..tostring(ClothingItem:getBodyLocation()))
			self.player:setWornItem(ClothingItem:getBodyLocation(), nil);
			self.player:setWornItem(ClothingItem:getBodyLocation(), ClothingItem);
		end
	else
		return false
	end
	
	self.player:initSpritePartsEmpty();
	triggerEvent("OnClothingUpdated", self.player)

end

function SuperSurvivor:spawnPlayer(square, isFemale)

	
	local BuddyDesc
	if(isFemale == nil ) then
		BuddyDesc = SurvivorFactory.CreateSurvivor();
	else 		
		BuddyDesc = SurvivorFactory.CreateSurvivor(nil, isFemale);
	end
	
	SurvivorFactory.randomName(BuddyDesc);
	
	local Z = 0;
	if(square:isSolidFloor()) then Z = square:getZ() end;
	--local realplayer = getSpecificPlayer(0)
	local Buddy = IsoPlayer.new(getWorld():getCell(),BuddyDesc,square:getX(),square:getY(),Z);
	--IsoPlayer.setInstance(Buddy)
	--Buddy:update()
	--IsoPlayer.setInstance(realplayer)
	
	Buddy:setSceneCulled(false)
	
	--Buddy:dressInRandomOutfit()
	--Buddy:dressInNamedOutfit(Buddy:getRandomDefaultOutfit())
	Buddy:setBlockMovement(true)
	Buddy:setNPC(true);

	-- required perks ------------
	for i=0, 4 do
		Buddy:LevelPerk(Perks.FromString("Strength"));
	end
	for i=0, 2 do
		Buddy:LevelPerk(Perks.FromString("Sneak"));
	end
	for i=0, 3 do
		Buddy:LevelPerk(Perks.FromString("Lightfoot"));
	end
	--for i=0, 2 do
	--	Buddy:LevelPerk(Perks.FromString("Aiming")); -- counter act the fact they have to load now and fire at slower rate
	--end
	-- end
	
	-- random perks -------------------
	local level = ZombRand(9,14);
	local count = 0;
	while(count < level) do
		local aperk = Perks.FromString(getAPerk())
		if(aperk ~= nil) and (tostring(aperk) ~= "MAX") then 
			--print("trying to level: ".. tostring(aperk))
			Buddy:LevelPerk(aperk) 
		end
		count = count + 1;
	end
	--
	
	local traits = Buddy:getTraits()
	
	Buddy:getTraits():add("Inconspicuous")
	Buddy:getTraits():add("Outdoorsman")
	Buddy:getTraits():add("LightEater")
	Buddy:getTraits():add("LowThirst")
	Buddy:getTraits():add("FastHealer")
	Buddy:getTraits():add("Graceful")
	Buddy:getTraits():add("IronGut")
	Buddy:getTraits():add("Lucky")
	Buddy:getTraits():add("KeenHearing")
	
	-- achievements mod compatibility to stop errors--------
	if(Buddy:getModData().ThingsIDropped == nil) then 
		Buddy:getModData().ThingsIDropped = {} 
	end
	if(Buddy:getModData().CheckPointCounts == nil) then 
		Buddy:getModData().CheckPointCounts = {} 
	end
	if(Buddy:getModData().KilledWithCounts == nil) then 
		Buddy:getModData().KilledWithCounts = {} 
	end	
	if(Buddy:getModData().ThingsIDid == nil) then
		Buddy:getModData().ThingsIDid = {}
	end
	if(Buddy:getModData().ThingsIAte == nil) then
		Buddy:getModData().ThingsIAte = {}
	end
	if(Buddy:getModData().ThingsICrafted == nil) then
		Buddy:getModData().ThingsICrafted = {}
	end
	-- achievements mod compatibility to stop errors--------END
	Buddy:getModData().bWalking = false
	Buddy:getModData().isHostile = false	
	Buddy:getModData().RWP = SuperSurvivorGetOptionValue("SurvivorFriendliness")
	--print("SuperSurvivorGetOptionValue(SurvivorFriendliness):"..tostring(Buddy:getModData().RWP))
	Buddy:getModData().AIMode = "Random Solo"
	
	ISTimedActionQueue.clear(Buddy)
	
	local namePrefix = ""
	local namePrefixAfter = ""
	if(Buddy:getPerkLevel(Perks.FromString("Doctor")) >= 3) then 
		namePrefix = getText("ContextMenu_SD_DoctorPrefix_Before") 
		namePrefixAfter = getText("ContextMenu_SD_DoctorPrefix_After") 
	end
	if(Buddy:getPerkLevel(Perks.FromString("Aiming")) >= 5) then 
		namePrefix = getText("ContextMenu_SD_VeteranPrefix_Before") 
		namePrefixAfter = getText("ContextMenu_SD_VeteranPrefix_After") 
		
	end
	if(Buddy:getPerkLevel(Perks.FromString("Farming")) >= 3) then 
		namePrefix = getText("ContextMenu_SD_FarmerPrefix_Before") 
		namePrefixAfter = getText("ContextMenu_SD_FarmerPrefix_After") 
	end
	
	local nameToSet
	if(Buddy:getModData().Name == nil) then
		if Buddy:isFemale() then
			nameToSet = getSpeech("GirlNames")	
		else
			nameToSet = getSpeech("BoyNames")			
		end		
	else
		nameToSet = Buddy:getModData().Name
	end
	nameToSet = namePrefix .. nameToSet .. namePrefixAfter
	
	Buddy:setForname(nameToSet);
	Buddy:setDisplayName(nameToSet);
	
	Buddy:getStats():setHunger((ZombRand(10)/100))
	Buddy:getStats():setThirst((ZombRand(10)/100))
	
	Buddy:getModData().Name = nameToSet
	Buddy:getModData().NameRaw = nameToSet
	
	local desc = Buddy:getDescriptor()
	desc:setForename(nameToSet)
	desc:setSurname("")	
	print("new SS:" .. nameToSet .. " " .. tostring(Buddy:getBodyDamage():isInfected()))
	return Buddy

end



function SuperSurvivor:setBravePoints(toValue)
	self.player:getModData().BravePoints = toValue
end
function SuperSurvivor:getBravePoints()
	if(self.player:getModData().BravePoints ~= nil) then return self.player:getModData().BravePoints
	else return 0 end
end
function SuperSurvivor:setGroupRole(toValue)
	self.player:getModData().GroupRole = toValue
end
function SuperSurvivor:getGroupRole()
	return self.player:getModData().GroupRole
end
function SuperSurvivor:setNeedAmmo(toValue)
	self.player:getModData().NeedAmmo = toValue
end
function SuperSurvivor:getNeedAmmo()
	if(self.player:getModData().NeedAmmo ~= nil) then
		return self.player:getModData().NeedAmmo
	else
		return false
	end
end
function SuperSurvivor:setAIMode(toValue)
	self.player:getModData().AIMode = toValue
end
function SuperSurvivor:getAIMode()
	return self.player:getModData().AIMode
end
function SuperSurvivor:setGroupID(toValue)
	self.player:getModData().Group = toValue
end
function SuperSurvivor:getGroupID()
	return self.player:getModData().Group
end

function SuperSurvivor:setSneaking(toValue)
	if self.player ~= nil then
		self.player:setSneaking(toValue)
	end
end

function SuperSurvivor:setRunning(toValue)

	if(self.player:NPCGetRunning() ~= toValue) then
		self.player:NPCSetRunning(toValue)
		--self.player:setNPC(true)
		--print("setRunning "..tostring(toValue))
		--self.player:setPathfindRunning(toValue)
		--self.player:setForceRun(toValue)
		--self.player:setRunning(toValue)
		self.player:NPCSetJustMoved(toValue)
		--self.player:getModData().Running = toValue;
		--self.player:getModData().bWalking = toValue;
	
		--self.player:setSprinting(toValue);
		--self.player:setForceSprint(toValue);
	end
	
end
function SuperSurvivor:getRunning()
	return self.player:getModData().Running
end


function SuperSurvivor:getSneaking()
	return self.player:getModData().Sneaking
end

function SuperSurvivor:getGroup()
	local gid = self:getGroupID()
	--print("get group " .. gid)
	if(gid ~= nil) then 		
		return SSGM:Get(gid) 
	end
	return nil
end
function SuperSurvivor:Get()
	return self.player
end
function SuperSurvivor:getCurrentTask()
	return self:getTaskManager():getCurrentTask()
end
function SuperSurvivor:isTooScaredToFight()
	
	if (self.EnemiesOnMe >= 3) then
		return true
	elseif (self.dangerSeenCount > 0 and (self:HasMultipleInjury() or not self:hasWeapon())) then 
		return true
	else
		local base = 2
		if(self:hasWeapon() and self:hasWeapon():getMaxDamage() > 0.1) then base = base + 1 end
		if(self:usingGun()) then base = base + 2 end
		base = base - self.EnemiesOnMe;
		if(self:HasInjury()) then base = base - 1 end
		base = base + self:getBravePoints() + self:getGroupBraveryBonus()
		--self:Speak(tostring(self.dangerSeenCount)..":"..tostring(base))
		return (self.dangerSeenCount > (base)) 
		
	end
end
function SuperSurvivor:usingGun()
	local handItem = self.player:getPrimaryHandItem()
	if(handItem ~= nil) and (instanceof(handItem,"HandWeapon")) then
		return self.player:getPrimaryHandItem():isAimedFirearm()
	end
	return false
end
function SuperSurvivor:isWalkingPermitted()
	return self.WalkingPermitted
end
function SuperSurvivor:setWalkingPermitted(toValue)
	self.WalkingPermitted = toValue
end

function SuperSurvivor:resetAllTables()

	self.SpokeToRecently = {}
	self.SquareWalkToAttempts = {}
	self.SquaresExplored = {}
	self.SquareContainerSquareLooteds = {}
	for i=1, #LootTypes do self.SquareContainerSquareLooteds[LootTypes[i]] = {} end

end

function SuperSurvivor:resetContainerSquaresLooted()

	for i=1, #LootTypes do self.SquareContainerSquareLooteds[LootTypes[i]] = {} end

end

function SuperSurvivor:resetWalkToAttempts()

	self.SquareWalkToAttempts = {}

end

function SuperSurvivor:BuildingLooted()	
	self.NumberOfBuildingsLooted = self.NumberOfBuildingsLooted + 1
end
function SuperSurvivor:getBuildingsLooted()	
	return self.NumberOfBuildingsLooted
end

function SuperSurvivor:setBaseBuilding(building)	
	self.BaseBuilding = building
end
function SuperSurvivor:getBaseBuilding()	
	return self.BaseBuilding
end

function SuperSurvivor:needToFollow()

	local Task = self:getTaskManager():getTask()
	if(Task) then 
		
		if(Task.Name == "Follow" and Task:needToFollow() ) then 
			
			return true 
		
		end
	end
	Task = self:getTaskManager():getThisTask(1)
	if(Task ~= nil) then 
		
		if(Task.Name == "Follow" and Task:needToFollow() ) then 
			
			return true 
		
		end
	end
	
	return false
end

function SuperSurvivor:getNoFoodNearBy()
	--print(self:getName() .. " nofood " .. tostring((self.Reducer - self.TicksAtLastDetectNoFood)))
	if (self.NoFoodNear == true) then
		if (self.TicksAtLastDetectNoFood ~= nil)
			and ((self.Reducer - self.TicksAtLastDetectNoFood) > 12000)
			then self.NoFoodNear = false end
	end
	return self.NoFoodNear
end

function SuperSurvivor:setNoFoodNearBy(toThis)
	if(toThis == true) then
		self.TicksAtLastDetectNoFood = self.Reducer
	end
	self.NoFoodNear = toThis
end

function SuperSurvivor:getNoWaterNearBy()
	if (self.NoWaterNear == true) then
		if (self.TicksAtLastDetectNoWater ~= nil)
			and (
				(self.Reducer < self.TicksAtLastDetectNoWater)
				or ((self.Reducer - self.TicksAtLastDetectNoWater) > 12900)
			) then self.NoWaterNear = false end
	end
	return self.NoWaterNear
end

function SuperSurvivor:setNoWaterNearBy(toThis)
	if(toThis == true) then
		self.TicksAtLastDetectNoWater = self.Reducer
	end
	self.NoWaterNear = toThis
end

function SuperSurvivor:isHungry()
	return (self.player:getStats():getHunger() > 0.15) 	
end
function SuperSurvivor:isVHungry()
	return (self.player:getStats():getHunger() > 0.40) 	
end
function SuperSurvivor:isStarving()
	return (self.player:getStats():getHunger() > 0.75) 	
end
function SuperSurvivor:isThirsty()
	return (self.player:getStats():getThirst() > 0.15) 	
end
function SuperSurvivor:isVThirsty()
	return (self.player:getStats():getThirst() > 0.40) 	
end
function SuperSurvivor:isDyingOfThirst()
	return (self.player:getStats():getThirst() > 0.75) 	
end
function SuperSurvivor:isDead()
	return (self.player:isDead()) 	
end
function SuperSurvivor:saveFileExists()
	return (checkSaveFileExists("Survivor"..tostring(self:getID())))	
end

function SuperSurvivor:getRelationshipWP()
	if(self.player:getModData().RWP == nil) then return 0
	else return self.player:getModData().RWP end	
end
function SuperSurvivor:PlusRelationshipWP(thisAmount)
	if(self.player:getModData().RWP == nil) then self.player:getModData().RWP = 0 end
	
	self.player:getModData().RWP = self.player:getModData().RWP + thisAmount
	return self.player:getModData().RWP
end

function SuperSurvivor:hasFood()	
	local inv = self.player:getInventory()
	local bag = self:getBag()
	if FindAndReturnFood(inv) ~= nil then return true
	elseif (inv ~= bag) and (FindAndReturnFood(bag) ~= nil) then return true
	else return false end
end

function SuperSurvivor:getFood()	
	local inv = self.player:getInventory()
	local bag = self:getBag()
	if FindAndReturnFood(inv) ~= nil then return FindAndReturnBestFood(inv, nil)
	elseif (inv ~= bag) and (FindAndReturnFood(bag) ~= nil) then return FindAndReturnBestFood(bag, nil)
	else return nil end
end



function SuperSurvivor:hasWater()	
	local inv = self.player:getInventory()
	local bag = self:getBag()
	if FindAndReturnWater(inv) ~= nil then return true
	elseif (inv ~= bag) and (FindAndReturnWater(bag) ~= nil) then return true
	else return false end
end

function SuperSurvivor:getWater()	
	local inv = self.player:getInventory()
	local bag = self:getBag()
	if FindAndReturnWater(inv) ~= nil then return FindAndReturnWater(inv)
	elseif (inv ~= bag) and (FindAndReturnWater(bag) ~= nil) then return FindAndReturnWater(bag)
	else return nil end
end

function SuperSurvivor:getFacingSquare()	
	local square = self.player:getCurrentSquare()
	local fsquare = square:getTileInDirection(self.player:getDir())
	if(fsquare) then return fsquare 
	else return square end
end

function SuperSurvivor:isTargetBuildingClaimed(building)
	if(SafeBase) then -- if safe base mode on survivors consider other claimed buildings already explored
		local tempsquare = getRandomBuildingSquare(building)
		if (tempsquare ~= nil) then
			local tempgroup = SSGM:GetGroupIdFromSquare(tempsquare)
			--if self.DebugMode then print(tostring(tempgroup) .. " " .. self:getGroupID() end
			if(tempgroup ~= -1 and tempgroup ~= self:getGroupID()) then return true end
		end
	end

	return false
end

function SuperSurvivor:isTargetBuildingDangerous()
	if self:isTargetBuildingClaimed(self.TargetBuilding) then return true end

	local result = NumberOfZombiesInOrAroundBuilding(self.TargetBuilding)
	
	if(result >= 10) and (self:isTooScaredToFight()) then return true
	else return false end
end

function SuperSurvivor:MarkBuildingExplored(building)
	if(not building) then return false end
	self:resetBuildingWalkToAttempts(building)
	local bdef = building:getDef()	
	for x=bdef:getX()-1,(bdef:getX() + bdef:getW()+1) do	
		for y=bdef:getY()-1,(bdef:getY() + bdef:getH()+1) do
			
			local sq = getCell():getGridSquare(x,y,self.player:getZ())			
			if(sq) then 
				self:Explore(sq)
			end			
		end							
	end
end

function SuperSurvivor:getBuildingExplored(building)
	if self:isTargetBuildingClaimed(building) then return true end

	local sq = getRandomBuildingSquare(building)		
	if(sq) then 
		if(self:getExplore(sq) > 0) then
			return true
		else 
			return false 
		end
	end			
	
	return false
end

function SuperSurvivor:DebugSay(text)

	if(DebugSayEnabled or self.DebugMode) then
		print(text)
		self:Speak(text)
	end
end

function SuperSurvivor:isSpeaking()
	if(self.JustSpoke) or (self.player:isSpeaking()) then return true
	else return false end
end

function SuperSurvivor:Speak(text)

	if(SpeakEnabled) then
	
		--print(self:getName()..": "..text)
		self.SayLine1 = text
		self.JustSpoke = true
		self.TicksSinceSpoke = 0
		
	end
end

function SuperSurvivor:MarkAttemptedBuildingExplored(building)
	if(building == nil) then return false end
	local bdef = building:getDef()	
	for x=bdef:getX(),(bdef:getX() + bdef:getW()) do	
		for y=bdef:getY(),(bdef:getY() + bdef:getH()) do
			
			local sq = getCell():getGridSquare(x,y,self.player:getZ())			
			if(sq) then 
				self:setWalkToAttempt(sq,8)
			end			
		end							
	end
end
function SuperSurvivor:resetBuildingWalkToAttempts(building)
	if(building == nil) then return false end
	local bdef = building:getDef()	
	for x=bdef:getX(),(bdef:getX() + bdef:getW()) do	
		for y=bdef:getY(),(bdef:getY() + bdef:getH()) do
			
			local sq = getCell():getGridSquare(x,y,self.player:getZ())			
			if(sq) then 
				self:setWalkToAttempt(sq,0)
			end			
		end							
	end
end

function SuperSurvivor:Explore(sq)
	if(sq) then
		local key = tostring(sq:getX()).. "/" ..tostring(sq:getY())
		if(self.SquaresExplored[key] == nil) then self.SquaresExplored[key] = 1
		else self.SquaresExplored[key] = self.SquaresExplored[key] + 1 end
	end
end
function SuperSurvivor:getExplore(sq)	
	if(sq) then
		local key = tostring(sq:getX()).. "/" ..tostring(sq:getY())
		if(self.SquaresExplored[key] == nil) then return 0
		else return self.SquaresExplored[key] end
	end
	return 0
end

function SuperSurvivor:ContainerSquareLooted(sq,Category)
	if(sq) then
		local key = sq:getX()..sq:getY()
		if(self.SquareContainerSquareLooteds[Category][key] == nil) then self.SquareContainerSquareLooteds[Category][key] = 1
		else self.SquareContainerSquareLooteds[Category][key] = self.SquareContainerSquareLooteds[Category][key] + 1 end
	end
end
function SuperSurvivor:setContainerSquareLooted(sq,toThis,Category)
	if(sq) then
		local key = sq:getX()..sq:getY()
		 self.SquareContainerSquareLooteds[Category][key] = toThis
		
	end
end
function SuperSurvivor:getContainerSquareLooted(sq,Category)	
	if(sq) then
		local key = sq:getX()..sq:getY()
		if(self.SquareContainerSquareLooteds[Category][key] == nil) then return 0
		else return self.SquareContainerSquareLooteds[Category][key] end
	end
	return 0
end

function SuperSurvivor:WalkToAttempt(sq)
	if(sq) then
		local key = sq:getX()..sq:getY()
		if(self.SquareWalkToAttempts[key] == nil) then self.SquareWalkToAttempts[key] = 1
		else self.SquareWalkToAttempts[key] = self.SquareWalkToAttempts[key] + 1 end
	end
end
function SuperSurvivor:setWalkToAttempt(sq,toThis)
	if(sq) then
		local key = sq:getX()..sq:getY()
		 self.SquareWalkToAttempts[key] = toThis
		
	end
end

function SuperSurvivor:setRouteID(routeid)
	self.player:getModData().RouteID = routeid
end
function SuperSurvivor:getRouteID()
	if(self.player:getModData().RouteID == nil) then return 0
	else return self.player:getModData().RouteID end
end

function SuperSurvivor:getWalkToAttempt(sq)	
	if(sq) then
		local key = sq:getX()..sq:getY()
		if(self.SquareWalkToAttempts[key] == nil) then return 0
		else return self.SquareWalkToAttempts[key] end
	end
	return 0
end



function SuperSurvivor:inUnLootedBuilding()
	
	if(self.player:isOutside()) then return false end
	local sq = self.player:getCurrentSquare()
	if(sq) then
		local room = sq:getRoom()
		if(room) then
			local building = room:getBuilding()
			if(building) and (self:getBuildingExplored(building) == false) then 	
				
				return true 
			else 
				
				return false 
			end
		end
	end
	
	return false
end
function SuperSurvivor:getBuilding()
	if(self.player == nil) then return nil end
	local sq = self.player:getCurrentSquare()
	if(sq) then
		local room = sq:getRoom()
		if(room) then
			local building = room:getBuilding()
			if(building) then return building 
			else return nil end
		end
	end
	
	return nil
end

function SuperSurvivor:isInBuilding(building)
	if(building == self:getBuilding()) then return true
	else return false end
end

function SuperSurvivor:AttemptedLootBuilding(building)
	
	if( not building ) then return false end
		
	local buildingSquareRoom = building:getRandomRoom()
	if not buildingSquareRoom then return false end
	
	local buildingSquare = buildingSquareRoom:getRandomFreeSquare()
	if not buildingSquare then return false end

	if(self:getWalkToAttempt(buildingSquare) == 0) then 
		return false 	
	elseif (self:getWalkToAttempt(buildingSquare) >= 8) then 
		return true 
	else
		return false
	end
	
end

function SuperSurvivor:getUnBarricadedWindow(building)

	local pcs = self.player:getCurrentSquare()
	local WindowOut = nil
	local closestSoFar = 100
	local bdef = building:getDef()	
	for x=bdef:getX()-1,(bdef:getX() + bdef:getW() + 1) do	
		for y=bdef:getY()-1,(bdef:getY() + bdef:getH() + 1) do
			
			local sq = getCell():getGridSquare(x,y,self.player:getZ())			
			if(sq) then 
				local Objs = sq:getObjects();
				for j=0, Objs:size()-1 do
					local Object = Objs:get(j)
					local objectSquare = Object:getSquare()
					local distance = getDistanceBetween(objectSquare,self.player)
					if(instanceof(Object,"IsoWindow"))  and (self:getWalkToAttempt(objectSquare) < 8) and distance < closestSoFar then
						
						 local barricade = Object:getBarricadeForCharacter(self.player)
						 if barricade == nil or (barricade:canAddPlank()) then 
							closestSoFar = distance	
							WindowOut = Object 
						end
					end
				end	
			end
			
		end
							
	end
	return WindowOut
end

function SuperSurvivor:isEnemy(character)

	local group = self:getGroup()
	if(group) then
		return group:isEnemy(self,character)
	else
		-- zombie is enemy to anyone
		if character:isZombie() then return true 
		elseif (self:isInGroup(character)) then return false
		elseif (self.player:getModData().isHostile ~= true and self.player:getModData().surender == true) then return false -- so other npcs dont attack anyone surendering
		elseif (self.player:getModData().hitByCharacter == true) and (character:getModData().semiHostile == true) then return true 
		elseif (character:getModData().isHostile ~= self.player:getModData().isHostile) then 
			--print(tostring(character:getForname()).."("..tostring(character:getModData().Group)..") is enemy to "..self:getName().."("..tostring(self:getGroupID()))
			return true
		else 
			return false
		end 
	end

end

function SuperSurvivor:hasWeapon()

	if(self.player:getPrimaryHandItem() ~= nil) and (instanceof(self.player:getPrimaryHandItem(),"HandWeapon")) then
		return self.player:getPrimaryHandItem() 
	else
		return false
	end

end

function SuperSurvivor:hasGun()

	if(self.player:getPrimaryHandItem() ~= nil) and (instanceof(self.player:getPrimaryHandItem(),"HandWeapon")) and (self.player:getPrimaryHandItem():isAimedFirearm()) then return true 
	else return false end

end

function SuperSurvivor:getBag()

	if(self.player:getClothingItem_Back() ~= nil) and (instanceof(self.player:getClothingItem_Back(),"InventoryContainer")) then return self.player:getClothingItem_Back():getItemContainer() end
	if(self.player:getSecondaryHandItem() ~= nil) and (instanceof(self.player:getSecondaryHandItem(),"InventoryContainer")) then return self.player:getSecondaryHandItem():getItemContainer() end
	if(self.player:getPrimaryHandItem() ~= nil) and (instanceof(self.player:getPrimaryHandItem(),"InventoryContainer")) then return self.player:getPrimaryHandItem():getItemContainer() end
	
	return self.player:getInventory()
end
--[[
function SuperSurvivor:getWeapon()	
	local inv = self.player:getInventory()
	local bag = self:getBag()
	if inv:FindAndReturnCategory("Weapon") ~= nil then return inv:FindAndReturnCategory("Weapon")
	elseif (inv ~= bag) and (bag:FindAndReturnCategory("Weapon") ~= nil) then return bag:FindAndReturnCategory("Weapon")
	else return nil end
end
]]
function SuperSurvivor:getWeapon()

	if(self.player:getInventory() ~= nil) and (self.player:getInventory():FindAndReturnCategory("Weapon")) then return self.player:getInventory():FindAndReturnCategory("Weapon") end
	if(self.player:getClothingItem_Back() ~= nil) and (instanceof(self.player:getClothingItem_Back(),"InventoryContainer")) and (self.player:getClothingItem_Back():getItemContainer():FindAndReturnCategory("Weapon")) then return self.player:getClothingItem_Back():getItemContainer():FindAndReturnCategory("Weapon") end
	if(self.player:getSecondaryHandItem() ~= nil) and (instanceof(self.player:getSecondaryHandItem(),"InventoryContainer")) and (self.player:getSecondaryHandItem():getItemContainer():FindAndReturnCategory("Weapon")) then return self.player:getSecondaryHandItem():getItemContainer():FindAndReturnCategory("Weapon") end
	
	return nil
end

function SuperSurvivor:hasRoomInBag()

	local playerBag = self:getBag()
	
	if(playerBag:getCapacityWeight() >= (playerBag:getMaxWeight() * 0.9)) then return false
	else return true end
	
end

function SuperSurvivor:hasRoomInBagFor(item)

	local playerBag = self:getBag()
	
	if(playerBag:getCapacityWeight() + item:getWeight() >= (playerBag:getMaxWeight() * 0.9)) then return false
	else return true end
	
end

function SuperSurvivor:getSeenCount()
	return self.seenCount
end
function SuperSurvivor:getDangerSeenCount()
	return self.dangerSeenCount
end

function SuperSurvivor:isInSameRoom(movingObj)
	if not movingObj then return false end
	local objSquare = movingObj:getCurrentSquare()
	if (not objSquare) then return false end
	local selfSquare = self.player:getCurrentSquare()
	if (not selfSquare) then return false end
	if(selfSquare:getRoom() == objSquare:getRoom()) then return true
	else return false end
end

function SuperSurvivor:isInSameBuilding(movingObj)
	if not movingObj then return false end
	local objSquare = movingObj:getCurrentSquare()
	if (not objSquare) then return false end
	local selfSquare = self.player:getCurrentSquare()
	if (not selfSquare) then return false end
	if(selfSquare:getRoom() ~= nil and objSquare:getRoom() ~= nil) then 
		return (selfSquare:getRoom():getBuilding() == objSquare:getRoom():getBuilding())
	end
	if(selfSquare:getRoom() == objSquare:getRoom()) then return true end
	
	return false 
end

function SuperSurvivor:getAttackRange()
			 
	return self.AttackRange 
	
end

function SuperSurvivor:RealCanSee(character)
	
	if(character:isZombie()) then return (self.player:CanSee(character)) end -- normal vision for zombies (they are not quiet or sneaky)
	
	local visioncone = SurvivorVisionCone
	if(character:isSneaking()) then visioncone = visioncone - 0.15 end
	return (self.player:CanSee(character) and (self.player:getDotWithForwardDirection(character:getX(),character:getY()) + visioncone) >= 1.0 ) 						

end

function SuperSurvivor:DoVision()

	local atLeastThisClose = 19;
	local spottedList = self.player:getCell():getObjectList()
	local closestSoFar = 200
	local closestSurvivorSoFar = 200
	self.seenCount = 0
	self.dangerSeenCount = 0
	self.EnemiesOnMe = 0
	self.LastEnemeySeen = nil
	self.LastSurvivorSeen = nil
	local dangerRange = 6
	if self.AttackRange > dangerRange then dangerRange = self.AttackRange end
	
	local closestNumber = nil
	local tempdistance = 1
	
	
	if(spottedList ~= nil) then
		--print("dovision " .. tostring(spottedList:size()))
		for i=0, spottedList:size()-1 do
			local character = spottedList:get(i);
			if(character ~= nil) and (character ~= self.player) and (instanceof(character,"IsoZombie") or instanceof(character,"IsoPlayer")) then
			
				if (character:isDead() == false) then
					tempdistance = tonumber(getDistanceBetween(character,self.player))
					
					if( (tempdistance <= atLeastThisClose) and self:isEnemy(character) ) then	
					
						local CanSee = self:RealCanSee(character)
						
						if(tempdistance < 1) and (character:getZ() == self.player:getZ()) then 
							self.EnemiesOnMe = self.EnemiesOnMe + 1 
						end
						if(tempdistance < dangerRange) and (character:getZ() == self.player:getZ()) then
							--if (character:CanSee(self.player)) and (self:isInSameRoom(character) or (tempdistance <= 1)) then 
								self.dangerSeenCount = self.dangerSeenCount + 1 
							--end 
						end
						if(CanSee) then 
							self.seenCount = self.seenCount + 1 
						end
						if( ( CanSee or (tempdistance < 0.5)) and (tempdistance < closestSoFar) ) then
							closestSoFar = tempdistance ;
							self.player:getModData().seenZombie = true;
							closestNumber = i;							
						end
						
					elseif( tempdistance < closestSurvivorSoFar ) and false then
						closestSurvivorSoFar = tempdistance
						self.LastSurvivorSeen = character						
					end
				end
				
			end
		end
	end
		
	if(closestNumber ~= nil) then 
		self.LastEnemeySeen = spottedList:get(closestNumber)
		
		return self.LastEnemeySeen
	end
	
end

function SuperSurvivor:isInCell()	
	if(self.player == nil) or (self.player:getCurrentSquare() == nil) or (self:isDead()) then return false
	else return true end	
end
function SuperSurvivor:isOnScreen()	
	if(self.player:getCurrentSquare() ~= nil) and (self.player:getCurrentSquare():IsOnScreen()) then return true
	else return false end	
end

function SuperSurvivor:isInAction()

	--if(self.player:isPerformingAnAction()) then return true end
	--print(self:getName().." " .. tostring(self.TicksSinceSquareChanged))
	if((self.player:getModData().bWalking == true) and (self.TicksSinceSquareChanged <= 10)) then
		--print(self:getName().." returing true1")
		return true 
	end
	
    local queue = ISTimedActionQueue.queues[self.player]
    if queue == nil then return false end
    --for k,v in ipairs(queue.queue) do
	for k=1, #queue.queue do
		local v = queue.queue[k]
        if v then 
			--print(self:getName().." returing true2")
			return true 
		end
    end
	
	return false;
		
end

function SuperSurvivor:isWalking()
	
    local queue = ISTimedActionQueue.queues[self.player]
    if queue == nil then return false end
    --for k,v in ipairs(queue.queue) do
	for k=1, #queue.queue do
		local v = queue.queue[k]
        if v then return true end
    end
	return false;
		
end


function SuperSurvivor:walkTo(square)


	if(square == nil) then return false end
	--ISTimedActionQueue.add(ISWalkToTimedAction:new (self.player, square))
	--self:setRunning(true)
	--self.player:StopAllActionQueue()
	
	local parent
	if(instanceof(square,"IsoObject")) then parent = square:getSquare() 
	else parent = square end
	
	self.TargetSquare = square
	if(square:getRoom() ~= nil) and (square:getRoom():getBuilding() ~= nil) then self.TargetBuilding = square:getRoom():getBuilding() end
	
	local adjacent = AdjacentFreeTileFinder.Find(parent, self.player);
	if instanceof(square, "IsoWindow") or instanceof(square, "IsoDoor") then
		adjacent = AdjacentFreeTileFinder.FindWindowOrDoor(parent, square, self.player);
	end
	if adjacent ~= nil then
		local door = self:inFrontOfDoor()
		if (door ~= nil) and (door:isLocked() or door:isLockedByKey()) then
			local building = door:getOppositeSquare():getBuilding()
			--if (builing == nil) or (not self.parent:isTargetBuildingClaimed(builing)) then
				self:DebugSay("little pig, little pig")
			--	door:setIsLocked(false)
			--	door:setLockedByKey(false)
			--end
		end
		
		self:WalkToAttempt(square)
		self:WalkToPoint(adjacent:getX(),adjacent:getY(),adjacent:getZ())
	end
	--]]
end

function SuperSurvivor:walkTowards(x,y,z)


	
	local towardsSquare = getTowardsSquare(self:Get(),x,y,z)
	if(towardsSquare == nil) then return false end
	
	self:WalkToPoint(towardsSquare:getX(),towardsSquare:getY(),towardsSquare:getZ())
	
	
end

function SuperSurvivor:setHostile(toValue)
	if(toValue) then
		self.userName:setDefaultColors(128,128, 128, 255);
		self.userName:setOutlineColors(180,0, 0,255);
	else		
		self.userName:setDefaultColors(255,255, 255, 255);
		self.userName:setOutlineColors(0,0, 0,255);	
	end
	self.player:getModData().isHostile = toValue
	if(ZombRand(2) == 1) then 
		self.player:getModData().isRobber = true
	end
end

function SuperSurvivor:walkToDirect(square)

	if(square == nil) then return false end
	
	self:WalkToAttempt(square)
	self:WalkToPoint(square:getX(),square:getY(),square:getZ())
	
end

 
function SuperSurvivor:WalkToPoint(tx, ty, tz) 

    if(not self.player:getPathFindBehavior2():isTargetLocation(tx,ty,tz)) then
	
        self.player:getModData().bWalking = true
		
        self.player:setPath2(nil);
        self.player:getPathFindBehavior2():pathToLocation(tx,ty,tz);
		if(self.DebugMode) then print(self:getName() .. " WalkToPoint") end
    end
        
  end




function SuperSurvivor:inFrontOfLockedDoor()

	local door = self:inFrontOfDoor()
			
	if (door ~= nil) and (door:isLocked() or door:isLockedByKey())  then
		return true
	else 
		return false
	end
	
end
function SuperSurvivor:inFrontOfDoor()

	 local cs = self.player:getCurrentSquare()
	 local osquare = GetAdjSquare(cs,"N")
	 if cs and osquare and cs:getDoorTo(osquare) then return cs:getDoorTo(osquare) end
	 
	 osquare = GetAdjSquare(cs,"E")
	 if cs and osquare and cs:getDoorTo(osquare) then return cs:getDoorTo(osquare) end
	 
	 osquare = GetAdjSquare(cs,"S")
	 if cs and osquare and cs:getDoorTo(osquare) then return cs:getDoorTo(osquare) end
	 
	 osquare = GetAdjSquare(cs,"W")
	 if cs and osquare and cs:getDoorTo(osquare) then return cs:getDoorTo(osquare) end
	 
	 return nil 
	
end
function SuperSurvivor:inFrontOfWindow()

	 local cs = self.player:getCurrentSquare()
	 local fsquare = cs:getTileInDirection(self.player:getDir());
	 if cs and fsquare then return cs:getWindowTo(fsquare)
	 else return nil end
	
end
function SuperSurvivor:inFrontOfStairs()

	local cs = self.player:getCurrentSquare()

	if cs:HasStairs() then return true end
	local osquare = GetAdjSquare(cs,"N")
	if cs and osquare and osquare:HasStairs() then return true end
	
	osquare = GetAdjSquare(cs,"E")
	if cs and osquare and osquare:HasStairs() then return true end
	
	osquare = GetAdjSquare(cs,"S")
	if cs and osquare and osquare:HasStairs() then return true end
	
	osquare = GetAdjSquare(cs,"W")
	if cs and osquare and osquare:HasStairs() then return true end
	
	return false 
	
end


function SuperSurvivor:updateTime()
		self:renderName()
		self.Reducer = self.Reducer + 1 
	
	if(self.Reducer % 20 == 0) then 
		if(self.WaitTicks == 0) then
			return true
		else
			self.WaitTicks = self.WaitTicks - 1
			return false
		end
	else return false end
end



function SuperSurvivor:update()
	
	if(self:isDead()) then 
		
		return false
	
	end
	
	self.player:setBlockMovement(true)
	
	--self:CleanUp(0.988); -- slowly reduces current blood/dirt by this percent 
	
	self.TriggerHeldDown = false
	if(not SurvivorHunger) then		
		self.player:getStats():setThirst(0.0)
		self.player:getStats():setHunger(0.0)	
	--else
		--self.player:getStats():setThirst(self.player:getStats():getThirst() + 0.00005) -- survivor thirst does not move so manually incremnt it
	elseif (not self:isInBase()) then
		-- dont get hungry outside of base, to prevent infinite search loops
		--self.player:getStats():setThirst(0.0)
		--self.player:getStats():setHunger(0.0)	
	end
	
	--control of unmanaged stats
	self.player:getNutrition():setWeight(85);
	self.player:getBodyDamage():setSneezeCoughActive(0);	
	self.player:getBodyDamage():setFoodSicknessLevel(0);	
	self.player:getBodyDamage():setPoisonLevel(0);	
	self.player:getBodyDamage():setUnhappynessLevel(0);		
	self.player:getBodyDamage():setHasACold(false);		
	self.player:getStats():setFatigue(0.0);	
	self.player:getStats():setIdleboredom(0.0);
	self.player:getStats():setMorale(0.5);
	self.player:getStats():setStress(0.0);
	self.player:getStats():setSanity(1);
	--print("health" .. self.player:getHealth());
	
	if (not SurvivorsFindWorkThemselves) then
		self.player:getStats():setBoredom(0.0);
	end
	if (not RainManager.isRaining()) or (not self.player:isOutside()) then
		self.player:getBodyDamage():setWetness(self.player:getBodyDamage():getWetness() - 0.1);
	end
	
	if(self.player:isOnFire()) then 
		self.player:getBodyDamage():RestoreToFullHealth() -- temporarily give some fireproofing as they walk right through fire via pathfinding
		self.player:setFireSpreadProbability(0); -- give some fireproofing as they walk right through fire via pathfinding	
	end
	

	if (self.TargetSquare ~= nil and self.TargetSquare:getZ() ~= self.player:getZ() and getGameSpeed() > 2) then
		print("DANGER ZONE 2: " .. self:getName());
		self.TargetSquare = nil
		self:StopWalk()
		self:Wait(10)
	end


	local cs = self.player:getCurrentSquare()
	if(cs ~= nil) then
		if(self.LastSquare == nil) or (self.LastSquare ~= cs) then
			self.TicksSinceSquareChanged = 0
			self.LastSquare = cs
		elseif (self.LastSquare == cs) then
			self.TicksSinceSquareChanged = self.TicksSinceSquareChanged + 1
			--self:Speak(tostring(self.TicksSinceSquareChanged))
		end
	end
	
	--self.player:Say(tostring(self:isInAction()) ..",".. tostring(self.TicksSinceSquareChanged > 6) ..",".. tostring(self:inFrontOfLockedDoor()) ..",".. tostring(self:getTaskManager():getCurrentTask() ~= "Enter New Building") ..",".. tostring(self.TargetBuilding ~= nil))
	--print( self:getName()..": "..tostring((self.TargetBuilding ~= nil)))
	if (
		(self:inFrontOfLockedDoor())
		or
		(self:inFrontOfWindow())
	) and (
		self:getTaskManager():getCurrentTask() ~= "Enter New Building"
	) and (
		self.TargetBuilding ~= nil
	) and (
		(
			(self.TicksSinceSquareChanged > 6)
			and (self:isInAction() == false)
			and (
				self:getCurrentTask() == "None"
				or self:getCurrentTask() == "Find This"
				or self:getCurrentTask() == "Find New Building"
			)
		) or (self:getCurrentTask() == "Pursue")
	) then
		print(self:getName().." Attempt Entry1")
		self:getTaskManager():AddToTop(AttemptEntryIntoBuildingTask:new(self, self.TargetBuilding))
		self.TicksSinceSquareChanged = 0
	end
	--self.player:Say(tostring(self:isInAction()) ..",".. tostring(self.TicksSinceSquareChanged > 6) ..",".. tostring((self:inFrontOfWindow())))
	
	if (self.TicksSinceSquareChanged > 9) and (self:isInAction() == false) and (self:inFrontOfWindow()) and (self:getCurrentTask() ~= "Enter New Building") then
		self.player:climbThroughWindow(self:inFrontOfWindow())
		self.TicksSinceSquareChanged = 0
	end
	
	if ((self.TicksSinceSquareChanged > 7) and (self:Get():getModData().bWalking == true)) or (self.TicksSinceSquareChanged > 500) then
		--print("detected survivor stuck walking: " .. self:getName() .. " for " .. self.TicksSinceSquareChanged .. " x" .. self.StuckCount)
		self.StuckCount = self.StuckCount + 1
	--elseif ((self.TicksSinceSquareChanged > 10) and (self:Get():getModData().bWalking == true)) then
		if (self.StuckCount > 100) then
			--print("trying to knock survivor out of frozen state: " .. self:getName());
			self.StuckCount = 0
			ISTimedActionQueue.add(ISGetHitFromBehindAction:new(self.player,getSpecificPlayer(0)))
		else
			local xoff = self.player:getX() + ZombRand(-3,3)
			local yoff = self.player:getY() + ZombRand(-3,3)		
			self:StopWalk()
			self:WalkToPoint(xoff,yoff,self.player:getZ())
			self:Wait(2)
		end
	end
		
	
	self:DoVision()
	--self:Speak(tostring(self:isInBase()))
	
	self.MyTaskManager:update()
	
	if(self.Reducer % 480 == 0) then 
		if(DebugMode) then print(self:getName().." task:"..MyTaskManager:getCurrentTask()) end
		self:setSneaking(false)
		
		self.player:setNPC(true)
		
		local group = self:getGroup()
		if(group) then group:checkMember(self:getID()) end
		self:SaveSurvivor()
		if(self:Get():getPrimaryHandItem() ~= nil) and (((self:Get():getPrimaryHandItem():getDisplayName()=="Corpse") and (self:getCurrentTask() ~= "Pile Corpses")) or (self:Get():getPrimaryHandItem():isBroken()) ) then
			
			ISTimedActionQueue.add(ISDropItemAction:new(self:Get(),self:Get():getPrimaryHandItem(),30))
			self:Get():setPrimaryHandItem(nil)
			self:Get():setSecondaryHandItem(nil)
		end
		if(self:Get():getPrimaryHandItem() == nil) and (self:getWeapon()) then self:Get():setPrimaryHandItem(self:getWeapon()) end
		
		self:ManageXP()
		
		self.player:getModData().hitByCharacter = false
		self.player:getModData().semiHostile = false	
		self.player:getModData().felldown = nil	
		
	else self:SaveSurvivorOnMap() end
	
	if( self.GoFindThisCounter > 0 ) then self.GoFindThisCounter = self.GoFindThisCounter -1 end
	
	
end


function SuperSurvivor:OnDeath()
	print(self:getName() .. " has died")

	-- Cannibal support
	if not self.player:getBodyDamage():isInfected() then
		for i=1, ZombRand(1,10) do
			self.player:getInventory():AddItem("Subpar.StrangeMeat")
		end
	end

	local ID = self:getID()
	SSM:OnDeath(ID)
	
	SurvivorLocX[ID] = nil
	SurvivorLocY[ID] = nil
	SurvivorLocZ[ID] = nil
	if(self.player:getModData().LastSquareSaveX ~= nil) then
		local lastkey = self.player:getModData().LastSquareSaveX .. self.player:getModData().LastSquareSaveY .. self.player:getModData().LastSquareSaveZ
		if(lastkey) and ( SurvivorMap[lastkey] ~= nil ) then
			table.remove(SurvivorMap[lastkey] , ID)
		end 
	end
end

function SuperSurvivor:PlayerUpdate()

	if(not self.player:isLocalPlayer()) then
	
		if(self.TriggerHeldDown) then -- simulate automatic weapon fire
			self:Attack(self.LastEnemeySeen)
		end
		
		if(self.player:getLastSquare() ~= nil ) then
			local cs = self.player:getCurrentSquare()
			local ls = self.player:getLastSquare()
			local tempdoor = ls:getDoorTo(cs);
			if(tempdoor ~= nil and tempdoor:IsOpen() ) then
				 tempdoor:ToggleDoor(self.player);
				
			end		
		end
		
		self:WalkToUpdate(self.player)
		
	end
	
end

function SuperSurvivor:WalkToUpdate()
    
	
    if(self.player:getModData().bWalking) then
					
        local myBehaviorResult = self.player:getPathFindBehavior2():update() 
		
      -- if(player:isSpeaking() == false) then player:Say(tostring(myBehaviorResult)) end
        if((myBehaviorResult == BehaviorResult.Failed) or (myBehaviorResult == BehaviorResult.Succeeded)) then   
		
            self:StopWalk()
		elseif (myBehaviorResult ~= BehaviorResult.Working) then
			print(tostring(myBehaviorResult));
        end
  
   end
   
   --]]
end

function SuperSurvivor:StopWalk()
	
	--print(self:getName() .. " StopWalk");
	ISTimedActionQueue.clear(self.player)
	self.player:StopAllActionQueue()
	self.player:setPath2(nil)
	self.player:getModData().bWalking = false
	self.player:getModData().Running = false
	self:setRunning(false)
	self.player:setSneaking(false)	
	--self.player:clearVariables()
	--self.player:setMoving(false)
	--self.player:NPCSetRunning(false)
	self.player:NPCSetJustMoved(false)
	self.player:NPCSetAttack(false)
	self.player:NPCSetMelee(false)
	self.player:NPCSetAiming(false)
	--self.player:setPerformingAnAction(false)
	--self.player:setVariable("bPathfind", false)	
	--self.player:setVariable("bKnockedDown", false)	
	--self.player:setVariable("AttackAnim", false)
	--self.player:setVariable("BumpFall", false)

	--self.player:setVariable("IsPerformingAnAction", this::isPerformingAnAction, this::setPerformingAnAction);
	
end

function SuperSurvivor:ManageXP()

	local currentLevel
	local currentXP,XPforNextLevel
	local ThePerk
	for i=1, #SurvivorPerks do
		ThePerk = Perks.FromString(SurvivorPerks[i])
		if(ThePerk) then
			
			currentLevel = self.player:getPerkLevel(ThePerk)
			currentXP = self.player:getXp():getXP(ThePerk)
			XPforNextLevel = self.player:getXpForLevel(currentLevel+1)
			local display_perk = PerkFactory.getPerkName(Perks.FromString(SurvivorPerks[i]))
			--print(tostring(self:getName())..tostring(display_perk).." - "..tostring(currentXP).."/"..tostring(XPforNextLevel))
			if(currentXP >= XPforNextLevel) and (currentLevel < 10) then 
				self.player:LevelPerk(ThePerk)
				
				
				if( string.match(SurvivorPerks[i], "Blade") ) or ( SurvivorPerks[i] == "Axe" ) then
					display_perk = getText("IGUI_perks_Blade") .. " " .. display_perk
				elseif( string.match(SurvivorPerks[i], "Blunt") ) then
					display_perk = getText("IGUI_perks_Blunt") .. " " .. display_perk
				end
				
				self:Speak(getText("ContextMenu_SD_PerkLeveledUp_Before")..tostring(display_perk)..getText("ContextMenu_SD_PerkLeveledUp_After"))
			end
			--if(SurvivorPerks[i] == "Aiming") then self.player:Say(tostring(currentXP).."/"..tostring(XPforNextLevel)) end
		end
	end

end

function SuperSurvivor:getTaskManager()
	return self.MyTaskManager	
end
function SuperSurvivor:HasMultipleInjury()

	local bodyparts = self.player:getBodyDamage():getBodyParts()
	local total = 0
	for i=0, bodyparts:size()-1 do

		local bp = bodyparts:get(i)
		if(bp:HasInjury()) and (bp:bandaged() == false) then
			total = total + 1
			if(total > 1) then break end
		end
		
	end
	
	return (total > 1)

end
function SuperSurvivor:HasInjury()

	local bodyparts = self.player:getBodyDamage():getBodyParts()
	
	for i=0, bodyparts:size()-1 do

		local bp = bodyparts:get(i)
		if(bp:HasInjury()) and (bp:bandaged() == false) then
			return true
		end
		
	end
	
	return false

end

function SuperSurvivor:getID()

	if(instanceof(self.player,"IsoPlayer")) then return self.player:getModData().ID 
	else return 0 end

end
function SuperSurvivor:setID(id)

	self.player:getModData().ID = id;

end

function SuperSurvivor:delete()

	self.player:getInventory():emptyIt();
	self.player:setPrimaryHandItem(nil);
	self.player:setSecondaryHandItem(nil);
	self.player:getModData().ID = 0;
	local filename = getSaveDir() .. "SurvivorTemp";
	self.player:save(filename);
	self.player:removeFromWorld()
	self.player:removeFromSquare()
	--self.player:setX(9303);
	--self.player:setY(5709);
	--self.player:Despawn();
	self.player = nil;
	--self.o = nil;
	--self.TaskManager = nil
	
end

function SuperSurvivor:SaveSurvivorOnMap()

	if self.player:getModData().RealPlayer == true then return false end
	local ID = self.player:getModData().ID;
	
	if (ID ~= nil) then
	
		local x = math.floor(self.player:getX())
		local y = math.floor(self.player:getY())
		local z = math.floor(self.player:getZ())
		local key = x .. y .. z
		
		if(not SurvivorMap[key]) then SurvivorMap[key] = {} end
		
		SurvivorLocX[ID] = x
		SurvivorLocY[ID] = y
		SurvivorLocZ[ID] = z
		
		if (has_value(SurvivorMap[key],ID) == false) then
			
			local removeFailed = false;
			if(self.player:getModData().LastSquareSaveX ~= nil) then
				local lastkey = self.player:getModData().LastSquareSaveX .. self.player:getModData().LastSquareSaveY .. self.player:getModData().LastSquareSaveZ
				if(lastkey) and ( SurvivorMap[lastkey] ~= nil ) then
					table.remove(SurvivorMap[lastkey] , ID);
				else 
					removeFailed = true;
				end
			end
			
			if(removeFailed == false) then
				--print("saving survivor "..tostring(ID).." to key " .. tostring(key))
				table.insert(SurvivorMap[key], ID);			
				self.player:getModData().LastSquareSaveX = x;
				self.player:getModData().LastSquareSaveY = y;
				self.player:getModData().LastSquareSaveZ = z;
			end
		
		end
	
	end
end

function SuperSurvivor:SaveSurvivor()
	if self.player:getModData().RealPlayer == true then return false end
	local ID = self.player:getModData().ID;
	if(ID ~= nil) then
		--local filename = getWorld():getGameMode() .. "-" .. getWorld():getWorld() .. "-" .. "Survivor"..tostring(ID);
		local filename = getSaveDir() .. "Survivor"..tostring(ID);
		self.player:save(filename);
		--print("saved survivor "..tostring(ID))
		if(self.player ~= nil and self.player:isDead() == false ) then
			self:SaveSurvivorOnMap()		
		else			
			local group = self:getGroup()
			if(group) then 
				print("remove member "..self:getName().." from group because he died.")
				group:removeMember(self) 
			end
		end
		
	end
end


function SuperSurvivor:FindClosestOutsideSquare(thisBuildingSquare)

	if(thisBuildingSquare == nil) then return nil end 
	
	local bx=thisBuildingSquare:getX()
	local by=thisBuildingSquare:getY()
	local px=self.player:getX()
	local py=self.player:getY()
	local xdiff = AbsoluteValue(bx-px)
	local ydiff = AbsoluteValue(by-py)
	
	if(xdiff > ydiff) then
		if(px > bx) then
			for i=1,20 do
				local sq = getCell():getGridSquare(bx + i, by, 0)
				if(sq ~= nil and sq:isOutside()) then return sq end
			end
		else
			for i=1,20 do
				local sq = getCell():getGridSquare(bx - i, by, 0)
				if(sq ~= nil and sq:isOutside()) then return sq end
			end
		end
	else 
		if(py > by) then
			for i=1,20 do
				local sq = getCell():getGridSquare(bx, by + i, 0)
				if(sq ~= nil and sq:isOutside()) then return sq end
			end
		else
			for i=1,20 do
				local sq = getCell():getGridSquare(bx, by - i, 0)
				if(sq ~= nil and sq:isOutside()) then return sq end
			end
		end
	end

	return thisBuildingSquare
end

function SuperSurvivor:startReload()


end

function SuperSurvivor:ReadyGun(weapon)

	if(not weapon) or (not weapon:isAimedFirearm()) then return true end
	
	if weapon:isJammed() then
		weapon:setJammed(false)
	end	
	
	self:DebugSay("readygun " .. weapon:getCurrentAmmoCount() .. " " .. weapon:getMaxAmmo() .. " " .. self.EnemiesOnMe .. " " .. self.seenCount)
	
	if weapon:haveChamber() and not weapon:isRoundChambered() then
		if(ISReloadWeaponAction.canRack(weapon)) then
			ISReloadWeaponAction.OnPressRackButton(self.player, weapon)
			self:DebugSay(self:getName().." needs to rack gun")
			return true		
		end	
	end
		
	if(weapon:getMagazineType()) then

		if(weapon:isContainsClip() == false) then
			self:DebugSay(self:getName().." gun needs a magazine0:"..tostring(weapon:getMagazineType()))
			local magazine = weapon:getBestMagazine(self.player)
			if(magazine == nil) then magazine = self.player:getInventory():getFirstTypeRecurse(weapon:getMagazineType()) end
			if(magazine == nil) then 
				self:DebugSay(self:getName().." needs to spawn magazine1:" .. tostring(weapon:getMagazineType()))
				magazine = self.player:getInventory():AddItem(weapon:getMagazineType()); 
			end
			
			if magazine then
				local ammotype = magazine:getAmmoType();
				if (not self.player:getInventory():containsWithModule(ammotype)) and 
				(magazine:getCurrentAmmoCount()==0) and (SurvivorInfiniteAmmo) then
					magazine:setCurrentAmmoCount(magazine:getMaxAmmo())
				end
				
				self:DebugSay(self:getName().." trying to load magazine into gun")
				ISTimedActionQueue.add(ISInsertMagazine:new(self.player, weapon, magazine))
				ISReloadWeaponAction.ReloadBestMagazine(self.player, weapon)
				return	true		
			else
				self:DebugSay(self:getName().." error trying to spawn mag for gun?")
			end			
		end
		
		
		if weapon:isContainsClip() then
			local magazine = weapon:getBestMagazine(self.player)
			if(magazine == nil) then magazine = self.player:getInventory():getFirstTypeRecurse(weapon:getMagazineType()) end
			if(magazine == nil) then 
				self:DebugSay(self:getName().." needs to spawn magazine2:" .. tostring(weapon:getMagazineType()))
				magazine = self.player:getInventory():AddItem(weapon:getMagazineType()); 
			end
			if(self:gunAmmoInInvCount(weapon) < 1) and (SurvivorInfiniteAmmo) then
				
				local maxammo = magazine:getMaxAmmo()
				local amtype = magazine:getAmmoType()
				self:DebugSay(self:getName().." needs to spawn "..tostring(maxammo).." x " .. tostring(amtype))
				for i=0, maxammo do
					local am = instanceItem(amtype)
					self.player:getInventory():AddItem(am)
				end
			elseif(self:gunAmmoInInvCount(weapon) < 1) and (not ISReloadWeaponAction.canShoot(weapon)) and (not SurvivorInfiniteAmmo) then
				self:DebugSay(self:getName().." no clip ammo left")
				return false
			end
			
			if (self:gunAmmoInInvCount(weapon) < 1) and (weapon:getCurrentAmmoCount() > 0) then
				self:DebugSay(self:getName().." out of bullets but mag not empty, keep firing")		
				return true
			elseif (self.EnemiesOnMe == 0 and self.seenCount == 0 and weapon:getCurrentAmmoCount() < weapon:getMaxAmmo()) or (weapon:getCurrentAmmoCount() == 0) then
				ISTimedActionQueue.add(ISEjectMagazine:new(self.player, weapon))
			
				-- reload the ejected magazine and insert it
				self:DebugSay(self:getName().." needs to reload the ejected magazine and insert it")
				ISTimedActionQueue.queueActions(self.player, ISReloadWeaponAction.ReloadBestMagazine, weapon)
				return true
			else 
				self:DebugSay(self:getName().." mag already full (enough)")				
				return true
			end
		end
		
		local magazine = weapon:getBestMagazine(self.player)
		if magazine then
			ISInventoryPaneContextMenu.transferIfNeeded(self.player, magazine)
			ISTimedActionQueue.add(ISInsertMagazine:new(self.player, weapon, magazine))
			return true
		end
		-- check if we have an empty magazine for the current gun
		ISReloadWeaponAction.ReloadBestMagazine(self.player, weapon)
	else -- gun with no magazine
			
		if(self:gunAmmoInInvCount(weapon) < 1) and (SurvivorInfiniteAmmo) then
			
			local maxammo = weapon:getMaxAmmo()
			local ammotype = weapon:getAmmoType()
			self:DebugSay(self:getName().." needs to spawn ammo type:" .. tostring(ammotype))
			for i=0, maxammo do			
				local am = instanceItem(ammotype)
				self.player:getInventory():AddItem(am)
			end
		end
		
		-- if can't have more bullets, we don't do anything, this doesn't apply for magazine-type guns (you'll still remove the current clip)
		if weapon:getCurrentAmmoCount() >= weapon:getMaxAmmo() then
			self:DebugSay(self:getName().." ammo already max")
			return true
		end

		-- if there's bullets in the gun and we're in danger, just keep shooting
		if (weapon:getCurrentAmmoCount() > 0 and self.EnemiesOnMe > 0) then
			self:DebugSay("just keep shooting")
			return true
		elseif (weapon:getCurrentAmmoCount() > 0 and self.seenCount > 0 and not self:isReloading()) then
			self:DebugSay("empty the gun")
			return true
		end
		
		local ammoCount = ISInventoryPaneContextMenu.transferBullets(self.player, weapon:getAmmoType(), weapon:getCurrentAmmoCount(), weapon:getMaxAmmo())
		if ammoCount == 0 then
			self:DebugSay(self:getName().." no ammo")
			if(not ISReloadWeaponAction.canShoot(weapon)) then
				return false 
			else
				return true
			end
		elseif (self.seenCount == 0 and weapon:getCurrentAmmoCount() < weapon:getMaxAmmo()) or (weapon:getCurrentAmmoCount() == 0) and (not self:isReloading()) then
			self:DebugSay("reload")
			ISTimedActionQueue.add(ISReloadWeaponAction:new(self.player, weapon))
		end
		return true
	end
	
	if(not ISReloadWeaponAction.canShoot(weapon)) then
		return false 
	else
		return true
	end
	
	
end
function SuperSurvivor:needToReadyGun(weapon)
	
	if(weapon and self:usingGun() and not ISReloadWeaponAction.canShoot(weapon) ) then return true
	else return false end
	
end

function SuperSurvivor:gunAmmoInInvCount(gun)
	local ammoType = gun:getAmmoType()
	if ammoType then
		local ammoCount = self.player:getInventory():getItemCountRecurse(ammoType)
		--ammoCount = math.min(ammoCount, gun:getMaxAmmo() - gun:getCurrentAmmoCount())
		--local bullets = self.player:getInventory():getSomeType(gun:getAmmoType(), ammoCount);
		--if bullets and not bullets:isEmpty() then
			--self.bullets = bullets;
			--self.ammoCount = ammoCount;
			--print(self:getName().." has " ..  tostring(ammoCount) .." x " .. tostring(ammoType))
			return ammoCount
		--end
	end
	return 0
end

function SuperSurvivor:needToReload()

	local weapon = self.player:getPrimaryHandItem()
	if(not weapon) then return false end
	--print("needToReload");
	--print( tostring(not self:isReloading()) .. "and" .. tostring( self:usingGun()).. "and" .. tostring(weapon:getAmmoType()) .. "and" .. tostring(weapon:getCurrentAmmoCount()) .. "<" .. tostring(weapon:getMaxAmmo()) ) 
	if( not self:isReloading() and self:usingGun() and weapon:getAmmoType() and (weapon:getCurrentAmmoCount() < weapon:getMaxAmmo()) ) then return true
	else return false end
	
end

function SuperSurvivor:isReloading()
	
	--print(self:getName().." isReloading = ");
    --local queue = ISTimedActionQueue.queues[self.player]
    --if queue == nil then return false end
    --for k,v in ipairs(queue.queue) do
		--print("v:"..tostring(v))
		--print("k:"..tostring(k))
		--if(ISReloadWeaponAction == )
		--if(v.canRack ~= nil)  then --  this current is a reloading TA
		--	print("is reloading")
		--	return true
		--end
		--v:lol()
        --if v then return true end
    --end
	--print(self:getName().." isReloading end");
	return self.player:getVariableBoolean("isLoading")
		
end


function SuperSurvivor:giveWeapon(weaponType,equipIt )

	if ((weaponType == "AssaultRifle") or (weaponType == "AssaultRifle2"))  then weaponType = "VarmintRifle" end -- temporarily disable assult rifles
	
	local weapon = self.player:getInventory():AddItem(weaponType);
	if(weapon == nil) then return false end
	
	if(weapon:isAimedFirearm()) then 
		if(isModEnabled("ORGM")) then ORGM.setupGun(ORGM.getFirearmData(weapon), weapon) end
		self:setGunWep(weapon)
	else self:setMeleWep(weapon) end
	
	if(weapon:getMagazineType()~=nil) then
		self.player:getInventory():AddItem(weapon:getMagazineType());
	end
	
	if(equipIt) then 
		self.player:setPrimaryHandItem(weapon) 
		if(weapon:isRequiresEquippedBothHands() or weapon:isTwoHandWeapon()) then self.player:setSecondaryHandItem(weapon)  end
	end
	
	
	local ammotypes = getAmmoBullets(weapon,true);
	if(ammotypes) then 
		
		local bwep = self.player:getInventory():AddItem( MeleWeapons[ZombRand(1,#MeleWeapons)] ) -- give a beackup mele wepaon if using ammo gun
		if(bwep) then 
			self.player:getModData().weaponmele = bwep:getType() 
			self:setMeleWep(bwep)
		end
		
		local ammo = ammotypes[1]
		if(ammo) then
			local tempammoitem = self.player:getInventory():AddItem(ammo);
			if(tempammoitem ~= nil) then
				local groupcount = tempammoitem:getCount() ;
				local randomammo = math.floor(ZombRand(40,100)/groupcount);
				print("giving "..tostring(randomammo).." ".. ammo.. " to s for weapon:"..weapon:getType())
				for i=0, randomammo do
				self.player:getInventory():AddItem(ammo);
				end
			end
		end
		ammotypes = getAmmoBullets(weapon,false);
		self.player:getModData().ammoCount = self:FindAndReturnCount(ammotypes[1])
		
	else
		--print("no ammo types for weapon:"..weapon:getType())
	end
end

function SuperSurvivor:FindAndReturn(thisType)

	local item
	item = self.player:getInventory():FindAndReturn(thisType);

	
	if(not item) and (self.player:getSecondaryHandItem() ~= nil) and (self.player:getSecondaryHandItem():getCategory() == "Container") then item = self.player:getSecondaryHandItem():getItemContainer():FindAndReturn(thisType); end
	if(not item) and (self.player:getClothingItem_Back() ~= nil) then item = self.player:getClothingItem_Back():getItemContainer():FindAndReturn(thisType); end
			
	return item
	
end
function SuperSurvivor:FindAndReturnCount(thisType)

	if(thisType == nil) then return 0 end
	
	local count = 0
	count = count + self.player:getInventory():getItemsFromType(thisType):size()

	
	if(self.player:getSecondaryHandItem() ~= nil) and (self.player:getSecondaryHandItem():getCategory() == "Container") then count = count + self.player:getSecondaryHandItem():getItemContainer():getItemsFromType(thisType):size() end
	if(self.player:getClothingItem_Back() ~= nil) then count = count + self.player:getClothingItem_Back():getItemContainer():getItemsFromType(thisType):size() end
			
	return count
	
end

function SuperSurvivor:WeaponReady()
	local primary = self.player:getPrimaryHandItem()
	if(primary ~= nil) and (self.player ~= nil) and (instanceof(primary,"HandWeapon")) and (primary:isAimedFirearm()) then
	
		primary:setCondition(primary:getConditionMax())	
		primary:setJammed(false);
		primary:getModData().isJammed = nil 
		
		
		local ammo, ammoBox, result;
		
		local bulletcount = 0
		for i=1,#self.AmmoTypes do			
			bulletcount = bulletcount + self:FindAndReturnCount(self.AmmoTypes[i])
		end
		
		self.player:getModData().ammoCount = bulletcount
		
		for i=1, #self.AmmoTypes do	
			ammo = self:FindAndReturn(self.AmmoTypes[i])
			if(ammo) then break end
		end
		if(not ammo) and (SurvivorInfiniteAmmo) then 
			ammo = self.player:getInventory():AddItem(self.AmmoTypes[1])
		end
		
		if(not ammo) then
				self.TriggerHeldDown = false
				local index = 0
				for i=1,#self.AmmoBoxTypes do	
					index = i
					ammoBox = self:FindAndReturn(self.AmmoBoxTypes[i])
					if(ammoBox) then break end
				end
				
				if(ammoBox) then 
					
					local ORGMEnabled = false
					if(isModEnabled("ORGM")) then ORGMEnabled = true end
				
					local ammotype = self.AmmoTypes[index]
					inv = self.player:getInventory()
					
					local modl = ammoBox:getModule() .. "."
					
					local tempBullet = instanceItem(modl..ammotype)
					local groupcount = tempBullet:getCount()
					local count = 0
					if ORGMEnabled then 
						--print(ammoBox:getType())
						count = ORGM.getAmmoData(ammotype).BoxCount
					else
						count = (getBoxCount(ammoBox:getType()) / groupcount)
					end
										
					--print("box tyoe count was "..tostring(count))
					for i=1, count do
						--print("in loop!")
						inv:AddItem(modl..ammotype)
					end
					self:Speak("**".. getText("ContextMenu_SD_Opens_Before") .. ammoBox:getDisplayName() .. getText("ContextMenu_SD_Opens_After") ..  "*")
					ammoBox:getContainer():Remove(ammoBox)
					ammo = self.player:getInventory():FindAndReturn(ammotype);
				else
					--print("could not find ammo box for "..tostring(boxType))
				end
			
		else
			
		end
		
		if(not ISReloadWeaponAction.canShoot(primary)) then return self:ReadyGun(primary) 
		else return true end
		
	end
	
	return true
end


function SuperSurvivor:hasAmmoForPrevGun()
	if(self.AmmoTypes ~= nil) and (#self.AmmoTypes > 0) then 	
		
		local ammoRound
		for i=1,#self.AmmoTypes do		
			ammoRound = self:FindAndReturn(self.AmmoTypes[i])
			if(ammoRound) then break end
		end
		
		if (ammoRound ~= nil) then
			return true
		end
		
		local ammoBox 
		for i=1,#self.AmmoBoxTypes do		
			ammoBox = self:FindAndReturn(self.AmmoBoxTypes[i])
			if(ammoBox) then break end
		end
		
		if (ammoBox ~= nil) then
			return true
		end	
	end
	
	return false
end
function SuperSurvivor:reEquipGun()
	
	if(self.LastGunUsed == nil) then return false end
	if(self.player:getPrimaryHandItem() ~= nil and self.player:getPrimaryHandItem():isTwoHandWeapon()) then self.player:setSecondaryHandItem(nil) end 
	self.player:setPrimaryHandItem(self.LastGunUsed)
	if(self.LastGunUsed:isTwoHandWeapon()) then self.player:setSecondaryHandItem(self.LastGunUsed) end
	
	return true
	
end
function SuperSurvivor:reEquipMele()
	
	if(self.LastMeleUsed == nil) then return false end
	if(self.player:getPrimaryHandItem() ~= nil and self.player:getPrimaryHandItem():isTwoHandWeapon()) then self.player:setSecondaryHandItem(nil) end
	self.player:setPrimaryHandItem(self.LastMeleUsed)
	if(self.LastMeleUsed:isTwoHandWeapon()) then self.player:setSecondaryHandItem(self.LastMeleUsed) end
	
	return true
	
end

function SuperSurvivor:setMeleWep(handWeapon)

	self:Get():getModData().meleWeapon = handWeapon:getType()
	self.LastMeleUsed = handWeapon
	
	
end

function SuperSurvivor:setGunWep(handWeapon)

	self:Get():getModData().gunWeapon = handWeapon:getType()
	self.LastGunUsed = handWeapon
	
end

function SuperSurvivor:getMinWeaponRange()
	local out = 0.5
	if(self.player:getPrimaryHandItem() ~= nil) then
		if(instanceof(self.player:getPrimaryHandItem(),"HandWeapon")) then
			return self.player:getPrimaryHandItem():getMinRange()
		end
	end
	return out
end

function SuperSurvivor:Attack(victim)
	--if(self.player:getCurrentState() == SwipeStatePlayer.instance()) then return false end -- already attacking wait
	if(self.player:getModData().felldown) then return false end -- cant attack if stunned by an attack
	
	if not (instanceof(victim,"IsoPlayer") or instanceof(victim,"IsoZombie")) then return false end
	if(self:WeaponReady()) then
		if(instanceof(victim,"IsoPlayer") and IsoPlayer.getCoopPVP() == false) then
			ForcePVPOn = true;
			SurvivorTogglePVP();
		end
		
		--print(self:getName().."t walking2")
		self:StopWalk()
		self.player:faceThisObject(victim);
		
		if(self.UsingFullAuto) then self.TriggerHeldDown = true end
		if(self.player ~= nil) then 
			local distance = getDistanceBetween(self.player,victim)
			local minrange = self:getMinWeaponRange() + 0.1
			--print("distance was ".. tostring(distance))
			if(distance < minrange) or (self.player:getPrimaryHandItem() == nil) then
				--self:Speak("Shove!"..tostring(distance).."/"..tostring(minrange))
				self.player:setForceShove(true);
				self.player:setVariable("bShoveAiming", true);
				--self.player:setVariable("bDoShove", true);
				--self.player:setVariable("meleePressed", true);
				self.player:pressedAttack();
				self.player:NPCSetAttack(true);
				self.player:NPCSetMelee(true);  
				self.player:AttemptAttack(10.0);
				--self.player:DoAttack(0);
				if IsDamageBroken then
					victim:Hit(nil, self.player, 0, true, 0, false);
				end
			else
				--self:Speak("Attack!"..tostring(distance).."/"..tostring(minrange))
				self.player:NPCSetAttack(true);
				self.player:NPCSetMelee(false);
				--self.player:DoAttack(0);
				local gameVersion = getCore():getGameVersion()
				if IsDamageBroken then
					local weapon = self.player:getPrimaryHandItem();
					local damage = 0
					if (weapon ~= nil) then
						--damage = ZombRand(weapon:getMinDamage(), weapon:getMaxDamage());
						damage = weapon:getMaxDamage();
					end
					local shoveMaybe = false;
					local multiplier = 1.0; -- i dont know what this is
					victim:Hit(weapon, self.player, damage, shoveMaybe, multiplier, false);
				end
			end
			
		end
	else
		local pwep = self.player:getPrimaryHandItem()
		local pwepContainer = pwep:getContainer()
		if(pwepContainer) then pwepContainer:Remove(pwep) end -- remove temporarily so FindAndReturn("weapon") does not find this ammoless gun
		
		self:Speak(getSpeech("OutOfAmmo"));
		
		for i=1, #self.AmmoBoxTypes do
			self:getTaskManager():AddToTop(FindThisTask:new(self,self.AmmoBoxTypes[i],"Type",1))
		end
		for i=1, #self.AmmoTypes do
			self:getTaskManager():AddToTop(FindThisTask:new(self,self.AmmoTypes[i],"Type",20))
		end	
		self:setNeedAmmo(true)	
	
		local mele = self:FindAndReturn(self.player:getModData().weaponmele);
		if(mele) then 
			self.player:setPrimaryHandItem(mele) 
			if(mele:isRequiresEquippedBothHands()) then self.player:setSecondaryHandItem(mele) end
		else
			local bwep = self.player:getInventory():getBestWeapon();
			if(bwep) and (bwep ~= pwep) then 
				self.player:setPrimaryHandItem(bwep) ;
				if(bwep:isRequiresEquippedBothHands()) then self.player:setSecondaryHandItem(bwep) end
			else 
				bwep = self:getWeapon()
				if(bwep) then
					self.player:setPrimaryHandItem(bwep) ;
					if(bwep:isRequiresEquippedBothHands()) then self.player:setSecondaryHandItem(bwep) end
				else
					
					self.player:setPrimaryHandItem(nil) 
					self:getTaskManager():AddToTop(FindThisTask:new(self,"Weapon","Category",1))
				
				end
			end
		end
		
		if(pwepContainer) and (not pwepContainer:contains(pwep)) then pwepContainer:AddItem(pwep) end -- re add the former wepon that we temp removed
		
	end

end

function SuperSurvivor:DrinkFromObject(waterObject)
    local playerObj = self.player
	self:Speak(getText("ContextMenu_SD_Drinking"))
	if not waterObject:getSquare() or not luautils.walkAdj(playerObj, waterObject:getSquare()) then
		return
	end
	local waterAvailable = waterObject:getWaterAmount()
	local waterNeeded = math.min(math.ceil(playerObj:getStats():getThirst() * 10), 10)
	local waterConsumed = math.min(waterNeeded, waterAvailable)
	ISTimedActionQueue.add(ISTakeWaterAction:new(playerObj, nil, waterConsumed, waterObject, (waterConsumed * 10) + 15));
end

function SuperSurvivor:findNearestSheetRopeSquare(down)

	local sq, CloseSquareSoFar;
		local range = 20
		local minx=math.floor(self.player:getX() - range);
		local maxx=math.floor(self.player:getX() + range);
		local miny=math.floor(self.player:getY() - range);
		local maxy=math.floor(self.player:getY() + range);
		local closestSoFar = 999;
		
		for x=minx, maxx do
			for y=miny, maxy do
				sq = getCell():getGridSquare(x,y,self.player:getZ());
				if(sq ~= nil) then
					local distance = getDistanceBetween(sq,self.player)
				
					if down and (distance < closestSoFar) and self.player:canClimbDownSheetRope(sq) then
						closestSoFar = distance
						CloseSquareSoFar = sq
					elseif not down and (distance < closestSoFar) and self.player:canClimbSheetRope(sq) then
						closestSoFar = distance
						CloseSquareSoFar = sq
					end
				
				end
			end
		end
		
	return CloseSquareSoFar
end

function SuperSurvivor:isAmmoForMe(itemType)

	if(self.AmmoTypes) and (#self.AmmoTypes > 0) then		
		for i=1, #self.AmmoTypes do		
			if(itemType == self.AmmoTypes[i]) then return true end
		end	
	end
	if(self.AmmoBoxTypes) and (#self.AmmoBoxTypes > 0) then		
		for i=1, #self.AmmoBoxTypes do		
			if(itemType == self.AmmoBoxTypes[i]) then return true end
		end	
	end
		-- AmmoTypesBox
	return false

end

function SuperSurvivor:FindThisNearBy(itemType, TypeOrCategory)
				
	if(self.GoFindThisCounter > 0) then return nil end
	
	self.GoFindThisCounter = 10;
	local sq, itemtoReturn;
	local range = 30
	--local minx=math.floor(self.player:getX() - range);
	--local maxx=math.floor(self.player:getX() + range);
	--local miny=math.floor(self.player:getY() - range);
	--local maxy=math.floor(self.player:getY() + range);
	local closestSoFar = 999;
	if(self.player:getZ() > 0) or (getCell():getGridSquare(self.player:getX(),self.player:getY(),self.player:getZ() + 1) ~= nil) then
		zhigh = self.player:getZ() + 1
	else
		zhigh = 0
	end
	
	--print("find " .. itemType)
	for z=0, zhigh do
		--for x=minx, maxx do
		--	for y=miny, maxy do
		local spiral = SpiralSearch:new(self.player:getX(), self.player:getY(), range)
		local x, y
		--print(spiral:forMax())

		for i = spiral:forMax(), 0, -1 do
					
			x = spiral:getX()
			y = spiral:getY()
			--print(x .. ", " .. y)

			sq = getCell():getGridSquare(x,y,z);
			if(sq ~= nil) then
				local tempDistance = 0--getDistanceBetween(sq,self.player)
				if (self.player:getZ() ~= z) then tempDistance = tempDistance + 10 end
				local items = sq:getObjects()
				-- check containers in square
				--print(items:size() .. " objects")
				for j=0, items:size()-1 do
					--print(tostring(items:get(j):getObjectName())..":"..tostring(items:get(j):getContainer())..","..tostring(items:get(j):hasWater()))
					if(items:get(j):getContainer() ~= nil) then
						local container = items:get(j):getContainer()
						--print("container with " ..tostring(container:getCapacity()))
						
						if(sq:getZ() ~= self.player:getZ()) then tempDistance = tempDistance + 13 end
						
						local FindCatResult
						--if(itemType == "Food") then 
						--	FindCatResult = FindAndReturnBestFood(container)
						--else 
							FindCatResult = MyFindAndReturnCategory(container, itemType, self) 
						--end
						--print("FindCatResult: " .. tostring(FindCatResult))
						
						if(tempDistance<closestSoFar) 
							and (
								(TypeOrCategory == "Category")
								and (FindCatResult ~= nil)
							) or (
								(TypeOrCategory == "Type")
								and (container:FindAndReturn(itemType)) ~= nil
							) then
							
							if (TypeOrCategory == "Category")  then
								itemtoReturn = FindCatResult
							else
								itemtoReturn = container:FindAndReturn(itemType)
							end

							if itemtoReturn:isBroken() then
								itemtoReturn = nil
							else
								closestSoFar = tempDistance
							end
							
						end	
					elseif(itemType == "Water") and (items:get(j):hasWater()) and (tempDistance<closestSoFar) then
						itemtoReturn = items:get(j)
						closestSoFar = tempDistance
					elseif(itemType == "WashWater")
							and (items:get(j):hasWater()) 
							and (items:get(j):getWaterAmount() > 5000 or items:get(j):isTaintedWater())
							and (tempDistance<closestSoFar) then
						itemtoReturn = items:get(j)
						closestSoFar = tempDistance
					end
				end	
				
				-- check floor
				if itemtoReturn ~= nil then
					self.TargetSquare = sq
				else
					if (itemType == "Food") then
						local item = FindAndReturnBestFoodOnFloor(sq, self)

						if (item ~= nil) then
							itemtoReturn = item
							closestSoFar = tempDistance
							self.TargetSquare = sq
						end
					else
						items = sq:getWorldObjects()
						--print("Checking " .. tostring(items:size()) .. " world objects.")
						for j=0, items:size()-1 do
							if(items:get(j):getItem()) then
								local item = items:get(j):getItem()
								--print(tostring(item:getType()).."("..tostring(item:isBroken()).."/"..tostring(item:getCondition()).."):"..itemType)
								if (tempDistance < closestSoFar) and 
								(item ~= nil) and 
								(not item:isBroken()) and
								(
									((TypeOrCategory == "Category") and (myIsCategory(item,itemType))) or 
									((TypeOrCategory == "Type") and (tostring(item:getType()) == itemType or tostring(item:getName()) == itemType))
								) then
									--print("hit "..tempDistance)
									itemtoReturn = item
									closestSoFar = tempDistance
									self.TargetSquare = sq
								end
							end
						end
					end
				end
			
				
				
			end

			if (self.TargetSquare ~= nil and itemtoReturn ~= nil) then
				break
			end

			spiral:next()
			
		end
		--	end						
		--end

		if (self.TargetSquare ~= nil and itemtoReturn ~= nil) then
			break
		end
	end
		
	if(self.TargetSquare ~= nil and itemtoReturn ~= nil) and (self.TargetSquare:getRoom()) and (self.TargetSquare:getRoom():getBuilding()) then 
		self.TargetBuilding = self.TargetSquare:getRoom():getBuilding() 
		--print("target building set")
	end
	return itemtoReturn
			
end

function SuperSurvivor:ensureInInv(item)

	if(self:getBag():contains(item)) then self:getBag():Remove(item) end
	if(item:getWorldItem() ~= nil) then
		item:getWorldItem():removeFromSquare()
		item:setWorldItem(nil)
	end
	if(not self:Get():getInventory():contains(item)) then self:Get():getInventory():AddItem(item) end

	return item
end

------------------armor mod functions-------------------

function SuperSurvivor:getUnEquipedArmors()

	local armors = {}
	local inv = self.player:getInventory()
	local items = inv:getItems()
	
	for i=1, items:size()-1 do
		local item = items:get(i)
		--if item ~= nil then print ("checking: "..tostring(item:getDisplayName()) .. "/" .. tostring(item:getCategory()) .. "/" .. tostring(item:isEquipped())) end
		if item ~= nil and ((item:getCategory() == "Clothing") or (item:getCategory() == "Container" and item:getWeight() > 0) ) and item:isEquipped() == false then 
			table.insert(armors,item) 
			--print("added "..item:getDisplayName() .. " to table")
			--getSpecificPlayer(0):Say("added "..item:getDisplayName() .. " to table")
		end
	end

	return armors
end


function SuperSurvivor:SuitUp(SuitName)
		--print("Suiting up with:"..SuitName)

		-- reset
		self.player:clearWornItems();
		self.player:getInventory():clear();

		self.player:setWornItem("Jacket", nil);
		--Suits = {}
		--Suits["Army"] = {"Base.Hat_BeretArmy","Base.Jacket_CoatArmy","Base.Trousers_ArmyService","Base.Shoes_ArmyBoots"}
		--Suits["Gangster"] = {"Base.Hat_BaseballCapGreen_Reverse","Base.Trousers_JeanBaggy","Base.Shoes_RedTrainers"}
		
		if(SuitName == "Army") then
			self:WearThis("Base.Hat_BeretArmy");
			self:WearThis("Base.Tshirt_ArmyGreen");
			self:WearThis("Base.Jacket_CoatArmy");
			self:WearThis("Base.Trousers_ArmyService");
			self:WearThis("Base.Shoes_ArmyBoots");
			if(isModEnabled("Brita_2")) then
				self:WearThis("Brita_2.Bag_Plate_Carrier");
				self:WearThis("Brita_2.Bag_D3M")
			end
		elseif(SuitName == "Gangster") then
			local result = ZombRand(3)
			if(result == 1) then self:WearThis("Base.HoodieUP_WhiteTINT");
			elseif(result == 2) then self:WearThis("Base.HoodieDOWN_WhiteTINT");
			else self:WearThis("Base.Hat_BaseballCapGreen_Reverse") end
			self:WearThis("Base.Trousers_JeanBaggy");
			self:WearThis("Base.Shoes_RedTrainers");
		elseif(SuitName == "Survivalist") then
			self:WearThis("Base.Ghillie_Top");
			self:WearThis("Base.Ghillie_Trousers");
			self:WearThis("Base.Shoes_BlackBoots");
		elseif(SuitName == "Hunter") then
			self:WearThis("Base.Hat_BonnieHat_CamoGreen");
			self:WearThis("Base.Vest_Hunting_Camo");
			self:WearThis("Base.Trousers_CamoGreen");
			self:WearThis("Base.Shoes_BlackBoots");
		elseif(SuitName == "MarinesCamo") then
			self:WearThis("Base.Hat_Army");
			self:WearThis("Base.Tshirt_CamoGreen");
			self:WearThis("Base.Shirt_CamoGreen");
			self:WearThis("Base.Jacket_ArmyCamoGreen");
			self:WearThis("Base.Vest_BulletArmy");
			self:WearThis("Base.Trousers_CamoGreen");
			self:WearThis("Base.Shoes_ArmyBoots");
			if(isModEnabled("Brita_2")) then
				self:WearThis("Brita_2.Hat_Helmet_Headset");
				self:WearThis("Brita_2.Bag_D3M")
			else
				self:WearThis("Base.Bag_ALICEpack")
			end
		elseif(SuitName == "ArmyCamo") then
			self:WearThis("Base.Tshirt_CamoDesert");
			self:WearThis("Base.Shirt_CamoDesert");
			self:WearThis("Base.Jacket_ArmyCamoDesert");
			self:WearThis("Base.Trousers_CamoDesert");
			self:WearThis("Base.Shoes_ArmyBootsDesert");
			if(isModEnabled("Brita_2")) then
				self:WearThis("Brita_2.Hat_FAST_Opscore");
				self:WearThis("Brita_2.Hat_Sordin");
				self:WearThis("Brita_2.Bag_Plate_Carrier");
				self:WearThis("Brita_2.Bag_D3M")
			else
				self:WearThis("Base.Bag_ALICEpack")
			end
		elseif(SuitName == "Chef") then
			self:WearThis("Base.Hat_ChefHat");
			self:WearThis("Base.Jacket_Chef");
			self:WearThis("Base.Trousers_Chef");
			self:WearThis("Base.Shoes_Black");
		elseif(SuitName == "Fireman") then
			self:WearThis("Base.Hat_Fireman");
			self:WearThis("Base.Jacket_Fireman");
			self:WearThis("Base.Trousers_Fireman");
			self:WearThis("Base.Shoes_BlackBoots");
		elseif(SuitName == "Doctor") then
			self:WearThis("Base.Hat_SurgicalCap_Blue");
			self:WearThis("Base.JacketLong_Doctor");
			self:WearThis("Base.Trousers_Scrubs");
			self:WearThis("Base.Shoes_Black");
		elseif(SuitName == "Police") then
			self:WearThis("Base.Hat_Police_Grey");
			self:WearThis("Base.Jacket_Police");
			self:WearThis("Base.Trousers_PoliceGrey");
			self:WearThis("Base.Shoes_BlackBoots");
		elseif(SuitName == "Farmer") then
			self:WearThis("Base.Boilersuit");
			self:WearThis("Base.Dungarees");
			self:WearThis("Base.Shoes_BlackBoots");
		elseif(SuitName == "Guard") then
			self:WearThis("Base.Shirt_PrisonGuard");
			self:WearThis("Base.Trousers_PrisonGuard");
			self:WearThis("Base.Shoes_BlackBoots");
		elseif(SuitName == "Formal") then
			self:WearThis("Base.Shirt_FormalWhite");
			self:WearThis("Base.Trousers_WhiteTEXTURE");
			self:WearThis("Base.Shoes_Black");
		elseif(SuitName == "Spiffo") then
			self:WearThis("Base.SpiffoSuit");
			self:WearThis("Base.Hat_Spiffo");
			self:WearThis("Base.SpiffoTail");
		elseif(SuitName == "Santa") then
			self:WearThis("Base.Hat_SantaHat");
			self:WearThis("Base.JacketLong_Santa");
			self:WearThis("Base.Trousers_Santa");
			self:WearThis("Base.Shoes_BlackBoots");
		elseif(SuitName == "Hazmat") then
			self:WearThis("Base.Shoes_BlackBoots");
			self:WearThis("Base.HazmatSuit");					
		elseif(SuitName == "Leader") then
			self:WearThis("Base.Vest_BulletPolice");
			self:WearThis("Base.Shirt_Lumberjack");					
			self:WearThis("Base.Trousers_DefaultTEXTURE");					
			self:WearThis("Base.Shoes_Black");
		elseif(SuitName == "Worker") then
			self:WearThis("Base.Hat_HardHatYellow");
			self:WearThis("Base.Shirt_Workman");					
			self:WearThis("Base.Trousers_DefaultTEXTURE");					
			self:WearThis("Base.Shoes_BlackBoots");
		else -- random basic clothes
			
			getRandomSurvivorSuit(self)
		
			local hoursSurvived = math.min(math.floor(getGameTime():getWorldAgeHours() / 24.0), 28)
			local result = ZombRand(1, 72) + hoursSurvived
			
			if(result > 98) then -- 2% (at 28 days)
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_SurvivorBag"))
			elseif(result > 96) then -- 2%
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_ALICEpack"))
			elseif(result > 92) then -- 4%
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_BigHikingBag"))
			elseif(result > 80) then -- 12%
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_NormalHikingBag"))
			elseif(result > 60) then -- 20% / (12/72 or 16% at start)
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_DuffelBag"))	
			elseif(result > 48) then -- 12% / (12/72 or 16% at start)
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_Schoolbag"))
			elseif(result > 36) then -- 12% / (12/72 or 16% at start)
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_Satchel"))
			end
			--[[
			local result = ZombRand(6)
			if(result == 0) then
			self:WearThis("Base.Hat_BaseballCapBlue");
			self:WearThis("Base.Shirt_HawaiianRed");
			self:WearThis("Base.TrousersMesh_DenimLight");
			self:WearThis("Base.Shoes_Black");
			elseif(result == 1) then
			self:WearThis("Base.Hat_BaseballCapGreen");
			self:WearThis("Base.Shirt_HawaiianTINT");
			self:WearThis("Base.TrousersMesh_DenimLight");
			self:WearThis("Base.Shoes_Black");
			elseif(result == 2) then
			self:WearThis("Base.Hat_BaseballCapGreen");
			self:WearThis("Base.Shirt_HawaiianTINT");
			self:WearThis("Base.TrousersMesh_DenimLight");
			self:WearThis("Base.Shoes_Black");
			elseif(result == 3) then
			self:WearThis("Base.Tshirt_BusinessSpiffo");
			self:WearThis("Base.TrousersMesh_DenimLight");
			self:WearThis("Base.Shoes_Black");
			elseif(result == 4) then
			--self:WearThis("Base.Hat_BaseballCapGreen");
			self:WearThis("Base.Tshirt_PileOCrepe");
			self:WearThis("Base.TrousersMesh_DenimLight");
			self:WearThis("Base.Shoes_Black");
			else
			--self:WearThis("Base.Hat_BaseballCapGreen");
			self:WearThis("Base.Tshirt_McCoys");
			self:WearThis("Base.Trousers_DefaultTEXTURE_HUE");
			self:WearThis("Base.Shoes_Black");
			end
			]]
			
			
		end
end



function SuperSurvivor:getFilth()
	local filth = 0.0
	for i=0, BloodBodyPartType.MAX:index()-1 do
		filth = filth + self.player:getVisual():getBlood(BloodBodyPartType.FromIndex(i));
	end
	
	local inv = self.player:getInventory()
	local items = inv:getItems() ;
	if(items) then
		for i=1, items:size()-1 do
			local item = items:get(i)
			local bloodAmount = 0
			local dirtAmount = 0
			if instanceof(item, "Clothing") then
				if BloodClothingType.getCoveredParts(item:getBloodClothingType()) then
					local coveredParts = BloodClothingType.getCoveredParts(item:getBloodClothingType())
					for j=0, coveredParts:size()-1 do
						local thisPart = coveredParts:get(j)
						bloodAmount = bloodAmount + item:getBlood(thisPart)
					end
				end
				dirtAmount = dirtAmount + item:getDirtyness()
			elseif instanceof(item, "Weapon") then
				bloodAmount = bloodAmount + item:getBloodLevel()
			end
			filth = filth + bloodAmount + dirtAmount
		end
	end

	return filth
end


function SuperSurvivor:CleanUp(percent)


	for i=0, BloodBodyPartType.MAX:index()-1 do
		
		local currentblood = self.player:getVisual():getBlood(BloodBodyPartType.FromIndex(i));
		self.player:getVisual():setBlood(BloodBodyPartType.FromIndex(i), (currentblood * percent)); -- always cut 10% off current amount 
	end
	
	local washList = {}
		if (self.player:getClothingItem_Feet() ~= nil) then
		
			table.insert(washList,self.player:getClothingItem_Feet())
		end
		if (self.player:getClothingItem_Hands() ~= nil) then
		
			table.insert(washList,self.player:getClothingItem_Hands())
		end
		if (self.player:getClothingItem_Head() ~= nil) then
		
			table.insert(washList,self.player:getClothingItem_Head())
		end
		if (self.player:getClothingItem_Legs() ~= nil) then
		
			table.insert(washList,self.player:getClothingItem_Legs())
		end
		if (self.player:getClothingItem_Torso() ~= nil) then
		
			table.insert(washList,self.player:getClothingItem_Torso())
		end
		if (self.player:getWornItem("Jacket") ~= nil) then
		
			table.insert(washList,self.player:getWornItem("Jacket"))
		end
		

	--for i,item in ipairs(washList) do
	for i=1, #washList do
		local item = washList[i]
		--print("wash loop: "..tostring(item))
		
		local blood
		if instanceof(item, "Clothing") then
			if BloodClothingType.getCoveredParts(item:getBloodClothingType()) then
                local coveredParts = BloodClothingType.getCoveredParts(item:getBloodClothingType())
				if(coveredParts ~= nil) then
					for j=0, coveredParts:size()-1 do
						local part = coveredParts:get(j);
						if(part ~= nil) then
							blood = item:getBlood(part);
							item:setBlood(part, (blood * percent));
						else
							--print("coveredParts(j) was nil")
						end
						
					end
				else
					--print("BloodClothingType.getCoveredParts was nil")
				end
			end
			
			local dirty = item:getDirtyness();
			item:setDirtyness(dirty * percent);
		
			if(blood) then
				if(blood < 0.1) then item:setBloodLevel(0)
				else item:setBloodLevel(blood * percent) end
			end
		end
	end
	
	self.player:resetModel();

end

function SuperSurvivor:isEnemyInRange(enemy)
	if not enemy then 
		--print(self:getName().." enemy is nil")
		return false 
	end
	
	local result = self.player:IsAttackRange(enemy:getX(),enemy:getY(),enemy:getZ())
	--print(self:getName().." my attack range is: " .. tostring(self:getAttackRange()) .. " - " ..tostring(result))
	
	return result
end