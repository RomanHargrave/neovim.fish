function __neovim_disambiguate_paths
    printf '%s\n' $argv | xargs -n1 realpath
end

# Only enable this functionality if NVIM_LISTEN_ADDRESS is defined
function __neovim_define_helpers

    function nvim
        nvimex tabnew (__neovim_disambiguate_paths $argv)
    end

    alias   vim     nvim
    alias   evim    nvim
    alias   rvim    nvim

    function vimdiff
        if [ (count $argv) -eq 2 ]
            nvimex diff (__neovim_disambiguate_paths $argv)
        else
            echo "2 Arguments Required"
        end
    end

    function edit
        nvimex edit (__neovim_disambiguate_paths $argv)
    end

    alias   e   edit

    function vsplit
        nvimex vsplit (__neovim_disambiguate_paths $argv)
    end

    alias   vs  vsplit

    function split
        nvimex split (__neovim_disambiguate_paths $argv)
    end

    alias   sp  split

    alias   :   nvimex

    function __neovim_pass_to_vim -e fish_command_not_found
        if set __command (echo $argv | grep -Po '(?<=^:).*')
            nvimex $__command
        end
    end
end

function __neovim_erase_helpers

    for helper_name in {nvim, vim, evim, rvim, vimdiff, edit, e, vsplit, vs, split, sp, :, __neovim_pass_to_vim}
        functions -e $helper_name
    end

end

function __neovim_handle_socket_var -v NVIM_LISTEN_ADDRESS
    if set -q NVIM_LISTEN_ADDRESS
        __neovim_define_helpers
    else
        __neovim_erase_helpers
    end
end

# init on load

set plugin_loc  (dirname (status -f))
set plugin_bin  $plugin_loc/bin

set -gx PATH    $PATH $plugin_bin

if set -q NVIM_LISTEN_ADDRESS
    __neovim_define_helpers
end
