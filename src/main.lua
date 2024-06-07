local sqlite3 = require('lsqlite3')
db = db or sqlite3.open_memory()
dbAdmin = require('DbAdmin').new(db)

PACKAGES = [[
  CREATE TABLE IF NOT EXISTS Packages (
    NAME TEXT PRIMARY KEY,
    PID TEXT,
    DESC TEXT,
    DOCS TEXT
  );
]]

-- MESSAGES = [[
--   CREATE TABLE IF NOT EXISTS Messages (
--     MSG_ID TEXT PRIMARY KEY,
--     PID TEXT,
--     Nick TEXT,
--     Body TEXT,
--     FOREIGN KEY (PID) REFERENCES Users(PID)
--   );
-- ]]

function InitDb() 
  db:exec(PACKAGES)
--   db:exec(MESSAGES)
end

Handlers.add("DevChat.Register",
  function (msg)
    return msg.Action == "Register"
  end,
  function (msg)
    -- get user count
    local userCount = #dbAdmin:exec(
      string.format([[select * from Packages where NAME = "%s";]], msg.Data)
    )
    if userCount > 0 then
      Send({Target = msg.From, Action = "Taken", Data = "Package name already taken. Try another one."})
      print("Package name already taken. Try another one.")
      return "Package name already taken. Try another one."
    end
    dbAdmin:exec(string.format([[
      INSERT INTO Packages (NAME, PID, DESC, DOCS) VALUES ("%s", "%s", "%s", "%s");
    ]], msg.Data, msg.From, msg.Desc, msg.Docs))
    Send({
      Target = msg.From,
      Action = "DevChat.Registered",
      Data = "Successfully Registered."
    })
    print("Registered " .. msg.Data)
  end 
)

-- Handlers.add("Chat.Broadcast", 
--   function (msg) 
--     return msg.Action == "Broadcast"
--   end,
--   function (msg) 
--     -- get user
--     local user = dbAdmin:exec(string.format([[
--       select PID, Nickname from Users where PID = "%s";
--     ]], msg.From))[1] 
    
--     if user then
--       -- add message
--       dbAdmin:exec(string.format([[
--         INSERT INTO Messages (MSG_ID, PID, Nick, Body) VALUES ("%s", "%s", "%s", "%s");
--       ]], msg.Id, user.ID, user.Nickname, user.Body ))
--       -- get users to broadcast message too
--       local users = Utils.map(
--         function(u)
--           return u.PID 
--         end, 
--         dbAdmin:exec([[ SELECT PID FROM Users; ]])
--       )
--       Send({
--         Target = msg.From, 
--         Action = "Broadcasted",
--         Broadcaster = msg.From,
--         Assignments = users,
--         Data = msg.Data,
--         Type = "normal",
--         Nickname = user.Nickname
--       })
--       print("Broadcasted Message")
--       return "ok"
--     else
--       Send({Target = msg.From, Data = "Not Registered" })
--       print("User not registered, can't broadcase")
--     end
--   end
-- )

return "OK"