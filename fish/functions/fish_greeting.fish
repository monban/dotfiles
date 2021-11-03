function fish_greeting
    if type -q lolcat; and test -e $HOME/itf_large.txt
        lolcat $HOME/itf_large.txt
    end
end
