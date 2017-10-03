# dotfiles

##Instalation Instructions:
###Terminal Setup
1. Clone repo
2. Install fonts
3. Install zprezto by running git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
4. Replace .zshrc and .zpreztorc files
5. Replace ./zprezto/modules and ./zprezto/runcoms with ones from this repo
6. Change iTerm to "Dark Background" presets
	6a. Change "Blue" to RGB 88/134/186
	6b. Change Normal font to "Monaco" 11
	6c. Change Antialiased font to "Menlo for Powerline" 11

###Sublime Setup
1. Install Sublime Text 3
2. cmd+shift+P "Package Control: Install Package"
	2a. Search for "Material Theme" and install it
	2b. (For more info on the theme https://packagecontrol.io/packages/Material%20Theme)
3. Copy /sublime/user_prefernces into preferences
4. Toggle off Minimap
5. Toggle off Tabs