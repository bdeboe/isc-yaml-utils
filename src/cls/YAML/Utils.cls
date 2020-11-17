Class YAML.Utils [ Language = objectscript ]
{

ClassMethod FileToJSON(yamlPath As %String, Output sc As %Status) As %DynamicObject
{
	set stream = ##class(%Stream.FileCharacter).%New()
	set sc = stream.LinkToFile(yamlPath)
	quit:$$$ISERR(sc) ""
	quit ..StreamToJSON(stream, .sc)
}

ClassMethod StringToJSON(yaml As %String, Output sc As %Status) As %DynamicObject
{
	set stream = ##class(%Stream.TmpCharacter).%New()
	do stream.Write(yaml)
	quit ..StreamToJSON(stream, .sc)
}

ClassMethod StreamToJSON(yaml As %Stream.Object, Output sc As %Status) As %DynamicObject
{
	set sc = $$$OK
	try {
		kill stack
		set stack(0) = {}, 
			previousIndent = 0, 
			indentSize = 0, 
			inString = 0,
			key = "",
			newline = $c(13,10),
			lineNumber = 0
		
		while 'yaml.AtEnd {
			set line = $replace(yaml.ReadLine(),$c(9),"  "),
				indent = $$GetIndent(line),
				lineNumber = lineNumber+1
			//write indent," > ",line,!
			
			set stripped = $zstrip(line,"<>W"), 
				firstChar = $e(stripped)
			
			// skip empty lines
			continue:firstChar="" 
			
			// process comments
			if firstChar="#" {
				set string = stack(previousIndent).%Get("__comment")
				do stack(previousIndent).%Set("__comment", $s(string="":"",1:string _ newline) _ stripped)
				continue
			}
			
			
			set isArray = firstChar="-"
			if isArray && $$IsEmpty(stack(indent)) {
				// promote to array	
				set stack(indent) = []
				do stack(indent-1).%Set(key, stack(indent))
			}
			
			// hack for the odd case where JSON strings are injected
			if (firstChar="[") || (firstChar="{") {
				set inString = 1
			}
			
			if inString {
				if indent > previousIndent {
					set string = stack(previousIndent).%Get(key)
					set:$isobject(string) string = ""
					do stack(previousIndent).%Set(key, $s(string="":"",1:string _ newline) _ stripped)
					continue
				} else {
					set inString = 0
				}
			}
			
			set colon = $find(stripped,":")
			if (colon) {
				set key = $zstrip($e(stripped,1,colon-1),">W"), 
					value = $zstrip($e(stripped,colon,*),"<W")
				
				if $e(value)="[" {
					// parse array - try basic JSON parser
					try {
						set value = ##class(%DynamicAbstractObject).%FromJSON(value)
					} catch {
						// fall back to something really dumb for now
						set value = [ ($e(value,2,*-1)) ]
					}
				} elseif ($e(value)="""") || ($e(value)="'") {
					set value = $e(value,2,*-1)
				}
				
				if (value="") {
					set stack(indent+1) = {}
					do stack(indent).%Set(key, stack(indent+1))
				} elseif (value="|") {
					set inString = 1
				} else {
					do stack(indent).%Set(key, value)
				}
			} elseif isArray {
				// simple string value
				do stack(indent).%Push($zstrip($e(stripped,2,*),"<W"))
			}
			
			set previousIndent = indent
		}
		
	} catch (ex) {
		b
		set sc = ex.AsStatus()
	}
	quit $g(stack(0))
	
GetIndent(string)
	for i = 1:1 {
		quit:$e(string,i)'=" "
	}
	quit:i=1 0
	if 'indentSize { // first indent defines indent size
		set indentSize = i-1
	}
	quit (i-1)/indentSize
IsEmpty(obj) 
	quit $s($isobject(obj):'obj.%GetIterator().%GetNext(), 1:1)
}

}
