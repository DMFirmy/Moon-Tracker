local callbacks = {};

---
--- When the Moon Tracker Configuration window gets closed, it needs to call back any registered functions.
---
function onClose()
	for _,v in pairs(callbacks) do
		v();
	end
end

---
--- This allows you to register a function to be called when the Moon Tracker Configuration window is closed.
---
--- fCallback [function]: The function to be called when the window is closed.
---
function registerCloseCallback(fCallback)
	table.insert(callbacks, fCallback);
end

---
--- This allows you to remove a registered function from the close callback regsitration.
---
--- fCallback [function]: The function to be called unregistered.
---
function unregisterCloseCallback(fCallback)
	for k, v in pairs(callbacks) do
		if v == fCallback then
			callbacks[k] = nil;
		end
	end
end