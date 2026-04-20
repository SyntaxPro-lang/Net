````md
# 🚀 Networker
Lightweight Roblox networking module with a clean API and example usage.
---

## 📘 API
- **:Send(...)** → `FireClient()` / `FireAllClients()`
- **:On(...)** → `OnServerEvent` / `OnClientEvent`
- **:Invoke(...)** → *(WIP)*

---

## 🧪 Example
```lua
-- Server
Networker:On("eventName", function(player, msg)
	print(player.Name, msg)
end)

-- Client
local data = {1, 2, 3, 4, 6, 7}
Networker:Send(target, "eventName", data)
````

---

## ⚡ Notes

* Creates events for you
* Remote Functions and Remote Events Supported
