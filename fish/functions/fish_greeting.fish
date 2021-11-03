function fish_greeting
    if type -q lolcat; and test -e $HOME/itf_large.txt
        echo '
          _________________________________________
         /                                        /
        /____     _________     ______     ______/
            /    /        /    /     /    /
           /    /        /    /     /    /___
          /    /        /    /     /        /
      ___/    /___     /    /     /    ____/
     /           /    /    /     /    /
    /___________/    /____/     /____/
        '| lolcat -F 0.25
    end
end
