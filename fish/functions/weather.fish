function weather --wraps='curl https://wttr.in/Fishers' --description 'alias weather curl https://wttr.in/Fishers'
  curl https://wttr.in/Fishers $argv; 
end
