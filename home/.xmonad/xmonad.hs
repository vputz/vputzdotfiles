import XMonad 

import XMonad.Layout.Spiral
import Data.Ratio
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import qualified Data.Map as M
import System.IO
import qualified XMonad.StackSet as W

myLayout = avoidStruts $ spiral (1 % 1) ||| tiled
     -- default tiling algorithm partitions the screen into two panes
 where
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 2/3

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

--myLogHook = dynamicLogDzen
myTerminal = "urxvt"
myModMask = mod4Mask
myDefaultGaps = [(16,0,0,0)]

--newKeys x = M.union (keys defaultConfig x) (M.fromList (myKeys x))
--myKeys x = [ (modMask x .|. controlMask .|. shiftMask, xK_z) ]

myWorkspaces :: [WorkspaceId]
myWorkspaces = map show $ [1..9] ++ [0]

myManageHook :: ManageHook
myManageHook = manageDocks <+> manageWindows

manageWindows :: ManageHook
manageWindows = composeAll . concat $ 
                [ [ className =? c --> doShift (myWorkspaces !! 0 ) | c <- myShellS ]
                  , [ className =? c --> doShift (myWorkspaces !! 1 ) | c <- myChromeS ]
		  , [ className =? c --> unfloat | c <- myChromeS ]
                  , [ className =? c --> doShift (myWorkspaces !! 2 ) | c <- myEmacsS ]
                  , [ className =? c --> doShift (myWorkspaces !! 3 ) | c <- myFirefoxS ]
		  , [ className =? c --> doShift (myWorkspaces !! 4 ) | c <- myGephiS ]
                ] where
                  myShellS = ["urxvt", "URxvt"]
                  myChromeS = ["Chromium", "Chrome", "chromium-browser", "Chromium-browser"]
                  myEmacsS = ["emacs", "Emacs"]
                  myFirefoxS = ["Firefox"]
		  myGephiS = ["Gephi"]
		  unfloat = ask >>= doF . W.sink


main = do 
	xmproc <- spawnPipe "/usr/bin/xmobar /home/vputz/.xmobarrc"
	xmonad $ defaultConfig
        	{ borderWidth        = 2
        	, normalBorderColor  = "#cccccc"
        	, focusedBorderColor = "#cd8b00" 
        	, layoutHook = myLayout
		, logHook = dynamicLogWithPP xmobarPP
			{ ppOutput = hPutStrLn xmproc
			, ppTitle = xmobarColor "green" "" . shorten 50
			}
		, modMask = myModMask
		, startupHook = ewmhDesktopsStartup >> setWMName "LG3D"
		, terminal = myTerminal
		, manageHook = myManageHook
--	, defaultGaps = myDefaultGaps
--	, logHook = myLogHook
		}
	--, keys=newKeys }
