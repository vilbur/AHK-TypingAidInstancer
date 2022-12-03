/**
	Class Folder
*/
Class Folder {
	
	__New($path_variation){
		this.path_variation := $path_variation
		;MsgBox,262144,, % this.path_variation, 2

	}
	/** createFolders
	*/
	createFolders(){
		;MsgBox,262144,, % this.path_variation, 10
		FileCreateDir, % this.path_variation
		;FileCreateDir, % this.path_variation "\\Wordlists"		
		
		return this
	}

	;/** test
	;*/
	;test(){
	;	MsgBox,262144,, Test, 2
	;
	;}
	
	
}

;/**
;	CALL CLASS FUNCTION
;*/
;Folder($path_variation:="value"){
;	return % new Folder($path_variation)
;}
;/**
;	EXECUTE CALL CLASS FUNCTION
;*/
;Folder()

