#!/bin/sh -x

# set -o errexit

t=time
$t rsync -rlptv --delete nyx:/export/horst/\*   /usr/export/horst/docs/
$t rsync -rlptv --delete nyx:/export/photo/\*   /usr/export/horst/foto/
$t rsync -rlptv --delete nyx:/export/music/\*   /usr/export/horst/audio/
$t rsync -rlptv --delete nyx:/export/movie/\*   /usr/export/horst/video/
$t rsync -rlptv --delete nyx:/export/install/\* /usr/export/install/

#  ----------------
#  disk   multimedia/
#  ----------------
#  ----   oracle/
#         backup/
#  -> do  info/
#  ----------------
#  done   agoracon/          
#  done   horst/
#  done   install/
#  done   movie/
#  done   music/
#  done   photo/
#  ----------------
