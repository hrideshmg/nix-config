set -g fish_prompt_pwd_dir_length 0

# Disable Greeting
set -g fish_greeting

set -gx LS_COLORS (vivid generate snazzy)

# Color Scheme (adapted from Nord)
set -g fish_color_normal normal
set -g fish_color_command 5fd7d7
set -g fish_color_keyword 81a1c1
set -g fish_color_quote 87d787
set -g fish_color_redirection b48ead --bold
set -g fish_color_end 81a1c1
set -g fish_color_error d70000
set -g fish_color_param d8dee9
set -g fish_color_comment 4c566a --italics
set -g fish_color_selection d8dee9 --bold --background=434c5e
set -g fish_color_search_match --bold --background=434c5e
set -g fish_color_history_current e5e9f0 --bold
set -g fish_color_operator 81a1c1
set -g fish_color_escape ebcb8b
set -g fish_color_cwd 5e81ac
set -g fish_color_cwd_root bf616a
set -g fish_color_option 8fbcbb
set -g fish_color_valid_path --underline=single
set -g fish_color_autosuggestion 4c566a
set -g fish_color_user a3be8c
set -g fish_color_host a3be8c
set -g fish_color_host_remote ebcb8b
set -g fish_color_history_current e5e9f0 --bold
set -g fish_color_status bf616a
set -g fish_color_cancel --reverse
set -g fish_pager_color_prefix normal --bold --underline=single
set -g fish_pager_color_progress 3b4252 --bold --background=d08770
set -g fish_pager_color_completion e5e9f0
set -g fish_pager_color_description ebcb8b --italics
set -g fish_pager_color_selected_background --background=434c5e
set -g fish_pager_color_secondary_completion 
set -g fish_pager_color_selected_prefix 
set -g fish_pager_color_secondary_description 
set -g fish_pager_color_secondary_background 
set -g fish_pager_color_background 
set -g fish_pager_color_selected_description 
set -g fish_pager_color_secondary_prefix 
set -g fish_pager_color_selected_completion

# build git prompt
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showcolorhints 1
set -g __fish_git_prompt_use_informative_chars 1

set -g __fish_git_prompt_color_prefix 949494
set -g __fish_git_prompt_color_suffix 949494

set -g __fish_git_prompt_char_dirtystate ''
set -g __fish_git_prompt_char_invalidstate ''
set -g __fish_git_prompt_char_stagedstate ''
set -g __fish_git_prompt_char_untrackedfiles '󰐙'

set -g __fish_git_prompt_color_dirtystate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_stagedstate green
set -g __fish_git_prompt_color_untrackedfiles cyan

# build main prompt
function fish_prompt
	set -l cyan (set_color 5fd7ff)
	set -l reset (set_color normal)
	set -l pwd_str "$cyan"(prompt_pwd)"$reset"
	set -l git_str (fish_git_prompt " (%s)")
	echo -n "$pwd_str$git_str -> "
end
