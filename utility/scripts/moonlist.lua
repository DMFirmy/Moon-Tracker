-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

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
	local oWindow = createWindow();
	if bFocus then
		oWindow["name"].setFocus();
	end
	return oWindow;
end