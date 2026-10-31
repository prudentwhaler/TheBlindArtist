-- Idea by HopsyWopsy with some code from AikoShen (https://github.com/Aikoyori/Balatro-Aikoyoris-Shenanigans)
GoingBlind = SMODS.current_mod

GoingBlind.custom_ui = function(modNodes)
	modNodes[#modNodes+1] = { n = G.UIT.R, config = { align = "cm", no_fill = true }, nodes = {
		UIBox_button({label = {localize('goingblind_toggletxt')}, button = "goblind_toggle_tooltip", minw = 5.5, minh = 0.8})
	}}
	
	G.goblind_area = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h, G.CARD_W, 0.95 * G.CARD_H,
		{ card_limit = 1, type = 'title', highlight_limit = 0, collection = true }
	)
	
	local c = Card(G.goblind_area.T.x + G.goblind_area.T.w / 2, G.goblind_area.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS['j_joker'], {bypass_discovery_center = true, bypass_discovery_ui = true})
	G.goblind_area:emplace(c)
	c.states.drag.can = false
	c.states.release_on.can = false
	
	modNodes[#modNodes+1] = { n = G.UIT.R, config = { align = "cm", padding = 0.1, no_fill = true }, nodes = {
		{ n = G.UIT.O, config = { object = G.goblind_area } }
	}}
end

function G.FUNCS.goblind_toggle_tooltip()
	G.debug_tooltip_toggle = not G.debug_tooltip_toggle
end

local tguiref = Tag.generate_UI
function Tag:generate_UI(...)
    local x = { tguiref( self, ... ) }
    if G.debug_tooltip_toggle then
		x[2].hover = function()
			play_sound('paper1', math.random()*0.1 + 0.55, 0.42)
			play_sound('tarot2', math.random()*0.1 + 0.55, 0.09)
		end
	end
    return unpack(x)
end

local taghoverref = G.FUNCS.hover_tag_proxy
function G.FUNCS.hover_tag_proxy(e)
    if not G.debug_tooltip_toggle then taghoverref(e) end
end

local nodehoverref = Node.hover
function Node:hover()
    if G.debug_tooltip_toggle then
        if self.config.h_popup then
			local function delobj(nodes)
				if #nodes <= 0 then return end
				for _, node in ipairs(nodes) do
					if node.config and node.config.object then 
						node.config.object:remove()
					end
					if node.nodes then
						delobj(node.nodes)
					end
				end
			end
            delobj(self.config.h_popup.nodes)
        end
        self.config.h_popup = nil
    end
    local ret = nodehoverref(self)
    return ret
end