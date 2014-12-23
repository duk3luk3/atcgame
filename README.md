ATC Game
========

Dependencies:
* Löve 2D (http://www.love2d.org)

To run:

    git clone git@github.com:duk3luk3/atcgame.git
    cd atcgame
    love atcgame

## How to play:

Get the air planes to their destinations by giving them navigation commands!

The following command verbs are implemented right now:
  * `vector <name or heading>`: navigate to named navigation beacon or heading
  * `climb <alt>`: change altitude to given feet, in thousands if one or two digits
  * `speed <mph>`: change speed to given mph
  * `for <nm>`: follow course for a set number of nautical miles

A single command can consist of any combination of these verbs. The instructions will be executed simultaneously.

The additional command `next` allows you to queue another command; a command line that doesn't start with next clears the current command queue. The aircraft moves on to the next command in the queue when it reaches the navigational fixit is vectored to or when it has travelled the amount of distance indicated in a `for`.

Example commands:
  * UAL543 climb 5 next fix A speed 200
  * UAL876 next fix B

## TODO:

  * separation detection
  * airports
