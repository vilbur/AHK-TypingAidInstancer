/**
	Class File
*/
Class TA_File {

	main_files	:= ["Preferences.ini"]
	replace_files	:= []	; replace original package file, files which has been changed
	icons	:= ["TypingAid-Active.ico", "TypingAid-Inactive.ico"]

	typing_aid_original_path	:= A_LineFile "\..\TypingAid\Original_Package\Source"
	typing_aid_replace_path	:= A_LineFile "\..\TypingAid\Extends"

	__New($typyng_aid_name){
		this.typyng_aid_name	:= $typyng_aid_name
		this.variation_source_dir	:= A_LineFile "\..\..\..\InstancesSource\\" this.typyng_aid_name
		this.variation_installed_dir	:= A_LineFile "\..\..\..\Instances\\" this.typyng_aid_name
 	}

	/** copyFiles
	*/
	copyFiles(){
		this._copyMainFiles()
		this._copyTypingAidMainFile()
		this._copyIcons()
		return this
	}

	/** _copyMainFiles
	*/
	_copyMainFiles(){
		For $index, $file_name in this.main_files
			File( this.typing_aid_original_path "\\" $file_name).copy(this.variation_installed_dir "\\" $file_name, 1 )
	}
	/** _copyTypingAidMainFile
	*/
	_copyTypingAidMainFile(){
		File( this.typing_aid_replace_path "\\TypingAid.ahk").copy(this.variation_installed_dir "\\"this.typyng_aid_name "-TypingAid.ahk", 1 )
	}
	/** _copyExtendFiles
	*/
	_copyReplaceFiles(){
	}
	/** _copyIcons
	*/
	_copyIcons(){
		For $index, $file_icon in this.icons
			this._copyIcon($file_icon)
	}
	/** _copyIcon
	*/
	_copyIcon($file_icon){

		$icon_source	:= this.variation_source_dir "\\" $file_icon
		;$icon_variation	:= this.variation_installed_dir "\\" $file_icon

		if(!File($icon_source).exist())
			$icon_source	:= this.typing_aid_original_path "\\" $file_icon
		File( $icon_source).copy(this.variation_installed_dir "\\" $file_icon, 1 )
	}

}
