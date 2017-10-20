#!/usr/bin/env python3

# docs say hamsterlib, aur installs it as hamster_lib
import hamster_lib

hamLib = hamster_lib.HamsterControl({
   'work_dir': '/tmp/hamster-lib',
   'store': 'sqlalchemy',
   'db_path': '~/.config/hamster-lib.db',
   'tmpfile_name': 'hamsterlib-outgoing.fact',
   'fact_min_delta': ''
})
