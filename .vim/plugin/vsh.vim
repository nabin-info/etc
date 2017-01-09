" Better shell interaction, by Ryan Nabinger 


" VsudoWrite writes as root (via sudo), so you can vim unpriviledged
" Usage: :VsudoWrite
command! -nargs=0 VsudoWrite :silent 
    \ write !sudo tee >/dev/null 2>/dev/null %

" Vman opens a manpage in a new window
" Usage: :Vman 3 stat
command! -complete=shellcmd -nargs=1 Vman :silent 
    \ exec 'new man\ ' . fnameescape(<f-args>) 
    \ | setl ma bt=nofile bh=wipe noswf fdc=0
    \ | exec 'silent %!man <args>' | 0
    \ | setl ft=man 
    \ | redraw

" Vsh runs a shell command, putting the output in a new window
" Usage: :Vsh dmesg | grep -i 'sd[a-z]'
command! -complete=shellcmd -nargs=1 Vsh :silent 
    \ exec 'new ' . fnameescape(<f-args>) 
    \ | setl ma bt=nofile bh=wipe noswf fdc=0
    \ | exec 'silent %!' . <q-args> | 0
    \ | redraw

" VshSelection
