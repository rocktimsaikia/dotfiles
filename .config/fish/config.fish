if status is-interactive
    # Commands to run in interactive sessions can go here

    # Source aliases
    if test -f ~/.aliases
        source ~/.aliases
    end

    function cd --description 'Change directory and auto-activate venv'
        # Store current directory for deactivation
        set -l old_pwd $PWD
        
        # Change to the new directory
        builtin cd $argv
        
        # Check if we successfully changed directories
        if test $status -eq 0
            # Deactivate any existing venv if we changed directories
            if test "$old_pwd" != "$PWD"
                if functions -q deactivate
                    deactivate
                end
            end
            
            # Auto-activate .venv if it exists in the new directory
            if test -f ".venv/bin/activate.fish"
                source .venv/bin/activate.fish
            end
        end
    end

end
