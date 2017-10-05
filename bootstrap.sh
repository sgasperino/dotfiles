#!/bin/bash
#
# This is a bootstrap script to set up my home environment
# Written by Sean Gasperino (10.05.17)
#


# Set up Shell
echo "Changing Shell to ZSH"

chsh -s /bin/zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# Configure Shell
echo "Configuring Prezto Settings and Themes"
	mkdir ~/git
	cd git
	git clone https://github.com/sgasperino/dotfiles.git
	cp ~/git/dotfiles/iterm2/fonts/* /Library/Fonts
	cp zshrc ~/.zshrc
	cp zpreztorc ~/.zpreztorc
	cp modules ~/.zprezto/
	cp runcoms ~/.zprezto/
	cp screenrc ~/.screenrc
	rm ~/.zlogin
	rm ~/.zlogout

# Configure iTerm2 
echo "Copying iTerm2 Settings and pointing at dotfiles repo"
# Specify the preferences directory
	defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/git/dotfiles/iterm2"
# Tell iTerm2 to use the custom preferences in the directory
	defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

#Brew Installation
	echo "Installing Brew and Brew applications"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install neofetch
	brew install node
	brew install tty-clock
	brew install fortune
	brew install cowsay
	brew install lolcat
	brew install pipes-sh
	brew cask install amaethyst
	brew install cmatrix

echo "All Done!"
