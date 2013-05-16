-- default desktop configuration for Fedora

import System.Posix.Env (getEnv)
import System.IO
import Data.Maybe (maybe)

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Kde
import XMonad.Config.Xfce
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (spawnPipe)
import XMonad.Actions.PhysicalScreens
import qualified XMonad.StackSet as W

main = do
     session <- getEnv "DESKTOP_SESSION"
     xmonad $ (maybe desktopConfig desktop session)
	 { modMask = mod4Mask
	 }
	 `additionalKeys`
	 [ ((mod4Mask, xK_Return), spawn "gnome-terminal")
	 , ((mod4Mask .|. mod1Mask, xK_l), spawn "gnome-screensaver-command -l")
	 , ((mod4Mask .|. controlMask, xK_h), sendMessage Shrink)
	 , ((mod4Mask .|. controlMask, xK_l), sendMessage Expand)
	 , ((mod4Mask .|. controlMask, xK_j), onNextNeighbour W.view)
	 , ((mod4Mask .|. controlMask, xK_k), onPrevNeighbour W.view)
	 ]

desktop "gnome" = gnomeConfig
desktop "kde" = kde4Config
desktop "xfce" = xfceConfig
desktop "xmonad-gnome" = gnomeConfig
desktop _ = desktopConfig
