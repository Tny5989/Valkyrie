--------------------------------------------------------------------------------
local function ByValue(name, search_value, domain)
    for _, value in pairs(domain) do
        if value[name] == search_value then
            return value
        end
    end

    return domain['']
end

--------------------------------------------------------------------------------
local function AllByValue(name, search_value, domain)
    local matches = {}
    for _, value in pairs(domain) do
        if value[name] == search_value then
            table.insert(matches, value)
        end
    end

    table.insert(matches, domain[''])
    return matches
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local Chambers = {}
Chambers.Values = {}

-- Nil Chamber
Chambers.Values['']   = { idx = 0, en = '' }

-- Chambers
Chambers.Values[08] = { idx = 08, tier = 03, en = 'Gerhilde\'s Chamber' }
Chambers.Values[09] = { idx = 09, tier = 03, en = 'Brunhilde\'s Chamber' }

--------------------------------------------------------------------------------
function Chambers.GetByProperty(key, value)
    return ByValue(tostring(key), value, Chambers.Values)
end

--------------------------------------------------------------------------------
function Chambers.GetAllByProperty(key, value)
    return AllByValue(tostring(key), value, Chambers.Values)
end

return Chambers
