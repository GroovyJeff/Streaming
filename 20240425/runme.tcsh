# spit out all the gsettings for reference

if $argv[1] == gsettings then

gsettings list-recursively | tee key-value-list.txt

endif
