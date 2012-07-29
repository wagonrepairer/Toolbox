local Chili = WG.Chili
local screen0 = Chili.Screen0
local C_HEIGHT = 16
local B_HEIGHT = 24

DebugTriggerView = TriggerManagerListener:extends{}

function DebugTriggerView:init(parent)
    self.parent = parent
    self:Populate()
    SCEN_EDIT.model.triggerManager:addListener(self)
end

function DebugTriggerView:Populate()
    self.parent:ClearChildren()
    local triggers = SCEN_EDIT.model.triggerManager:getAllTriggers()
    for id, trigger in pairs(triggers)  do		
        local triggerPanel = MakeComponentPanel(self.parent)
        local maxChars = 15
        local lblTriggerName = Chili.Label:New {
            caption = trigger.name:sub(1, maxChars),
            width = 100,
            x = 1,
            parent = triggerPanel,
        }
        local btnExecuteTrigger = Chili.Button:New {
            caption = "Execute",
            right = B_HEIGHT + 120,
            width = 100,
--            x = 110,
            height = B_HEIGHT,
            parent = triggerPanel,
            OnClick = {
                function()
                    local cmd = ExecuteTriggerCommand(trigger.id)
                    SCEN_EDIT.commandManager:execute(cmd)
                end
            },
        }
        local btnExecuteTriggerActions = Chili.Button:New {
            caption = "Execute actions",
            right = 1,
            width = 120,
            height = B_HEIGHT,
            parent = triggerPanel,
            OnClick = {
                function() 
                    local cmd = ExecuteTriggerActionsCommand(trigger.id)
                    SCEN_EDIT.commandManager:execute(cmd)
                end
            },
        }
    end
end

function DebugTriggerView:Dispose()
    SCEN_EDIT.model.triggerManager:removeListener(self)
end

function DebugTriggerView:onTriggerAdded(triggerId)
    self:Populate()
end

function DebugTriggerView:onTriggerRemoved(triggerId)
    self:Populate()
end

