module Main (main) where

import qualified Data.Map as M

import XMonad hiding ( (|||) )
import qualified XMonad.StackSet as W

import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog hiding (xmobar)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ServerMode
import XMonad.Layout.Accordion
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowArranger
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Prompt.Theme
import XMonad.Prompt.Window
import XMonad.Prompt.XMonad
import XMonad.Util.Run
import XMonad.Util.Themes

main = do
--  xmobar <- spawnPipe "xmobar ~/.xmonad/xmobar"
  xmobar <- spawnPipe "xmobar"
  xmonad defaultConfig
         { workspaces         = ["1.con", "2.dev", "3.web", "4.doc", "5.mail"] ++
                                map show [6 .. 9 :: Int]
         , logHook            = myDynLog xmobar -- REMOVE this line if you do not have xmobar installed!
	     , modMask 			  = mod4Mask
         , manageHook         = myManageHooks
         , layoutHook         = avoidStruts $
                                --decorated        |||
                                -- mytabs        |||
                                noBorders mytabs |||
                                otherLays
         , terminal           = "gnome-terminal"
         , normalBorderColor  = "white"
         , focusedBorderColor = "red"
         , keys               = newKeys
         , handleEventHook    = serverModeEventHook
         , focusFollowsMouse  = True
         }
    where
      -- layouts
      mytabs    =       tabbed shrinkText (theme smallClean)
      -- decorated = simpleFloat' shrinkText (theme smallClean)
      tiled     = Tall 1 (3/100) (1/2)
      otherLays = windowArrange   $
          --        magnifier tiled |||
          --        noBorders Full  -- |||
                  Mirror tiled  --  |||
                  ||| tiled
          --        Accordion

      myManageHooks = composeAll
                      [ className =? "Do"      --> doFloat
                      , className =? "Gimp"      --> doFloat
                      , className =? "Xmessage"  --> doFloat
                      , className =? "Iceweasel"  --> doFloat
                        --    , className =? "Vncviewer" --> doShift "6:vnc"
                        --    , className =? "rdesktop"  --> doShift "5:rds"
                      , className =? "Rhythmbox" --> doShift "8:rth"
                      ]

      -- xmobar
      myDynLog    h = dynamicLogWithPP defaultPP
                      { ppCurrent = xmobarColor "yellow" "" . wrap "[" "]"
                      , ppTitle   = xmobarColor "green"  "" . shorten 40
                      , ppVisible = xmobarColor "green" "" . wrap "(" ")"
                      , ppOutput  = hPutStrLn h
                      }

      -- key bindings stuff
      defKeys    = keys defaultConfig
      delKeys x  = foldr M.delete           (defKeys x) (toRemove x)
      newKeys x  = foldr (uncurry M.insert) (delKeys x) (toAdd    x)
      -- remove some of the default key bindings
      toRemove x =
          [ (modMask x              , xK_j)
          , (modMask x              , xK_k)
          --, (modMask x              , xK_p)
          --, (modMask x .|. shiftMask, xK_p)
          , (modMask x .|. shiftMask, xK_q)
          , (modMask x              , xK_q)
          ]
      -- I want modMask .|. shiftMask 1-9 to be free!
--          [(shiftMask .|. modMask x, k) | k <- [xK_1 .. xK_9]]
      -- These are my personal key bindings
      toAdd x   =
          [ ((modMask x              , xK_F12   ), xmonadPrompt      defaultXPConfig     )
          , ((modMask x              , xK_F3    ), shellPrompt       defaultXPConfig     )
          , ((modMask x              , xK_F4    ), sshPrompt         defaultXPConfig     )
          , ((modMask x              , xK_F5    ), themePrompt       defaultXPConfig     )
          , ((modMask x              , xK_F6    ), windowPromptGoto  defaultXPConfig     )
          , ((modMask x              , xK_F7    ), windowPromptBring defaultXPConfig     )
          , ((modMask x              , xK_comma ), prevWS                                )
          , ((modMask x              , xK_period), nextWS                                )
          --, ((modMask x              , xK_Right ), windows W.focusDown                   )
          --, ((modMask x              , xK_Left  ), windows W.focusUp                     )
          -- other stuff: launch some useful utilities
          -- , ((modMask x              , xK_F2    ), spawn "gedit ~/scratchpad.txt" )
          -- , ((modMask x .|. shiftMask, xK_F4    ), spawn "~/bin/dict.sh"                 )
          , ((modMask x .|. shiftMask, xK_F5    ), spawn "gnome-screenshot -a -e shadow")
            -- softfone shortcuts
          , ((modMask x, xK_KP_Multiply), spawn "twinkle --cmd answer")
          , ((modMask x, xK_KP_Subtract),    spawn "twinkle --cmd bye")
          , ((modMask x, xK_KP_Divide),   spawn "twinkle --cmd 'call 8012'")
            -- , ((modMask x .|. shiftMask, xK_t     ), spawn "~/bin/teaTime.sh"              )
          , ((modMask x              , xK_c     ), kill                                  )
          , ((modMask x .|. shiftMask, xK_comma ), sendMessage (IncMasterN   1 )         )
          , ((modMask x .|. shiftMask, xK_period), sendMessage (IncMasterN (-1))         )
          -- commands fo the Magnifier layout
          , ((modMask x .|. controlMask              , xK_plus ), sendMessage MagnifyMore)
          , ((modMask x .|. controlMask              , xK_minus), sendMessage MagnifyLess)
          , ((modMask x .|. controlMask              , xK_o    ), sendMessage ToggleOff  )
          , ((modMask x .|. controlMask .|. shiftMask, xK_o    ), sendMessage ToggleOn   )
          -- windowArranger
          , ((modMask x .|. controlMask              , xK_a    ), sendMessage  Arrange           )
          , ((modMask x .|. controlMask .|. shiftMask, xK_a    ), sendMessage  DeArrange         )
          , ((modMask x .|. controlMask              , xK_Left ), sendMessage (DecreaseLeft   10))
          , ((modMask x .|. controlMask              , xK_Up   ), sendMessage (DecreaseUp     10))
          , ((modMask x .|. controlMask              , xK_Right), sendMessage (IncreaseRight  10))
          , ((modMask x .|. controlMask              , xK_Down ), sendMessage (IncreaseDown   10))
--          , ((modMask x .|. shiftMask                , xK_Left ), sendMessage (MoveLeft       10))
--          , ((modMask x .|. shiftMask                , xK_Right), sendMessage (MoveRight      10))
--          , ((modMask x .|. shiftMask                , xK_Down ), sendMessage (MoveDown       10))
--          , ((modMask x .|. shiftMask                , xK_Up   ), sendMessage (MoveUp         10))
          -- gaps
          , ((modMask x                              , xK_b    ), sendMessage  ToggleStruts      )
          , ((modMask x                              , xK_KP_Enter), windows W.swapMaster)
          ] ++
          -- Use modMask .|. shiftMask .|. controlMask 1-9 instead
          -- [( (m .|. modMask x, k), windows $ f i)
          --  | (i, k) <- zip (workspaces x) [xK_1 .. xK_9]
          -- ,  (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask .|. controlMask)]
          -- ]  ++
          [((m .|. mod4Mask .|. shiftMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
          | (key, sc) <- zip [xK_Left, xK_Right] [1,0] -- was [0..]
          , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]] ++
          
		  [((m .|. mod4Mask, key), screenWorkspace sc >>= flip whenJust (windows . f))
          | (key, sc) <- zip [xK_q, xK_w] [1,0] -- was [0..]
          , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
