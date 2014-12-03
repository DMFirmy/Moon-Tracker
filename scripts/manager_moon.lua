 ---
 --- This array holds the string names for each moon phase.
 ---
local aMoonPhases = { -- String names for each moon phase
	"New Moon", "Waxing Crescent", "First Quarter", "Waxing Gibbous", "Full Moon", "Waning Gibbous", "Last Quarter", "Waning Crescent"
};

---
--- This function has been modified to include a launch message and perform some initialization that the CoreRPG
--- implementation of this file does not perform.
---
function onInit()
	-- send launch message
	local msg = {sender = "", font = "emotefont"};
	msg.text = "DMFirmy's Moon Tracker loaded.";
	ChatManager.registerLaunchMessage(msg);

	if User.isHost() then
		initializeDatabase();
	end
end

---
--- This function gets the string name for the current moon phase. 
---
function getPhaseName(nPhase)
	return aMoonPhases[nPhase];
end

---
--- This function sets up the required database nodes for storing Moon data
---
function initializeDatabase()
	DB.createNode("moons");
	DB.createNode("moons.epochday", "number");
	DB.createNode("moons.epochyear", "number");
	DB.createNode("moons.moonlist");

end

---
--- This function is used to calculate the phases of the moon for every day in the current year.
---
function calculateEpochDay()
	local nYear = CalendarManager.getCurrentYear();
	local nMonths = CalendarManager.getMonthsInYear();
	local nFirstDay = CalendarManager.getLunarDay(nYear, 1, 1);
	local nDaysInWeek = CalendarManager.getDaysInWeek();

	local epochyear = DB.getValue("moons.epochyear", 0);
	local epoch = DB.getValue("moons.epochday", 0);
	local aMoons = getMoons();

	if epochyear ~= nYear - 1 then
		epoch = getEpochDay(nYear, nMonths);
		
		DB.setValue("moons.epochyear", "number", nYear - 1);
		DB.setValue("moons.epochday", "number", epoch);
	end

	for nCurrentMonth = 1, nMonths do
		for nCurrentDay = 1, CalendarManager.getDaysInMonth(nCurrentMonth) do
			epoch = epoch + 1;
		end
	end
end

---
--- This function gets an array filled with the moonlist database entries, sorted by period (ASC)
---
function getMoons()	
	local tMoons = DB.getChildren("moons.moonlist");
	local aMoons = {};
			
	for k,v in pairs(tMoons) do
		table.insert(aMoons, v);
	end
	table.sort(aMoons, function(a,b) return a.getChild("period").getValue() < b.getChild("period").getValue() end);
	return aMoons;
end

---
--- This function is used to sort two moon database nodes. It sorts first by period, then by name.
---
function sortMoons(a, b)
	local aPeriod = a.getChild("period").getValue();
	local bPeriod = b.getChild("period").getValue();
	if aPeriod == bPeriod then
		local aName = a.getChild("name").getValue();
		local bName = b.getChild("name").getValue();

		return aName > bName;
	else
		return aPeriod > bPeriod;
	end
end
---
--- This function calculates the current moon phase based on the epoch day provided
---
--- oMoon [object]: This is the database node for the moon who's phase is being calculated.
--- nEpoch [number]: This is the day (calculated from day 0) that the phase is being calculated for.
---
function calculatePhase(oMoon, nEpoch)
	local cycle = oMoon.getChild("period").getValue();
	local x = ((nEpoch - oMoon.getChild("shift").getValue()) / cycle);
	local f = x - math.floor(x);
	return math.floor(f*8) + 1;
end

---
--- This function is used to calculate how many days it has been from day 0 to the first day of the current year,
--- which is used to track where the current moon phases are calculated from.
---
--- nYear [number] (optional): The year to calculate the epoch for. Defaults to CalendarManager.getCurrentYear().
--- nMonths [number] (optional): The number of months in the year. Defaults to CalendarManager.getMonthsInYear();
---
function getEpochDay(nYear, nMonths)
	nYear = nYear or CalendarManager.getCurrentYear();
	nMonths = nMonths or CalendarManager.getMonthsInYear();

	local epoch = 0;
	for nCurrentYear = 0, nYear - 1 do		
		for nCurrentMonth = 1, nMonths do
			epoch = epoch + CalendarManager.getDaysInMonth(nCurrentMonth, nCurrentYear);
		end
	end
	return epoch;
end