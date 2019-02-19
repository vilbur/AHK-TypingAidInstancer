

/**
	Class Install
*/
Class Install {
	
	
	__New($typyng_aid_name){
		this.typyng_aid_name	:= $typyng_aid_name
		this.path_variation	:= A_LineFile "\..\..\..\Instances\\" this.typyng_aid_name
		;MsgBox,262144,, % this.path_variation, 2
		this._createFolders()
		this._createHardlinks()				
		this._copyFiles()
		
	}
	
	/** createFolders
	 */
	_createFolders(){
		$Folders	:= new Folder(this.path_variation)
					.createFolders()
	}
	/** createHardlinks
	*/
	_createHardlinks(){
		$Hardlink	:= new Hardlink(this.path_variation)
					.createHardlinks()
	}
	/** copyFiles
	*/
	_copyFiles(){
		$File	:= new TA_File(this.typyng_aid_name)
					.copyFiles()		
	}
	
}