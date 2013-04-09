FeatureDefsView = LCS.class{}

function FeatureDefsView:init()
    local ebAmount = EditBox:New {
        text = "1",
        x = 310,
        bottom = 8,
        width = 50,
        OnKeyPress = {
            function(obj, ...)
                local currentState = SCEN_EDIT.stateManager:GetCurrentState()
                if currentState:is_A(AddFeatureState) then
                    currentState.amount = tonumber(obj.text) or 1
                end
            end
        }
    }

    self.featureDefsPanel = FeatureDefsPanel:New {
		name='features',
		x = 0,
		right = 20,
		OnSelectItem = {
			function(obj,itemIdx,selected)
				if selected and itemIdx > 0 then
                    local currentState = SCEN_EDIT.stateManager:GetCurrentState()
					if currentState:is_A(SelectFeatureTypeState) then
						selFeatureDef = self.featureDefsPanel.items[itemIdx].id
						CallListeners(currentState.btnSelectType.OnSelectFeatureType, selFeatureDef)
                        SCEN_EDIT.stateManager:SetState(DefaultState())
					else
						selFeatureDef = self.featureDefsPanel.items[itemIdx].id
                        SCEN_EDIT.stateManager:SetState(AddFeatureState(selFeatureDef, self.featureDefsPanel.teamId, self.featureDefsPanel, tonumber(ebAmount.text) or 1))
					end
                    local feature = FeatureDefs[selFeatureDef]
				end
			end,
		},
	}
    local playerNames, playerTeamIds = GetTeams()
    local teamsCmb = ComboBox:New {
        bottom = 1,
        height = SCEN_EDIT.conf.B_HEIGHT,
        items = playerNames,
        playerTeamIds = playerTeamIds,
        x = 100,
        width=120,
    }
    teamsCmb.OnSelect = {
        function (obj, itemIdx, selected) 
            if selected then
                self.featureDefsPanel:SelectTeamId(teamsCmb.playerTeamIds[itemIdx])
                local currentState = SCEN_EDIT.stateManager:GetCurrentState()
                if currentState:is_A(AddFeatureState) then
                    currentState.teamId = self.featureDefsPanel.teamId
                end
            end
        end
    }

	self.featureDefsPanel:SelectTeamId(teamsCmb.playerTeamIds[teamsCmb.selected])

    self.featuresWindow = Window:New {
        parent = screen0,
        caption = "Feature Editor",
        width = 487,
        height = 400,
        resizable = false,
        x = 1400,
        y = 500,
        children = {
            ScrollPanel:New {
                y = 15,
                x = 1,
                right = 1,
                bottom = SCEN_EDIT.conf.C_HEIGHT * 4,
                --horizontalScrollBar = false,
                children = {
                    self.featureDefsPanel
                },
            },
            Label:New {
                x = 1,
                width = 50,
                bottom = 8 + SCEN_EDIT.conf.C_HEIGHT * 2,
                caption = "Type:",
            },
            ComboBox:New {
                height = SCEN_EDIT.conf.B_HEIGHT,
                x = 50,
                bottom = 1 + SCEN_EDIT.conf.C_HEIGHT * 2,
                items = {
                    "Wreckage", "Other", "All",
                },
                width = 80,
                OnSelect = {
                    function (obj, itemIdx, selected) 
                        if selected then
                            self.featureDefsPanel:SelectFeatureTypesId(itemIdx)
                        end
                    end
                },
            },
            Label:New {
                x = 140,
                width = 50,
                bottom = 8 + SCEN_EDIT.conf.C_HEIGHT * 2,
                caption = "Wreck:",
            },
            ComboBox:New {
                height = SCEN_EDIT.conf.B_HEIGHT,
                x = 190,
                bottom = 1 + SCEN_EDIT.conf.C_HEIGHT * 2,
                items = {
                    "Units", "Buildings", "All",
                },
                width = 80,
                OnSelect = {
                    function (obj, itemIdx, selected) 
                        if selected then
                            self.featureDefsPanel:SelectUnitTypesId(itemIdx)
                        end
                    end
                },
            },
            Label:New {
                caption = "Terrain:",
                x = 270,
                bottom = 8 + SCEN_EDIT.conf.C_HEIGHT * 2,
                width = 50,
            },
            ComboBox:New {
                bottom = 1 + SCEN_EDIT.conf.C_HEIGHT * 2,
                height = SCEN_EDIT.conf.B_HEIGHT,
                items = {
                    "Ground", "Air", "Water", "All",
                },
                x = 330,
                width=80,
                OnSelect = {
                    function (obj, itemIdx, selected) 
                        if selected then
                            self.featureDefsPanel:SelectTerrainId(itemIdx)
                        end
                    end
                },
            },
            Label:New {
                caption = "Player:",
                x = 40,
                bottom = 8,
                width = 50,
            },
            teamsCmb,
            Label:New {
                caption = "Amount:",
                x = 250, 
                bottom = 8,
                width = 50,
            },
            ebAmount,
        }
    }
end
