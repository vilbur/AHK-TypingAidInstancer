/**
	Class Preferences
*/
Class Preferences {

	__New($config, $typyng_aid_name)
	{
		;dump($config, $typyng_aid_name)
		this.config	:= $config
		this.typyng_aid_name	:= $typyng_aid_name
		this.path_pref_file	:= A_WorkingDir "\Instances\\" this.typyng_aid_name "\Preferences.ini"
		;dump(this.path_pref_file, "this.path_pref_file", 0)
		this._setupPreferences()
	}

	/** _setupPreferences
	*/
	_setupPreferences(){

		if(!File(this.path_pref_file))
			MsgBox,262144,, % "PREFERENCE FILE IS MISSING !`n`n" this.path_pref_file
		else{

			this.pref_file	:= INI( this.path_pref_file )	; preferences from file for this variation
			this.pref_config	:= this.config.get(this.typyng_aid_name)	; preferences from config  for this variation

			this._setProcessEnabled()
			this._setTitlesEnabled()
			this._setProcessDisabled()
			this._setTitlesDisabled()
		}
	}
	;/** Add tooltip with variation name to tray icon
	;   NOTE: Original TypingAid.ahk file is edited with:
	;		IniRead, $tooltip, %A_ScriptDir%\Preferences.ini, tooltip, text, TypingAid
	;		global $tooltip
	;*/
	;_setTooltip(){
	;	this.pref_file.set("tooltip","text", "TypingAid - " this.typyng_aid_name )
	;
	;}
	/** _setProcessEnabled
	*/
	_setProcessEnabled(){
		this._addOrRemoveValue("IncludePrograms","IncludeProgramExecutables", this.pref_config.process )
	}
	/** _setTitlesEnabled
	*/
	_setTitlesEnabled(){
		this._addOrRemoveValue("IncludePrograms","IncludeProgramTitles", this.pref_config.title )
	}
	/** _setProcessDisabled
	*/
	_setProcessDisabled(){
		this._addOrRemoveValue("ExcludePrograms","ExcludeProgramExecutables", this.pref_config.process_exclude ? this.pref_config.process_exclude : this._excludeOtherVariations("process") )
	}
	/** _setTitlesDisabled
	*/
	_setTitlesDisabled(){
		this._addOrRemoveValue("ExcludePrograms","ExcludeProgramTitles", this.pref_config.title_exclude ? this.pref_config.title_exclude : this._excludeOtherVariations("title") )
	}
	/** Add Or Remove Value from preferences
	*/
	_addOrRemoveValue($section, $key, $value){
		if($value!="")
			this.pref_file.set($section, $key, $value)
		else
			this.pref_file.delete($section, $key)
	}
	/** Get allowed "process" & "titles" of other variations
	*/
	_excludeOtherVariations($type){
		$enabled_current	:= this.pref_config[$type]
		$others	:= Arr(this.config.lists($type)).unique()
		$disabled_others	:= $others.remove($others.indexOf($enabled_current)).join("|")	; get get all excluded processes from config and join to string "title|secondTitle|anotherTitle"

		;dump("", "--------------", 0)
		;dump($others, "others-" $type, 0)
		;dump($enabled_current, "$enabled_current", 0)
		;dump($disabled_others, "disabled_others-" $type, 0)

		return %$disabled_others%
	}

	/** _removeDupliates
	*/
	;_removeDupliates($array, $duplicates){
	;	;dump( $array, "array", 1)
	;	;dump( $duplicates, "duplicates", 1)
	;	;$array := Obj_ToArray($array)
	;
	;	For $index, $duplicate in $duplicates
	;	{
	;		;dump( $duplicate, "duplicate", 1)
	;		$array := Array_Delete($array, Array_indexOf($array, $duplicate))
	;		;$array := Array_Delete($array, "chrome")
	;		;$array := Obj_ToArray($array)
	;	}
	;
	;	return %$array%
	;}

	;[ExcludePrograms]
	;ExcludeProgramExecutables=process_disabled
	;ExcludeProgramTitles=disabled_titles

	;[IncludePrograms]
	;IncludeProgramExecutables=process_enabled
	;IncludeProgramTitles=enable_titles

}
