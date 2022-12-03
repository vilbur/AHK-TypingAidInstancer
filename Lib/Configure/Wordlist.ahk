/**
	Class Wordlist
*/
Class Wordlist {

	__New($typyng_aid_name){
		this.typyng_aid_name	:= $typyng_aid_name
		this.path_wordlist_source	:= A_WorkingDir "\InstancesSource"
		this.path_wordlist_target	:= A_WorkingDir "\Instances\\" this.typyng_aid_name "\wordlist.txt"
		;MsgBox,262144,, % this.path_wordlist_source
	}
	/** setWordlistsSource
	*/
	setWordlistsSource($wordlists_source){

		if(!RegExMatch( $wordlists_source, "i)" this.typyng_aid_name ))
			$wordlists_source .= "|" this.typyng_aid_name

		this.wordlists_source	:= StrSplit( $wordlists_source, "|")
		;dump(this.wordlists_source, this.typyng_aid_name, 0)
		return this
	}
	/** createWordlist
	 */
	createWordlist(){
		FileDelete, % this.path_wordlist_target
		;sleep, 1000
		For $index, $wordlist in this.wordlists_source
			this._appendToTargetWordlist( this.path_wordlist_source "\\" $wordlist "\Wordlist" )
	}
	/** _appendToTargetWordlist
	*/
	_appendToTargetWordlist($path_wordlists){
		;dump($path_wordlists, this.typyng_aid_name, 0)

		loop, % $path_wordlists "\*.txt", 0, 1
		{
			;Dump(A_LoopFileFullPath, "A_LoopFileFullPath", 1)
			FileRead, $aFileContents, %A_LoopFileFullPath%
			FileAppend, %$aFileContents%`n, % this.path_wordlist_target
		}

	}

}
