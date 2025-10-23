;From:https://www.autohotkey.com/boards/viewtopic.php?style=1&t=135271
;双击资源管理器空白处返回上一级目录
#Requires AutoHotkey v2

#HotIf IsExplorerUnderCursor()
LButton:: ('LButton' == A_PriorHotkey && A_TimeSincePriorHotkey < 300 && IsEmptySpaceUnderCursor())
          ? Send('!{Up}') : (Click('D'), KeyWait('LButton'), Click('U'))
#HotIf

IsExplorerUnderCursor() {
    MouseGetPos(,, &hWnd)
    return WinGetClass(hWnd) == 'CabinetWClass'
}

IsEmptySpaceUnderCursor() {
    static ROLE_SYSTEM_WINDOW := 0x00000009
    AccObj := AccObjectFromPoint(&childId)
    return (childId ? AccObj : AccObj.accParent).accRole[0] = ROLE_SYSTEM_WINDOW
}

AccObjectFromPoint(&childId := '', x := '', y := '') {
    static VT_DISPATCH := 9, F_OWNVALUE := 1, varChild := Buffer(8 + A_PtrSize * 2, 0)
         , h := DllCall('LoadLibrary', 'Str', 'Oleacc', 'Ptr')
    (x = '' || y = '') ? DllCall('GetCursorPos', 'Int64*', &pt := 0) : pt := x & 0xFFFFFFFF | y << 32
    DllCall('Oleacc\AccessibleObjectFromPoint', 'Int64', pt, 'Ptr*', &pAcc := 0, 'Ptr', varChild)
    AccObject := ComValue(VT_DISPATCH, pAcc, F_OWNVALUE)
    childId := NumGet(varChild, 8, 'UInt')
    return AccObject
}
