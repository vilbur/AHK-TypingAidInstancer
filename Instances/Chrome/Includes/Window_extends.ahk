/* REPLACEMENT OF DEFALUT FUNCTION IN FILE: TypingAid\Source\Includes\Window.ahk

	CHANGES:
		1)SUPPORT OF REGEX MATCH
		2)IMPROVED CONDITIONS, IF INCLUDE OF PROCESS AND TITLE DEFINED, BOTH MUST MATCH

	HOW TO ADD TO TYPING AID
		1) COMMENT (DISABLE) ORIGINAL CheckForActive() FUNCTION
		2) INCLUDE THIS FILE TO Window.ahk	E.G: #Include %A_LineFile%\..\..\..\..\Lib\Install\TypingAid\Extends\Includes\Window_extends.ahk

*/

CheckForActive(ActiveProcess,ActiveTitle)
{
	
  ;Check to see if the Window passes include/exclude tests
   global g_InSettings
   global prefs_ExcludeProgramExecutables
   global prefs_ExcludeProgramTitles
   global prefs_IncludeProgramExecutables
   global prefs_IncludeProgramTitles

   quotechar := """"

   If g_InSettings
      Return,

	;;;; if all settings are empty
	if(prefs_IncludeProgramExecutables==""&&prefs_ExcludeProgramExecutables==""&&prefs_IncludeProgramTitles==""&&prefs_ExcludeProgramTitles=="")
		return 1

	;;;; if EXCLUDED
	if((prefs_ExcludeProgramExecutables	!=""	&& RegExMatch( ActiveProcess,	"i)(" prefs_ExcludeProgramExecutables ")" ))
	|| (prefs_ExcludeProgramTitles	!=""	&& RegExMatch( ActiveTitle,	"i)(" prefs_ExcludeProgramTitles ")" )))
	    return

	;;;; if INCLUDED
	$title_included	:= RegExMatch( ActiveTitle,	"i)(" prefs_IncludeProgramTitles ")" )
	$process_included	:= RegExMatch( ActiveProcess,	"i)(" prefs_IncludeProgramExecutables ")" )

	if ((prefs_IncludeProgramTitles	=="" && $process_included)
	|| ( prefs_IncludeProgramExecutables	=="" && $title_included)
	|| ( $process_included && $title_included))
		    return 1
   Return,
}