#!/bin/bash

unreadMail=$(unreadMailCount)
unreadMailCount | grep '^0$' >/dev/null
if [[ $? == 0 ]]; then
	echo "#[fg=colour232,bg=colour238,bold]⮃#[fg=colour250,bg=colour238,nobold] ✉ `unreadMailCount` #[fg=colour232,bold]⮃"
else
	echo "#[fg=colour39,bg=colour238,nobold]⮂#[fg=colour238,bg=colour39,bold]✉ `unreadMailCount` #[fg=colour238,bg=colour39,nobold]⮂"
fi
