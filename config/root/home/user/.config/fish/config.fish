if status is-interactive
	setenv LANGUAGE en_US.UTF-8
	setenv LANG en_US.UTF-8
	setenv LC_ALL en_US.UTF-8
	setenv DISPLAY :0.0
	set fish_greeting
	~/.autorun-any-shell-rc
	set -x DEBUGINFOD_URLS "https://debuginfod.archlinux.org"
    # Commands to run in interactive sessions can go here
end
eval "$(pyenv init -)"
