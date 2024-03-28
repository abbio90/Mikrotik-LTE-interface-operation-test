/system logging action
add disk-file-count=1 disk-file-name=flash/log-LTE disk-lines-per-file=4 name=\
    lte target=disk
/system logging
add action=lte prefix=LTE topics=error,script
