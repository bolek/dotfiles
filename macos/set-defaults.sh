#!/usr/bin/env bash
#
# macOS defaults. Run once on a new machine (script/bootstrap does this) or by
# hand with `set-defaults`. Not run by `dot`: it resets the Dock.
#
# Originally from https://github.com/mathiasbynens/dotfiles/blob/master/.macos,
# trimmed to settings that still work on current macOS (Apple Silicon).

# Close System Settings so it doesn't overwrite what we change
osascript -e 'tell application "System Settings" to quit' 2>/dev/null

# Ask for the administrator password upfront, keep sudo alive until done
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Security                                                                    #
###############################################################################

# Touch ID for sudo. sudo_local survives macOS updates, unlike editing pam.d/sudo
if [ ! -f /etc/pam.d/sudo_local ] && [ -f /etc/pam.d/sudo_local.template ]; then
  sed 's/^#auth\(.*pam_tid\.so\)/auth\1/' /etc/pam.d/sudo_local.template |
    sudo tee /etc/pam.d/sudo_local >/dev/null
fi

# Require password immediately after sleep or screen saver
# (the old com.apple.screensaver askForPassword keys no longer work)
sysadminctl -screenLock immediate -password - 2>/dev/null ||
  echo "  ! could not set screen lock; set it in System Settings > Lock Screen"

# Firewall on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on >/dev/null

# FileVault can't be turned on silently; just warn
fdesetup isactive >/dev/null || echo "  ! FileVault is OFF: turn it on in System Settings > Privacy & Security"

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Sidebar icon size: medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Disable the over-the-top focus ring animation
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Quit the printer app once print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Don't reopen System Settings windows
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Don't let macOS auto-terminate inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable smart capitalization, dashes, periods, quotes, autocorrect, and
# inline predictive text (they mangle code and shell commands)
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticInlinePredictionEnabled -bool false

###############################################################################
# Windows                                                                     #
###############################################################################

# Ctrl+Cmd-drag moves a window from anywhere inside it
defaults write NSGlobalDomain NSWindowShouldDragOnGesture -bool true

# Clicking the wallpaper doesn't hide every window to reveal the desktop
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# No gaps around tiled windows
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

###############################################################################
# Trackpad, keyboard, input                                                   #
###############################################################################

# Tap to click, for this user and the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Full keyboard access for all controls (Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Key repeat instead of the accent popup, and a very fast repeat rate
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Language, locale and units
defaults write NSGlobalDomain AppleLanguages -array "en" "pl"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool false

# Input menu on the login screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

###############################################################################
# Screenshots                                                                 #
###############################################################################

defaults write com.apple.screencapture location -string "${HOME}/Desktop"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Allow quitting Finder with Cmd-Q; no window animations
defaults write com.apple.finder QuitMenuItem -bool true
defaults write com.apple.finder DisableAllAnimations -bool true

# New windows open in the home folder
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show all extensions, status bar, path bar, full POSIX path in the title
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Folders first; search the current folder; no warning on extension change
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Instant spring-loaded folders
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# No .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Icon view: labels to the side, snap to grid, spacing, size
# (keys don't exist on a fresh account until Finder has written its prefs)
fplist=~/Library/Preferences/com.apple.finder.plist
for v in DesktopViewSettings StandardViewSettings; do
  /usr/libexec/PlistBuddy -c "Set :$v:IconViewSettings:arrangeBy grid" "$fplist" 2>/dev/null
  /usr/libexec/PlistBuddy -c "Set :$v:IconViewSettings:gridSpacing 100" "$fplist" 2>/dev/null
  /usr/libexec/PlistBuddy -c "Set :$v:IconViewSettings:iconSize 80" "$fplist" 2>/dev/null
done
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:labelOnBottom false" "$fplist" 2>/dev/null

# List view by default; no warning before emptying Trash
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show ~/Library and /Volumes
chflags nohidden ~/Library
sudo chflags nohidden /Volumes

# Expand General, Open with and Sharing & Permissions in Get Info
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

###############################################################################
# Dock & Mission Control                                                      #
###############################################################################

defaults write com.apple.dock mouse-over-hilite-stack -bool true
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
defaults write com.apple.dock show-process-indicators -bool true

# Dock shows only running apps: clear pinned apps, no recents
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock static-only -bool true
defaults write com.apple.dock show-recents -bool false

# No launch animation; fast Mission Control
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don't rearrange Spaces by most recent use
defaults write com.apple.dock mru-spaces -bool false

# Auto-hide the Dock with no delay; translucent icons for hidden apps
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock showhidden -bool true

###############################################################################
# Apps                                                                        #
###############################################################################

# Activity Monitor: open main window, CPU in Dock icon, all processes by CPU
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor IconType -int 5
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# TextEdit: plain text, UTF-8
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Disk Utility: advanced image options
defaults write com.apple.DiskUtility advanced-image-options -bool true

# QuickTime: autoplay on open
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

# Photos: don't open when a device is plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Chrome: no trackpad/mouse backswipe; system print dialog, expanded
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# Updates                                                                     #
###############################################################################

# These live in /Library/Preferences; the per-user keys are ignored
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true

###############################################################################
# Apply                                                                       #
###############################################################################

for app in Dock Finder SystemUIServer; do
  killall "$app" >/dev/null 2>&1
done

echo "Done. Some changes need a logout/restart to take effect."
