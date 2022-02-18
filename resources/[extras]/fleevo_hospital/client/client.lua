-------------------------------
        -- NPC --
-------------------------------
CreateThread(function()
    Wait(100)
    for _,v in pairs (Config.NPC) do
        if DoesEntityExist(ped) then
            DeletePed(ped)
        end
        Wait(250)
        ped = CreateHospitalPed(v.model, v.coords, v.heading)
    end
end)
-------------------------------
        -- Export --
-------------------------------
CreateThread(function()
    local doctor = {}
    for _,v in pairs (Config.NPC) do
        doctor = {v.model}
    end
    exports['qtarget']:AddTargetModel(doctor, {
        options = {
            {
                event = "openmenu",
                icon = "fas fa-sign-in-alt",
                label = "Check In",
            },
        },
        distance = 2.5
    })
end)
-------------------------------
        -- Events --
-------------------------------
RegisterNetEvent('fleevo_hospital:StartTreatment')
AddEventHandler('fleevo_hospital:StartTreatment', function()
    if Config.CostMoney then
        ESX.TriggerServerCallback('fleevo_hospital:hasMoney', function(hasMoney)
            if hasMoney then
                TriggerServerEvent('fleevo_hospital:payBill', tonumber(Config.BillAmount))
                exports['mythic_notify']:DoHudText('success', 'You have been billed $' .. Config.BillAmount)
                GetTreatment("CheckIn")
                Nurse()
            elseif not hasMoney then
                return exports['mythic_notify']:DoHudText('error', 'You need $' .. Config.BillAmount .. ' in order to get treated.')
            end
        end)
    elseif not Config.CostMoney then
        GetTreatment("CheckIn")
        Nurse()
    end
end)

RegisterNetEvent('openmenu', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Pillbox Hospital",
            txt = ""
        },
        {
            id = 2,
            header = "Receive Treatment",
            txt = "Cost: $" .. Config.BillAmount,
            params = {
                event = "fleevo_hospital:StartTreatment",
                args = {
                }
            }
        },
    })
end)
-------------------------------
       -- Functions --
-------------------------------
GetTreatment = function(action)
if action == "CheckIn" then
    SetEntityCoords(PlayerPedId(), 351.37716674805, -583.1494140625, 44.206405639648 + 0.3)
    TriggerEvent('esx_ambulancejob:revive', PlayerPedId())
    SetEntityHealth(PlayerPedId(), 200)
    Wait(1000)
    TreatmentInProgress()
    Wait(500)
    CreateThread(function()
        local CheckIn = true
		while CheckIn do
		    if currentView ~= 4 then
		    DisableActions(PlayerPedId())
            exports.rprogress:Custom({
                Async = true,
                Duration = 22500,
                Label = "Being Treated. . . ",
                Easing = "easeLinear",
                Radius = 60,
                Stroke = 10,
                DisableControls = {
                    Mouse = false,
                    Player = false
                    }
                },
                function(e)
                if not e then
                ClearPedTasks(PlayerPedId())
                end
            end)
        Wait(22100)
                ClearPedTasksImmediately(PlayerPedId())
                CheckIn = false
                DoScreenFadeIn(50)
                exports['mythic_notify']:DoHudText('error', 'You have been treated and can go on your way.')
                SetEntityCoords(PlayerPedId(), 316.55, -584.42, 43.32)
                SetEntityHeading(PlayerPedId(), 351.02)
                RequestAnimSet("move_m@drunk@slightlydrunk")
                while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
                    Wait(0)
                end
                SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", true)
                StartScreenEffect('drugsmichaelaliensfightout', 0, true)
                Wait(10000)
                StartScreenEffect('drugsmichaelaliensfightout', 0, true)
                Wait(10000)
                StopAllScreenEffects(PlayerPedId())
                ResetPedMovementClipset(PlayerPedId(), 0)
                end
            end
        end)
    end
end

TreatmentInProgress = function()
    SetEntityCoords(PlayerPedId(), 317.88, -585.21, 44.22 + 0.3)
    RequestAnimDict('anim@gangops@morgue@table@')
    while not HasAnimDictLoaded('anim@gangops@morgue@table@') do
        Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), 'anim@gangops@morgue@table@' , 'ko_front' ,8.0, -8.0, -1, 1, 0, false, false, false )
    SetEntityHeading(PlayerPedId(), 335.05)
    InAction = true
end

Nurse = function()
    modelHash = `a_m_m_prolhost_01`
    RequestModel(modelHash)

    while not HasModelLoaded(modelHash) do
        Wait(1)
    end

    local NurseNPC = CreatePed(5, modelHash, 316.82, -579.40, 43.30, 178.70, false, false)
    SetEntityAsMissionEntity(NurseNPC)
	SetEntityInvincible(NurseNPC, true)
    Wait(1500)

    SetPedDesiredHeading(NurseNPC, 178.70)
    Wait(100)

    TaskGoStraightToCoord(NurseNPC, 316.67, -585.20, 43.28, 1.0, 5000, 251.89, 2.0)
    Wait(5000)

    TaskStartScenarioInPlace(NurseNPC, "PROP_HUMAN_BUM_BIN", 0, false)
    Wait(40000)
    TaskGoStraightToCoord(NurseNPC, 342.41, -581.68, 42.41, 1.0, 5000, 70.50, 2.0)
    Wait(5000)
    DeleteEntity(NurseNPC)
end

startAnim = function(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end

loadAnimDict = function(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

DisableActions = function()
    DisableAllControlActions(0)
	EnableControlAction(0, 1, true)
	EnableControlAction(0, 2, true)
	EnableControlAction(0, 245, true)
end

CreateHospitalPed = function(hash, coords, heading, animDict, animName)
    RequestModel(GetHashKey(hash))
    while not HasModelLoaded(GetHashKey(hash)) do
        Wait(5)
    end
    local ped = CreatePed(5, hash, coords, false, false)
    SetEntityHeading(ped, heading)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    FreezeEntityPosition(ped, true) 
    SetEntityInvincible(ped, true) 
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    while not TaskPlayAnim(ped, animDict, animName, 8.0, 1.0, -1, 17, 0, 0, 0, 0) do
        Wait(1000)
    end
    return ped
end
-------------------------------
        -- Debug --
-------------------------------
if Config.Debug then
    RegisterCommand("treatmenttest", function(source, args, rawCommand)
        TriggerEvent('openmenu')
    end)
end
