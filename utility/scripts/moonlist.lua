
function onInit()
end

function onClose()
end

function update()
	local bEditMode = (window.moodlist_iedit.getValue() == 1);
	window.idelete_header.setVisible(bEditMode);
	for _,w in ipairs(getWindows()) do
		w.idelete.setVisibility(bEditMode);
	end
end

function addEntry(bFocus)
	local bEditMode = (window.moodlist_iedit.getValue() == 1);
	local oWindow = createWindow();
	oWindow.idelete.setVisible(bEditMode);
	if bFocus then
		oWindow["name"].setFocus();
	end
	return oWindow;
end

function onSortCompare(w1, w2)
	local a = w1.getDatabaseNode();
	local b = w2.getDatabaseNode();
	return MoonManager.sortMoons(a, b);
end