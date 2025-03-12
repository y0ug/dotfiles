# ZVM_KEYTIMEOUT=1.1
ZVM_ESCAPE_KEYTIMEOUT=0.01
ZVM_VI_INSERT_ESCAPE_BINDKEY=jj

# ZVM_INSERT_MODE_CURSOR="${ZVM_CURSOR_BLINKING_UNDERLINE}"
# ZVM_NORMAL_MODE_CURSOR="${ZVM_CURSOR_BLOCK}"
# ZVM_OPPEND_MODE_CURSOR="${ZVM_CURSOR_BLINKING_UNDERLINE}"
# ZVM_REPLACE_MODE_CURSOR="${ZVM_CURSOR_BLINKING_UNDERLINE}"
# ZVM_VISUAL_MODE_CURSOR="${ZVM_CURSOR_BLOCK}"
# ZVM_VISUAL_LINE_MODE_CURSOR="${ZVM_CURSOR_BLOCK}"
#
ZVM_READKEY_ENGINE="${ZVM_READKEY_ENGINE_NEX}"
# ZVM_LINE_INIT_MODE="${ZVM_MODE_INSERT}"
ZVM_VI_SURROUND_BINDKEY="s-prefix"

ZVM_VI_HIGHLIGHT_FOREGROUND='#e5e9f0'
ZVM_VI_HIGHLIGHT_BACKGROUND='#434c5e'

bindkey -M vicmd 'K' run-help
bindkey -M viins '^Y' forward-word
bindkey -M vicmd '^Y' forward-word

bindkey -M viins '^\t' autosuggest-accept
bindkey -M vicmd '^\t' autosuggest-accept

bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
bindkey -M vicmd '^P' up-line-or-history
bindkey -M vicmd '^N' down-line-or-history

# ctrl backspace delete word
bindkey -M viins '^H' backward-kill-word
# bindkey -M viins '^?' backward-kill-word
bindkey -M vicmd '^H' backward-kill-word
# bindkey -M vicmd '^?' backward-kill-word

# showkey -a
