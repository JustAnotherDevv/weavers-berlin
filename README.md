# REPM - Registry Package Manager 

REPM is first Package Manager for AOS with a goal of better code reusability. 

# Overview

I have created my package manager in Lua script that is deployed to AOS and can be used as a dev tool by other community members. Packages can be uploaded and fetched using nodejs script which in the future after bugfixes should be uploaded as official npm package and used as standalone tool.

## Features

- Registering packages in the registry on-chain ✅
- Registering packages in the registry from nodeJS ✅
- Fetching packages from chain and saving local copies of lua files ✅
- On-chain package versioning ✅
- ArNS integration for package names ❌
- Package updates ✅
- Reputation system for packages with ranking and warnings for potentially malicious code ❌
- On-chain dynamic loading for packages ❌

# Quickstart

- Install dependencies by running `npm i`.
- Verify installation - `ToDo`
- Run with `node index.js`

Example commands for lua scripts manager setup:
- ```
aos test-db1 -module=GYrbbe0VbHim_7Hi6zrOpHQXrSQz07XNtwCnfbFo2I0
```
- `.load src/main.lua`
- `InitDb()`
- `dbAdmin:tables()`
- ```
Send({Target = ao.id, Action = "Register", Data= "some-package-name", Desc="Lorem Ipsum Dolorem", Docs="https://google.com"})
```
- ```
Send({Target = ao.id, Data= "some-package-name", Action = "Deploy" Version="1.1"})
```



# Available Commands

- ToDo

# Future Plans

- Rewrite in Rust once there are AOS / Arweave SDKs for it.
- Private packages (still stored on arweave but in encrypted form so that only deployer can decrypt them. Might also be useful for alpha/beta version of packages before main public release).
- Better reputation system with nicer UI and option to flag malicious packages, potentially also frontend blacklist for these packages.