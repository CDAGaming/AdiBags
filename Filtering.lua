--[[
AdiBags - Adirelle's bag addon.
Copyright 2010 Adirelle (adirelle@tagada-team.net)
All rights reserved.
--]]

local addonName, addon = ...

addon.filters = {}

function addon:RegisterFilter(name, priority, Filter, PreFilter, PostFilter)
	tinsert(self.filters, {
		name = name,
		priority  = priority,
		Filter = Filter,
		PreFilter = PreFilter,
		PostFilter = PostFilter,
	})
end

local function sortFilters(a, b)
	return (a and a.priority or 0) > (b and b.priority or 0)
end

function addon:SetupFilters()
	self:SetupDefaultFilters()
	table.sort(self.filters, sortFilters)
end

function addon:PreFilter(event, container)
	for i, filter in pairs(self.filters) do
		if filter.PreFilter then
			filter.PreFilter(event, container)
		end
	end
end

function addon:Filter(bag, slot, itemId, link)
	for i, filter in pairs(self.filters) do
		local sectionName, stackType, stackData = filter.Filter(bag, slot, itemId, link)
		if sectionName then
			return sectionName, stackType, stackData
		end
	end
end

function addon:PostFilter(event, container)
	for i, filter in pairs(self.filters) do
		if filter.PostFilter then
			filter.PostFilter(event, container)
		end
	end
end