Citizen.CreateThread( function()
gitRepo = "https://github.com/fleevo32/fleevo_hospital.git"
resourceName = "fleevo_hospital ("..GetCurrentResourceName()..")"

function checkVersion(err, responseText, headers)
	curVersion = LoadResourceFile(GetCurrentResourceName(), "version")

	if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
		print("(fleevo_hospital) is out of date :( Visit the Git repo to update to the latest version!")
	else
		print("^6You are running the latest version of fleevo_hospital!^0")
	end
end

PerformHttpRequest("https://raw.githubusercontent.com"..gitRepo.."/master/version", checkVersion, "Checking Version")
end)