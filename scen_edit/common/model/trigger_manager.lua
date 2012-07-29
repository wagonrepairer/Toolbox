TriggerManager = Observable:extends{}

function TriggerManager:init()
    self:super('init')
    self.triggerIdCount = 0
    self.triggers = {}
end

function TriggerManager:addTrigger(trigger)
    if trigger.id == nil then
        trigger.id = self.triggerIdCount + 1
    end
    self.triggerIdCount = trigger.id
    self.triggers[trigger.id] = trigger
    self:callListeners("onTriggerAdded", trigger.id)
    return trigger.id
end

function TriggerManager:removeTrigger(triggerId)
    if triggerId == nil then
        return
    end
    if self.triggers[triggerId] then
        self.triggers[triggerId] = nil
        self:callListeners("onTriggerRemoved", triggerId)
        return true
    else
        return false
    end
end

function TriggerManager:setTrigger(triggerId, value)
    self.triggers[triggerId] = value
    self:callListeners("onTriggerUpdated", triggerId)
end

function TriggerManager:getTrigger(triggerId)
    return self.triggers[triggerId]
end

function TriggerManager:getAllTriggers()
    return self.triggers
end

function TriggerManager:serialize()
    return SCEN_EDIT.deepcopy(self.triggers)
--[[    local retVal = {}
    for _, trigger in pairs(self.triggers) do
        retVal[trigger.id] = trigger
    end
    return retVal--]]
end

function TriggerManager:load(data)
    self:clear()
    self.triggerIdCount = 0
    for id, trigger in pairs(data) do
        self:addTrigger(trigger)
    end
end

function TriggerManager:clear()
    for triggerId, _ in pairs(self.triggers) do
        self:removeTrigger(triggerId)
    end
    self.triggerIdCount = 0
    self.triggers = {}
end
