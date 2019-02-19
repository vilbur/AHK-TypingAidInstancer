
;;; Redefine Array().
Array(prm*) {

	;__New(){
	;	MsgBox,262144,, Test,2
	;
	;}
    ; Since prm is already an array of the parameters, just give it a
    ; new base object and return it. Using this method, _Array.__New()
    ; is not called and any instance variables are not initialized.
    ;prm.base := _Array
    prm.base   := _Array
    return prm
}

 ;;Define the base class.
class _Array {

    test() {
		;return % "test _Array"
		Dump(this, "TEST", 1)
        ;return Round(this.MaxIndex()) ; Round() turns "" into 0.
    }
	/** remove by index
	  @param int|[int] indexes to remove
	*/
	remove($index_remove){
		;dump( $array, "Array_Delete", 1)
		if(!isObject($index_remove))
			this.delete($index_remove)
		else
			For $i, $index in $index_remove
				this.delete($index)

		return % this._reindex()
	}
	/** @return length of this.array
	  */
	length(){
		return % this._length(this)
	}
	/* merege
	*/
	merge($arr_merge:=""){
		;MsgBox,262144,, merge B,2
		;Dump(this, "this.", 1)
		For $index, $value in $arr_merge
		;	this.push($value)
			this.insert($value)

		return this
	}
	/** filter
	*/
	filter($filter:="^$"){

		For $index, $value in this
			;Dump($value,  $index ":value", 1)
		    if (RegExMatch( $value, "i)" $filter ))
				this.delete($index)

		return % this._reindex()
	}
	/** indexOf
	*/
	indexOf($needle){
		return this._findInArray(this, $needle)
	}
	/*
	*/
	reverse(){
		$array_reversed := Arr()
		Loop, % $len:=this._length(this)
			$array_reversed[$len-(A_Index-1)] := this[A_Index]
		this := $array_reversed
		return this
	}
	/** unique
	*/
	unique(){
		$array_unique := Arr()

			;if(this._findInArray($array_unique, $value)==0)
		For $index, $value in this
			if($array_unique.indexOf($value)==0)
				$array_unique.push($value)
		return %$array_unique%
	}

	/** join
	*/
	join($delimeter:="|", $object:="") {
		;if(!$object)
		$object := $object?$object:this
			For $index, $item in $object
				$string .= (isObject($item)?this.join($delimeter, $item):$item) (A_Index<$object.length()?$delimeter:"")
		return %$string%
	}


	;/** _arrayJoin
	;*/
	;_arrayJoin($array,$delimeter){
	;	$length := this._length($array)
	;		For $index, $item in $array
	;			$string .= (isObject($item)?this._arrayJoin($item, $delimeter):$item) (	A_Index<$length?$delimeter:"")
	;			;$string .= (isObject($item)?this._arrayJoin($item, $delimeter):$item) ($index<$length?"|":"")
	;	return %$string%
	;}
	/** get
	*/
	getArray(){
		MsgBox,262144,, Arr.getArray()`nThis Method can be removed,2
		return % this
	}
	/* sort Array
	  https://sites.google.com/site/ahkref/custom-functions/sortarray
	*/
	sort($order="A") {
		$Array := this
		;$order A: Ascending, D: Descending, R: Reverse
		$MaxIndex := ObjMaxIndex($Array)
		If ($order = "R") {
			count := 0
			Loop, % $MaxIndex
				ObjInsert($Array, ObjRemove($Array, $MaxIndex - count++))
			Return
		}
		$Partitions := "|" ObjMinIndex($Array) "," $MaxIndex
		Loop {
			$comma	:= InStr($this_partition := SubStr($Partitions, InStr($Partitions, "|", False, 0)+1), ",")
			$spos	:= $pivot := SubStr($this_partition, 1, $comma-1) , $epos := SubStr($this_partition, $comma+1)
			if ($order = "A") {
				Loop, % $epos - $spos {
					if ($Array[$pivot] > $Array[A_Index+$spos])
						ObjInsert($Array, $pivot++, ObjRemove($Array, A_Index+$spos))
				}
			} else {
				Loop, % $epos - $spos {
					if ($Array[$pivot] < $Array[A_Index+$spos])
						ObjInsert($Array, $pivot++, ObjRemove($Array, A_Index+$spos))
				}
			}
			$Partitions := SubStr($Partitions, 1, InStr($Partitions, "|", False, 0)-1)
			if ($pivot - $spos) > 1    ;if more than one elements
				$Partitions .= "|" $spos "," $pivot-1        ;the left partition
			if ($epos - $pivot) > 1    ;if more than one elements
				$Partitions .= "|" $pivot+1 "," $epos        ;the right partition
		} Until !$Partitions
		;return %Array%
		return this
	}
	/** get array of all keys in object
	*/
	keys(){
		$keys	:= []
		For $key, $value in this
			$keys.push( $key )
		return %$keys%
	}
	/** find
	*/
	find($needle){
		for $index, $value in this
			;if ($value == $needle)
			if(RegExMatch( $value, "i)"  $needle ))
				return $index
		return 0
	}
	/** _findInArray
	*/
	_findInArray($array, $needle){
		;if !(IsObject($array)) || ($array.Length() = 0)
			;return 0
		for $index, $value in $array
			;if ($value == $needle)
			if(RegExMatch( $value, "i)"  $needle ))
				return $index
		return 0
	}
	/** @return length of array
	  */
	_length($arr_obj){
		return % $arr_obj.MaxIndex() ? $arr_obj.MaxIndex() : $arr_obj.GetCapacity()
		;return % this.array.MaxIndex()
	}
	/** _reindex
	*/
	_reindex(){
		$array_unique := Arr()
		For $index, $value in this
			;if(this._findInArray($array_unique, $value)==0)
				$array_unique.insert($value)
		;this := $array_unique
		;return this
		;Dump($array_unique, "array_unique", 1)
		return %$array_unique%

	}
}


;/**
;	Wrapper for Array
;*/
;Class Arr extends _Array {
;
;
;	__New($array){
;		return %$array%
;	}
;
;}
/**
	CALL CLASS FUNCTION
*/
Arr($array:=""){
	;return % new Arr($array?$array:[])
	if(!$array)
		$array:=[]
    $array.base   := new _Array()
    return %$array%

}
