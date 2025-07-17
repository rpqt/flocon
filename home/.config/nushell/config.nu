alias ls = eza
alias ll = eza -l
alias lla = eza -la
alias h = hx
alias g = git

# Load starship prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
