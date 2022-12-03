#SingleInstance force


#Include  %A_LineFile%\..\Install\Install.ahk
#Include  %A_LineFile%\..\Install\Folder.ahk
#Include  %A_LineFile%\..\Install\Hardlink.ahk
#Include  %A_LineFile%\..\Install\File.ahk

/**
	Class Install
*/
Class Install_Instaneces {
	ini	:= INI( A_LineFile "\..\..\config.ini")
	sections	:= this.ini.getSections()
	/** install
	*/
	install(){
		For $i, $typyng_aid_name in this.sections
			$TypingAid := new Install($typyng_aid_name)
		MsgBox,262144,TypingAidInstancer, Instances installed, 3
		ExitApp
	}
}


new Install_Instaneces().install()