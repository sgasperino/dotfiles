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

### Terminal Setup:
1. Clone repo
2. Install fonts
3. Install zprezto by running ```git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"```
4. Replace .zshrc and .zpreztorc files
5. Replace ./zprezto/modules and ./zprezto/runcoms with ones from this repo
6. Change iTerm to "Dark Background" presets
	* Change "Blue" to RGB 88/134/186
	* Change Normal font to "Monaco" 11
	* Change Antialiased font to "Menlo for Powerline" 11

### Sublime Setup:
1. Install Sublime Text 3
2. `cmd+shift+P` "Package Control: Install Package"
	* Search for "Material Theme" and install it
	* (For more info on the theme https://packagecontrol.io/packages/Material%20Theme)
3. Copy /sublime/user_prefernces into preferences
4. Toggle off Minimap
5. Toggle off Tabs
6. Create ability to launch sublime from cmd line ```ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime```