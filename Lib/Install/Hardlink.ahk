/**
	Class Hardlink
*/
Class Hardlink {
	
	typing_aid_original_path	:= A_LineFile "\..\TypingAid\Original_Package\Source"

	__New($path_variation){
		this.path_variation := $path_variation
	}
	
	/** setTypingAidOriginalPath
	*/
	setTypingAidOriginalPath($typing_aid_original_path){
		this.typing_aid_original_path := $typing_aid_original_path
		return this
	}
	/** createMainFolders
	*/
	createHardlinks(){
		;File(this.typing_aid_original_path "\\Lib").hardlink(this.path_variation "\\Lib")
		;File(this.typing_aid_original_path "\\Includes").hardlink(this.path_variation "\\Includes")		
		;FileCreateDir, % this.path_variation
		;return this
	}

}
