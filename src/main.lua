local sqlite3 = require('lsqlite3')
-- db = db or sqlite3.open_memory()
db = sqlite3.open_memory()
dbAdmin = require('DbAdmin').new(db)

PACKAGES = [[
  CREATE TABLE IF NOT EXISTS Packages (
    NAME TEXT PRIMARY KEY,
    PID TEXT,
    DESC TEXT,
    DOCS TEXT
  );
]]

VERSIONS = [[
  CREATE TABLE IF NOT EXISTS Versions (
    FILE_ID TEXT PRIMARY KEY,
    VERSION TEXT,
    NAME TEXT
  );
]]

function InitDb() 
  db:exec(PACKAGES)
  db:exec(VERSIONS)
  return "OK"
end


Handlers.add("Versions.Deploy", 
  function (msg) 
    return msg.Action == "Deploy"
  end,
  function (msg) 
    print('test')

    local version = dbAdmin:exec(string.format([[
        select VERSION from Versions where VERSION = '%s';
    ]], msg.Version))
    
    if version then
        Send({Target = msg.From, Data = "Chosen version for this package already exists." })
        print(string.format([[test %s]]), version)
        print("Chosen version for this package already exists.")
    end

    print('test')

    -- local user = dbAdmin:exec(string.format([[
    --     select NAME from Packages where NAME = '%s';
    -- ]], msg.Data))

    -- print(string.format([[test %s], user))

    -- if user then
    --     -- if user ~= msg.From then
    --     --     Send({Target = msg.From, Data = "Chosen version for this package already exists." })
    --     --     print("Chosen version for this package already exists.")
    --     -- end
    --     print(string.format([[test %s]], user))
    --     dbAdmin:exec(string.format([[
    --     INSERT INTO Versions (FILE_ID, VERSION, NAME) VALUES ("%s", "%s", "%s";
    --   ]], msg.Id, msg.Version, msg.Data))
    --   Send({
    --     Target = msg.From, 
    --     Action = "Versions.Deployed",
    --     Data = user,
    --   })
    -- end

    --   Send({
    --     Target = msg.From, 
    --     Action = "Versions.Deployed",
    --     Data = user,
    --   })

    -- print(string.format([[
    --     Deployed version '%s';
    --     ]], user))
    
    -- if user then
    --   -- add message
    --   dbAdmin:exec(string.format([[
    --     INSERT INTO Versions (FILE_ID, VERSION, SUB_VERSION, NAME) VALUES ("%s", "%s", "%s", "%s");
    --   ]], msg.Id, msg.Version, msg.SubVersion, msg.From ))
    --   -- get users to broadcast message too
    -- --   local users = Utils.map(
    -- --     function(u)
    -- --       return u.PID 
    -- --     end, 
    -- --     dbAdmin:exec([[ SELECT PID FROM Users; ]])
    -- --   )
    --   Send({
    --     Target = msg.From, 
    --     Data = msg.Data,
    --     Action = "Versions.Deployed"
    --     -- Version = msg.Version,
    --     -- SubVersion = msg.SubVersion,
    --   })
    --   print(string.format([[
    --     Deployed version '%s';
    --     ]], user))
    -- --   print(string.format(Deployed version "%s", "%s", msg.Version, msg.SubVersion))
    --   return "ok"
    -- else
    --   Send({Target = msg.From, Data = "Chosen package does not exist." })
    --   print("Chosen package does not exist.")
    -- end
  end
)

Handlers.add("DevChat.Register",
  function (msg)
    return msg.Action == "Register"
  end,
  function (msg)
    -- get user count
    local pkgCount = #dbAdmin:exec(
      string.format([[select * from Packages where NAME = "%s";]], msg.Data)
    )
    if pkgCount > 0 then
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

-- Handlers.add(
--   "DevChat.Deploy",
--   function (msg)
--     return msg.Action == "Deploy"
--   end,
--   function (msg) 
--     Handlers.utils.reply("pong")
--   end
-- )


return "OK"