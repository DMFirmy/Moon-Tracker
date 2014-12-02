local callbacks = {};

function onClose()
	for _,v in pairs(callbacks) do
		v();
	end
end

function registerCloseCallback(fCallback)
	table.insert(callbacks, fCallback);
end

function unregisterCloseCallback(fCallback)
	for k, v in pairs(callbacks) do
		if v == fCallback then
			callbacks[k] = nil;
		end
	end
end