![Repo-GitHub](https://img.shields.io/badge/dynamic/xml?color=blue&label=ZPM%20version&version&prefix=v&query=%2F%2FVersion&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbdeboe%2Fisc-yaml-utils%2Fmaster%2Fmodule.xml)
[![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fisc-yaml-utils&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fisc-yaml-utils)

# YAML Utils

## Usage

*Very* simple ObjectScript YAML-to-JSON converter:

```ObjectScript
set obj = ##class(YAML.Utils).FileToJSON("C:\temp\test.yaml", .sc)
zwrite obj
```

Additional `StringToJSON()` and `StreamToJSON()` methods do exactly what you'd expect them to (I hope!)

Note: I first put the script in place so I could quickly test https://github.com/lscalese/OpenAPI-Client-Gen on my own YAML Swagger def in the context of the Interoperability contest, so that's really the amount of testing it's seen. Those 5k lines of YAML aren't too bad to get started, but happy to accept PRs to make it more robust for other real-world YAML.

## Installation

Easy installation using [ZPM](https://github.com/intersystems-community/zpm) (pending approval):

```ObjectScript
USER> zpm
zpm: USER> install yaml-utils
 
[yaml-utils]    Reload START
[yaml-utils]    Reload SUCCESS
[yaml-utils]    Module object refreshed.
[yaml-utils]    Validate START
[yaml-utils]    Validate SUCCESS
[yaml-utils]    Compile START
[yaml-utils]    Compile SUCCESS
[yaml-utils]    Activate START
[yaml-utils]    Configure START
[yaml-utils]    Configure SUCCESS
[yaml-utils]    Activate SUCCESS
```

Otherwise just load the sole `YAML.Utils` class and start converting.
