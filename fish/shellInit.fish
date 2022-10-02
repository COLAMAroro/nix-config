status --is-interactive; and begin

if set -q PIPENV_ACTIVE
    . $(pipenv --venv)/bin/activate.fish
    if test -e ".env"
        envsource ".env"
    end
else if set -q VIRTUAL_ENV && test -e ./env/bin/activate.fish
    . ./env/bin/activate.fish
    if test -e ".env"
        envsource ".env"
    end
end

if set -q IS_NODE_ENV
    functions -c fish_prompt _old_fish_prompt
    function fish_prompt
        # Save the return status of the last command
        echo -n "(node) "
        _old_fish_prompt
    end
end

end
