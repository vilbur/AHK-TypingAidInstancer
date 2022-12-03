
/** Manage Instances of TypingAid
	Start, Kill etc...

*/
Class InstanceProcess {

	process_name	:= ""	; name of process for which is typingAid instance searched
	config_instances	:= {}	; processes of instances in config
	config_processes_all	:= ""	; string of all processe defined in config
	instances_running	:= {} 	; all running instances of typiAid
	instances_to_start	:= []	; instances available for this.process_name

	__New($ini){
		this.ini := $ini
		this._setProcessesInConfig()
	}
	/** findInstanceForLaunch
	*/
	findInstanceToStart($process_name){
		this.process_name := $process_name
		if(!this._isProcessInConfig())
			return

		this._setRunningInstances()
		this._setInstancesToStart()
		;this._debugMessage(this.instances_running, "instances_running")
		;this._debugMessage(this.instances_to_start, "instances_to_start")

		;dump(this.process_name, "this.process_name", 0)
		;dump(this.config_processes_all, "this.config_processes_all", 1)
		;dump(this.config_instances, "this.config_instances", 1)
		;dump(this.instances_running, "this.instances_running", 1)
		;dump(this.instances_to_start, "this.instances_to_start", 1)
		return % this.instances_to_start
	}
	/** killAllInstances
	*/
	killAllInstances(){
		For $insance, $pid in this.getRunningInstances()
		    Process,Close,%$pid%
		this._trayRefresh()
	}
	/** killUnusedInstances
	*/
	killUnusedInstances(){
		setTitleMatchMode, RegEx
		For $instance, $pid in this.getRunningInstances(){                                               ; FOR EACH EXISTING INSTANCE OF TypingAid
			For $i, $process in StrSplit(this.ini.get($instance, "process"), "|"){                        ; FOR EACH PROCESS OF THIS INSTANCE
				IfWinNotExist, % "(" this.config_instances[$process][$instance] ")" " ahk_exe " $process  ; IF WINDOW IF THAT PROCESS AND TITLE DOES NOTE EXITS
					Process,Close,%$pid%
			}
		}
	}
	/** Processes from each section of config as key and their instance names with titles

		E.G: { "komodo.exe": {komodo-ahk:".ahk", komodo-js:".js" }
	*/
	_setProcessesInConfig(){
		For $section, $data in this.ini.get()
			if($data["process"]!="")
				For $i, $process in StrSplit($data["process"], "|"){
					this._addToInstancesConfig($section, $process)
					this._addToAllProcessesInConfig($process)
				}
		return this
	}
	/** Set instances which are currently launched
	*/
	_setRunningInstances(){
		this.instances_running	:= this.getRunningInstances()
		return this
	}
	/** Get instances of Typing Aid which already launched
		@return {"instance-name":PID}
	*/
	getRunningInstances(){
		DetectHiddenWindows, On  ; Detect hidden windows
		SetTitleMatchMode, RegEx ; Find window titles by regex
		$instances_running	:= {}
		For $section, $data in this.ini.get() {
			WinGet, $PID, PID, % "i)^.+\\" $section "-TypingAid\.ahk - AutoHotkey v.+$"
			;Process, Exist, $PID ;;; check if pid REALLY EXISTS, if some instance of  typing aid is killed, it may remain be still noticeable with WinGet
			if($PID )
				$instances_running[$section] := $PID
		}
		return %$instances_running%
	}
	/** _setInstancesToStart
	*/
	_setInstancesToStart(){
		this.instances_to_start	:= []
		For $process, $titles in this.config_instances[this.process_name]
			if(!this.instances_running.HasKey($process ))
				this.instances_to_start.push($process)
				;MsgBox,,, % "Add not running instance:`n" $process,2
	}
	/** _addToInstancesConfig
	*/
	_addToInstancesConfig($section, $process){
		if(!this.config_instances[$process])
			this.config_instances[$process] := {}
			;this.config_instances[$process] := [$section]
		;else
			;this.config_instances[$process].insert($section)
		this.config_instances[$process][$section] := this.ini.get($section, "title")
	}
	/** _addToAllProcessesInConfig
	*/
	_addToAllProcessesInConfig($process){
		$config_processes_all := this.config_processes_all
		IfNotInString, $config_processes_all, %$process%
			this.config_processes_all .= " " $process
	}
	/** _isProcessInConfig
	*/
	_isProcessInConfig(){
		$config_processes_all := this.config_processes_all
			IfInString, $config_processes_all, % this.process_name
				return true
		return
	}
	/** _debugMessage
	*/
	_debugMessage($object, $title:=""){
		For $key, $value in $object
			$string .= "`n "$key " " $value
		MsgBox,, %$title%, %$string%,5
	}

}
