#SingleInstance force
#Persistent

setWorkingDir,  %A_LineFile%\..\..\
/* Ahk-Lib includes
*/
#Include %A_LineFile%\..\..\Ahk-Lib\File\File.ahk
#Include %A_LineFile%\..\..\Ahk-Lib\Clip\Clip.ahk
#Include %A_LineFile%\..\..\Ahk-Lib\Ini\INI.ahk
#Include %A_LineFile%\..\..\Ahk-Lib\Array\Arr.ahk

/* TypingAidInstancer include
*/
#Include %A_LineFile%\..\InstanceProcess.ahk
#Include %A_LineFile%\..\Configure\Preferences.ahk
#Include %A_LineFile%\..\Configure\Wordlist.ahk

global $CLSID
global $allow_refresh	:= 1
global $Instancer	:= new Instancer()

/**
	Class Instancer
*/
Class Instancer {

	Ini	:= INI( A_LineFile "\..\..\config.ini")
	InstanceProcess	:= new InstanceProcess(this.Ini)
	instances	:= A_LineFile "\..\..\Instances"
	tray_refresh	:= A_LineFile "\..\System\SystemTrayRefresh.exe"
	path_icon	:= A_LineFile "\..\Icons\TypingAidInstancer.ico"

	__New(){
		this._traySet()
		this._installShellHook()
	}
	/** onWindowActivated
		EVENT WORK ONLY ONE TIME, WHEN DUMP() IS USED
	*/
	onWindowActivated($lParam){

		WinGet, $process_name, ProcessName, ahk_id %$lParam%
        WinGetTitle, $title, ahk_id %$lParam%
		if( $allow_refresh && $process_name=="")
			return
		;MsgBox,,, % "Process name:`n" $process_name, 2
		this.active_process_name 	:= $process_name
		this.active_title	:= $title

		this._setInstancesForLaunch()
		For $i, $instance_for_launch in this.instances_for_launch
			if($instance_for_launch && this._ifTitleIsIncluded($instance_for_launch))
				this.start($instance_for_launch)
		;$allow_refresh := 0
		;Run, %A_LineFile% ; RELAUNCH THIS SCRIPT (Icon for instancer will be first, ahead of TypingAid Instances)
	}
	/** configureAll
	*/
	configureAll(){
		For $typyng_aid_name, $data in this.ini.get()
			this.configure($typyng_aid_name)

		this.restartIsntances()
		MsgBox,262144,TypingAid, Instances configured, 2
		;sleep, 200000
		Reload
	}
	/** configure
	*/
	configure($typyng_aid_name){
		;MsgBox,262144,, configure
		;this.instances	:= "c:\GoogleDrive\Programs\Core\Autohotkey\Utilities\TypingAidInstancer\Instances" $typyng_aid_name "\TypingAid.ahk"
		new Preferences(this.Ini, $typyng_aid_name)
		new Wordlist($typyng_aid_name)
				.setWordlistsSource(this.Ini.get($typyng_aid_name, "wordlists"))
				.createWordlist()
	}

	/** start
	*/
	start($typyng_aid_name){
		$Path_instance := Path(A_LineFile "\..\..\Instances\\" $typyng_aid_name "\\" $typyng_aid_name "-TypingAid.ahk")
		;dump($Path_instance, "$Path_instance", 0)
		;dump($Path_instance.exist(true), "$Path_instance", 0)
		;sleep, 500000
		if($Path_instance.exist(true))
			Run, % $Path_instance.getPath(),,, $pid
	}
	/** restartIsntances
	*/
	restartIsntances(){
		For $typyng_aid_name, $pid in this.InstanceProcess.getRunningInstances()
			this.start($typyng_aid_name)
	}
	/** _setInstancesForLaunch
	*/
	_setInstancesForLaunch(){
		this.instances_for_launch := this.InstanceProcess.findInstanceToStart(this.active_process_name)
	}
	/** _ifTitleIsIncluded
	*/
	_ifTitleIsIncluded($instance_name){
		$tile_include := this.Ini.get($instance_name, "title")
		return RegExMatch( this.active_title, "i)" $tile_include )
	}
	/** _installShellHook
	*/
	_installShellHook(){
		Gui +LastFound
		$hWnd := WinExist()
		DllCall( "RegisterShellHookWindow", UInt, $hWnd )
		$MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
		OnMessage( $MsgNum, "TypingAid_OnWindowActivated" )
		Return
	}
	/** _traySet
	*/
	_traySet(){
		Menu, Tray, Tip, Instancer
		Menu, Tray, NoStandard ; remove standard Menu items
		Menu, Tray, Add , &Convert Komodo snippets to Wordlists, TypingAid_SetKomodoWordlists
		Menu, Tray, Add
		Menu, Tray, Add , &Install Instances, TypingAid_Install_Instances
		Menu, Tray, Add , &Configure, TypingAid_Configure
		Menu, Tray, Add
		Menu, Tray, Add , &Reload,	TypingAid_Reload
		Menu, Tray, Add , &Exit,	TypingAid_Exit
		Menu, tray, Icon, % A_LineFile "\..\Icons\TypingAidInstancer.ico",,0
	}
	/** Refresh system tray icons
		Requires utility 'SystemTrayRefresh' source: http://visualfantasy.tk/
	  */
	_trayRefresh(){
		;sleep, 1000
		;MsgBox,262144,, test, 2
		Run, % this.tray_refresh,,min
	}
	/**
	  */
    OnExit(){
		if(A_ExitReason!="Reload" && A_ExitReason!="Single")
			this.InstanceProcess.killAllInstances()
		else if(A_ExitReason=="Reload")
			this.InstanceProcess.killUnusedInstances()
		this._trayRefresh()
    }


}

/*
-----------------------------------------
	ENVETS FUNCTIONS
-----------------------------------------
*/

/* ON WINDOW ACTIVETED EVENT
*/
TypingAid_OnWindowActivated( $wParam, $lParam ){
	$Instancer.onWindowActivated($lParam)
}
/* ON SCRIPT EXIT
*/
OnExit(ObjBindMethod($Instancer, "OnExit"))

/*
-----------------------------------------
	MENU FUNCTIONS
-----------------------------------------
*/

/* ON WINDOW ACTIVETED EVENT
*/
TypingAid_Configure(){
	$Instancer.configureAll()
}
/* SCRIPT RELAOD
*/
TypingAid_Reload(){
	Reload
}
/* SCRIPT EXIT
*/
TypingAid_Exit(){
	ExitApp
}
/* SCRIPT Install Instances
*/
TypingAid_Install_Instances(){
	Run, %A_LineFile%\..\..\Install.ahk
}
/* SCRIPT Install Instances
*/
TypingAid_SetKomodoWordlists(){
	$Instancer.InstanceProcess.killAllInstances()
	sleep, 500
	Run, %A_LineFile%\..\..\..\TypingAidKomodoWordlists\TypingAidKomodo.ahk
	sleep, 1000
	MsgBox,262144,TypingAidKomodo, Komodo wordlists generated., 3
	$Instancer.configureAll()

}
