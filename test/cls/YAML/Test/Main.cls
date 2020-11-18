Class YAML.Test.Main Extends %UnitTest.TestCase
{

Method GetBaseTestDir(Output separator As %String) As %String
{
    set separator = $s($$$isWINDOWS:"\",1:"/")
    // currentdir will be repo_root/test/cls/YAML/Test/
    quit $piece(..Manager.CurrentDir, separator, 1, *-4)_separator
}

Method TestFullSwagger() As %Status
{
    set sc = $$$OK
    try {
        set basedir = ..GetBaseTestDir(.separator)_"files"_separator

        // just check if it explodes for now
        for file = "iknow.yaml", "petstore.yaml" {
            set json = ##class(YAML.Utils).FileToJSON(basedir_file, .sc)
            do $$$AssertStatusOK(sc,"Checking file: '"_file_"'")
        }
        
    } catch (ex) {
        set sc = ex.AsStatus()
		do ..Manager.LogAssert(0,"Unexpected exception",$system.Status.GetErrorText(sc))
    }
    quit sc
}

}
