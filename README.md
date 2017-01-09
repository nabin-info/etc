# etc
stash for ~/etc

**NOTE:  Many files here begin with a . and require `ls -A` to see them**

# usage
My usage is something like:

    cd ~
    ln -s src/nabin-info/etc.git etc
    ln -s ~/etc/.vimrc .vimrc

This causes my ~/.vimrc to be read from ~/etc/.vimrc 
Then changing my ~/.vimrc is as simple and changing the ~/etc symlink

# examples/
The examples directory is geared more towards snippets and conceptual configs
