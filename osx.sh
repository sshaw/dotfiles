# Don't use natural scrolling, false means use good ol' scrolling
defaults write "Apple Global Domain" com.apple.swipescrolldirection -bool false

# No .DS_Store files on network volumes
# defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

defaults write com.apple.dock autohide -bool true

defaults write com.apple.finder EmptyTrashSecurely -bool true
# Default Finder view mode, use list view
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Google update
defaults write com.google.Keystone.Agent checkInterval -int 0




