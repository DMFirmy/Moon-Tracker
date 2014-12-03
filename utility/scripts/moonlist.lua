---
--- This method will update the moon list in the Moon Tracker Configuration window
--- when the edit button gets clicked to show or hide the delete buttons for each
--- moon entry in the list.
---
function update()
	local bEditMode = (window.moodlist_iedit.getValue() == 1);
	window.idelete_header.setVisible(bEditMode);
	for _,w in ipairs(getWindows()) do
		w.idelete.setVisibility(bEditMode);
	end
end

---
--- This method is used to configure a new moon entry and to add it to the list
--- of moon entries on the Moon Tracker Configuration window.
---
--- bFocus [boolean]: If set to true, the "name" field will be focused when the window is added.
---
function addEntry(bFocus)
	local bEditMode = (window.moodlist_iedit.getValue() == 1);
	local oWindow = createWindow();
	oWindow.idelete.setVisible(bEditMode);
	if bFocus then
		oWindow["name"].setFocus();
	end
	return oWindow;
end

---
--- This method is used to sort the list of moon entries.
---
function onSortCompare(w1, w2)
	local a = w1.getDatabaseNode();
	local b = w2.getDatabaseNode();
	return MoonManager.sortMoons(a, b);
end