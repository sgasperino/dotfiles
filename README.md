# dotfiles

## Instalation Instructions:

### Brew Packages:
1. ```/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"```
2. Brew install:
	* neofetch
	* node
		* ```npm install gtop -g```
	* fortune
	* cowsay
	* lolcat
	* pipes-sh
	* cask install amethyst
	* tty-clock
	* cmatrix (for configuration go here: https://codeburst.io/install-and-setup-cmatrix-on-mac-a2076daee420)

### Terminal Setup:
0. Change shell:  `chsh -s /bin/zsh`
1. Clone repo
2. Install fonts
3. Install zprezto by running ```git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"```
4. Replace .zshrc and .zpreztorc files
5. Replace ./zprezto/modules and ./zprezto/runcoms with ones from this repo
6. Run iTerm2 profile commands
	* ```defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/git/dotfiles/iterm2"```
	
	* ```defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true```

### Sublime Setup:
1. Install Sublime Text 3
2. `cmd+shift+P` "Package Control: Install Package"
	* Search for "Material Theme" and install it
	* (For more info on the theme https://packagecontrol.io/packages/Material%20Theme)
3. Copy /sublime/user_preferences into preferences
4. Toggle off Minimap
5. Toggle off Tabs
6. Create ability to launch sublime from cmd line ```ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime```