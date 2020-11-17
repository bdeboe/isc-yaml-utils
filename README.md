# YAML Utils

Simple ObjectScript YAML-to-JSON converter:

```ObjectScript
set obj = ##class(YAML.Utils).FileToJSON("C:\temp\test.yaml", .sc)
zwrite obj
```
