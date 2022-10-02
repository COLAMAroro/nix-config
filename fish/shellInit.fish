status --is-interactive; and begin # Make sure it's only run in interactive shell, it's mostly for nix-shells.
# It could be ommited by using `programs.fish.interactiveShellInit` in home.nix

if ! functions -q envsource # Make sure you have a function source .env files
    function envsource # https://gist.github.com/nikoheikkila/dd4357a178c8679411566ba2ca280fcc
        for line in (cat $argv | grep -v '^#' | grep -v '^\s*$')
            set item (string split -m 1 '=' $line)
            set -gx $item[1] $item[2]
            echo "Exported key $item[1]"
        end
    end
    funcsave envsource
end

if set -q PIPENV_ACTIVE # If somehow you are in a pipenv env, but it's only activated for back (fuck `pipenv shell` in nix-shells)
    . $(pipenv --venv)/bin/activate.fish # You want to activate if yourself for fish
    if test -e ".env"
        envsource ".env"
    end
else if set -q VIRTUAL_ENV && test -e ./env/bin/activate.fish # We are still in a python environment, but not with pipenv, just vanilla venv
    . ./env/bin/activate.fish
    if test -e ".env"
        envsource ".env"
    end
end

if set -q IS_NODE_ENV # We are in a NodeJS environment (exported in a shellHook in the shell.nix)
    functions -c fish_prompt _old_fish_prompt # Same old trick as venv, save the old prompt to do magic
    function fish_prompt
        echo -n "(node) "
        _old_fish_prompt
    end
end

end
