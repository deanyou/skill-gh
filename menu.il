;; copyleft ebecheto

;; https://community.cadence.com/cadence_technology_forums/f/48/t/26934
;; TODO : verify the post to prevent designkit to remove my menu

;___vv___ the only thing TODO for new user : ___vv___
;;; in ~/.bashrc : 
; export SKILLDIR=$HOME/Skill
; export SKILLDIR=/pbs/home/e/ebecheto/Skill
;;; AND
;;; in ~/.cdsinit_personnal :

; setShellEnvVar("SKILLDIR" "~/../ebecheto/Skill") #<= if not defined in ~/.bashrc
; setShellEnvVar("SKILLDIR" "/pbs/home/e/ebecheto/Skill") #<= another possible default path
; setSkillPath(cons(getShellEnvVar("SKILLDIR") getSkillPath()))#<= not so useless 
; ;setShellEnvVar("SKILLDIR" strcat(getShellEnvVar("HOME") "/Skill"));<= or that instead of .bashrc
; loadi("menu.il")
;___^^___ the only thing TODO for new user : ___^^___

let((dirs skdir) skdir=getShellEnvVar("SKILLDIR")
unless(skdir skdir="/pbs/home/e/ebecheto/Skill" setShellEnvVar("SKILLDIR" skdir) ) ;<== hardcode default location if any
;dirs=list(skdir strcat(skdir "/ab")  )
dirs=list(skdir strcat(skdir "/ab") strcat(skdir "/PICMIC") ) ;<= must be done better ;-()
dir=skdir
foreach(mapcar dir  dirs
when(system(strcat("ls " dir ">/dev/null" ))==0
when(not(rexMatchList(dir getSkillPath())) setSkillPath(cons(dir getSkillPath()))
printf("[SKILL] Adding %s in getSkillPath()\n" dir||"nilDir?")
))))

defun(menu () loadi("menu.il"))
;load("emacs_ipcPipe.il");<== in the menu or not ...
load("ineed.il")

; Load error handler for better debugging
load("errorHandler.il")

; Phase 1: Load critical infrastructure functions (always needed)
printf("[SKILL] Loading core infrastructure functions...\n")
ineed('(getInstTermPoint bBoxHeight bBoxWidth createPinLPP itos bus2list pointInbBox lay2schName))

; Phase 2: Load utility functions (commonly used)
printf("[SKILL] Loading utility functions...\n") 
ineed('(noiseSummary RmBannerItemByName bBox2array areaBox))

; Phase 3: Load new missing functions we just created
printf("[SKILL] Loading newly created functions...\n")
; bus2list, pointInbBox, lay2schName already loaded above

RmBannerItemByName('trEdPulldownMenu)

files='("genBox" "addCell" "schematic2symbol" "getInstTermPoint" "getPropList" "vdcGen" "abBinaryStrToInt" "terminalPinsMap" "terminal2pin" "ocnPrint2list" "createPinLPP" "schCreatePinEd" "generateAllPins" "genPinMaster" "generatePin2place" "updateCellviews" "whereExistCell3" "magAC" "sortOPpattern" "gplinFit" "shout")
;; TOTHINK LATER : i probably have to user destructuringBind rather than set(concat('caz file) ...)
;; TOTHINK LATER : although i might not need it at all. TODO LATER : redo the code of this menu.il file

cazfiles=foreach(mapcar file files ;file=car(files)
set(concat('caz file) hiCreateMenuItem(?name concat('caz file) ?itemText file ?callback sprintf(nil "load(\"%s.il\")" file )))
concat('caz file))

hiCreatePulldownMenu( 'trSubMenuDefun ""  cazfiles)
cazDeroule = hiCreateSliderMenuItem( ?name 'cazDeroule ?itemText "__ defun() __ -->" ?subMenu trSubMenuDefun)
; __ menu __ defun __--> too crowded => second one
files2='("rexFindCell" "whereIncludeCell" "categorySet" "terminalGen" "bBoxView" "sch2layName" "lpp2Set" "nbSimilarList" "prBoundaryAlign" "wirePinName" "showOnly" "createInstPinsch" "nmos_sim")
cazfiles2=foreach(mapcar file files2 set(concat('caz file) hiCreateMenuItem(?name concat('caz file) ?itemText file ?callback sprintf(nil "load(\"%s.il\")" file ))) concat('caz file))

hiCreatePulldownMenu( 'trSubMenuDefun2 ""  cazfiles2)
cazDeroule2 = hiCreateSliderMenuItem( ?name 'cazDeroule2 ?itemText "__ defun() bis-->" ?subMenu trSubMenuDefun2)


; buttons of the first Menu
filesOne='("Functions")
cazfilesOne=foreach(mapcar file filesOne
set(concat('caz file) hiCreateMenuItem(?name concat('caz file) ?itemText file ?callback sprintf(nil "load(\"%s.il\")" file )))
concat('caz file))


;;; creating a item for the pulldown menu
cazMyFunction = hiCreateMenuItem(?name 'cazMyFunction ?itemText "Save noise"
   ?callback "filename = \"summaryNoise.txt\"
              noiseResult( filename ) 
              printf(\"Noise Summary saved in [_** %s/%s **_]\n\", pwd() filename)
	      edit(sprintf(nil \"%s\" filename))"
   ); end of created Menu item


;g_menuIcon= list(strcat( env("SKILLDIR") "/mi2i_icon_pixmap.bmp") 16 16)
g_menuIcon= list(strcat( env("SKILLDIR") "/Signe-MI2I.bmp") 16 16)
;g_menuIcon2= list("/home/ebecheto/Skill/mi2i_logo_text.png" 16 57)




cazPrintNoiseSummary = hiCreateMenuItem(?name 'cazPrintNoiseSummary ?itemText "print noise" ?callback "noiseResult()" ?itemIcon g_menuIcon)
cazPrettyPrint = hiCreateMenuItem(?name 'cazPrettyPrint ?itemText "pretty print" ?callback "ineed('prettyPrint)")
cazResize  = hiCreateMenuItem(?name 'cazResize ?itemText "Resize" ?callback "hiResizeWindow( window(1) list(0:0 500:500))")
cazReload  = hiCreateMenuItem(?name 'cazReload ?itemText "reload_menu" ?callback "load(\"menu.il\")" )
cazPin     = hiCreateMenuItem(?name 'cazPin ?itemText "pin2label" ?callback "load(\"pin2label_v2.il\") pin2label()")
cazText    = hiCreateMenuItem(?name 'cazText ?itemText "pgText" ?callback "load(\"pgText.il\") pgText()")
cazMarkers = hiCreateMenuItem(?name 'cazMarkers ?itemText "displayMarkers" ?callback "load(\"displayMarkers.il\"")
cazEmacs   = hiCreateMenuItem(?name 'cazEmacs ?itemText "emacs_ipcPipe" ?callback "load(\"emacs_ipcPipe.il\")" )
cazRegion  = hiCreateMenuItem(?name 'cazRegion ?itemText "regionSat" ?callback "load(\"regionSat.il\") regionSat()"  )
cazMos2Fet = hiCreateMenuItem(?name 'cazMos2Fet ?itemText "mos2fet" ?callback "load \"mos2fet.il\"" )
cazGnuplot = hiCreateMenuItem(?name 'cazGnuplot ?itemText "gnuplotVT" ?callback "load(\"gnuplotVT.il\") dataToGnuplot()" )
cazFixAMS = hiCreateMenuItem(?name 'cazFixAMS ?itemText "fixState" ?callback "load(\"fixState.il\") fixState()" )
cazTuto   = hiCreateMenuItem(?name 'cazTuto ?itemText "Tuto_menu" ?callback "load(\"menu.il.tutorial.il\")" )
cazFreeLCK   = hiCreateMenuItem(?name 'cazFreeLCK ?itemText "freeLCK" ?callback "load(\"freeLCK.il\")" )
cazpinAddText   = hiCreateMenuItem(?name 'cazpinAddText ?itemText "pinAddText" ?callback "load(\"pinAddText.il\")" )
cazR90   = hiCreateMenuItem(?name 'cazR90 ?itemText "R90_selected" ?callback "foreach(inst geGetSelectedSet() inst~>orient=\"R90\")" )
cazNet   = hiCreateMenuItem(?name 'cazNet ?itemText "edit_netlist" ?callback "edit(strcat(asiGetNetlistDir(asiGetCurrentSession( )) \"/input.scs\"))")

;cazaddCell     =hiCreateMenuItem(?name 'cazaddCell    ?itemText "addCell"  ?callback sprintf(nil "load(%L)" "addCell.il" ))


cazFct = hiCreateMenuItem(?name 'cazFct ?itemText "Functions"
?callback "
printf(\"dbCreateLine( geGetWindowCellView() list(\\\"text\\\" \\\"drawing1\\\") list(-0.5:-100 100:-100)) leSetLayerValid('(\\\"text\\\" \\\"drawing1\\\") t) leSetLayerSelectable( '(\\\"text\\\" \\\"drawing1\\\") nil)\")
printf(\"\\nsystem(\\\"xterm&\\\")\")
cmd=sprintf(nil \"echo cd %s\" hiGetCurrentWindow()->cellView->fileName) system( cmd)
"  )




IPNLmenuList = list( cazMyFunction cazPrintNoiseSummary cazDeroule cazDeroule2 cazResize cazReload cazPin cazText cazFct cazPrettyPrint cazEmacs cazMarkers cazRegion cazMos2Fet cazGnuplot cazFixAMS cazTuto cazpinAddText cazR90 cazNet cazFreeLCK )

;;; inserting the pulldown menu in the CIW

;hiCreatePulldownMenu(    'trEdPulldownMenu    g_menuIcon   IPNLmenuList   )
hiCreatePulldownMenu(    'trEdPulldownMenu    "*_MI2I_*"   IPNLmenuList    )
hiInsertBannerMenu( window(1) trEdPulldownMenu 666 );<== 666 so it would be the last one on the right presumably


;; ;; Adding cdsLog for fun
;; body=sprintf(nil "`date`;\t%s @ %s" getShellEnvVar("USER")||"" getShellEnvVar("HOSTNAME")||"")
;; subject=sprintf(nil "[cdsLog]:%s" pwd())
;; cmd=sprintf(nil "echo -e %L | mail -s %L %s%s" body subject "e.bechetoille" "@ipnl.in2p3.fr")(system cmd)
;; ;; why is it loaded at every adexl simulation ???
