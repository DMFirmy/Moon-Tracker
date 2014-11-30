local hasMoons = false;

function onInit()
	buildCalendarWindows();
	DB.addHandler("moons.moonlist","onChildAdded", onMoonCountUpdated);
	DB.addHandler("moons.moonlist","onChildDeleted", onMoonCountUpdated);
end

function rebuildCalendarWindows()
	closeAll();
	buildCalendarWindows();
end

function buildCalendarWindows()
	setMoonFrame();

	local nYear = CalendarManager.getCurrentYear();
	local aLunarWeek = CalendarManager.getLunarWeek();
	local nMonthsInYear = CalendarManager.getMonthsInYear();
	
	local nColumnWidth = (#aLunarWeek * 20) + 15;
	if nColumnWidth < 75 then
		nColumnWidth = 75;
	end
	setColumnWidth(nColumnWidth);

	for nMonth = 1, nMonthsInYear do
		local wMonth = createWindow();
		wMonth.month.setValue(nMonth);

		for i = 1, #aLunarWeek do
			local wHeader = wMonth.list_days.createWindow();
			wHeader.day.setValue(0);

			wHeader.label_day.setFont("calendarday-b");
			wHeader.label_day.setStateFrame("hover", "null", 0,0,0,0);
			wHeader.label_day.setValue(aLunarWeek[i]:sub(1,2));
		end
		
		local nLunarDay = CalendarManager.getLunarDay(nYear, nMonth, 1);
		for i = 2, nLunarDay do
			local wBlank = wMonth.list_days.createWindow();
			wBlank.day.setValue(0);
			wBlank.label_day.setStateFrame("hover", "null", 0,0,0,0);
		end
		
		local nDaysInMonth = CalendarManager.getDaysInMonth(nMonth);
		for i = 1, nDaysInMonth do
			local wDay = wMonth.list_days.createWindow();
			wDay.day.setValue(i);

			wDay.label_day.setValue(tostring(i));
			if CalendarManager.isHoliday(nMonth, i) then
				wDay.label_day.setTooltipText(CalendarManager.getHolidayName(nMonth, i));
			end
		end
	end
end

function scrollToCampaignDate()
	local nMonth = CalendarManager.getCurrentMonth();
	for _,v in pairs(getWindows()) do
		if v.month.getValue() == nMonth then
			scrollToWindow(v);
			break;
		end
	end
end

---
--- This function gets called whenever a moon is added or deleted to rebuild the calendar window.
---
function onMoonCountUpdated()
	rebuildCalendarWindows();
end

---
--- This function will set the bounds for the list frame and hide the moons frame when
--- there are no moons defined.
---
function setMoonFrame()
	hasMoons = false;
	local moons = DB.getChildren("moons.moonlist");
    for _,v in pairs(moons) do
        hasMoons = true;
        break;
    end
    if hasMoons then
		setStaticBounds( 25,135,-30,-65 );
		window.moons.setVisible(true);
	else
		setStaticBounds( 25,75,-30,-65 );
		window.moons.setVisible(false);
	end
end
