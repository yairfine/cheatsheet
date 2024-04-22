# cheatsheet

This is a tool to create a own cheatsheet for shell commands.<br>
It acts a bit like aliases and shell history -> a list of commands you stored with execution.<br>
<br>
Take a quick look at my dotfiles to see how my acutal public .cheatsheet file looks like.<br>
source: [.cheatsheet](https://github.com/m1well/dotfiles/blob/master/.cheatsheet)<br>

## Problem
I am now at the point where I often use commands like<br>
`$ docker system prune -a` or `$ git reset --soft HEAD^`<br>
and I don't want to google them if I need them ad hoc and don't memorize them in this moment.<br><br>
Aliases are cool, but if I start working only with aliases and someone asks me "how can I reset my commit?" - of course I can't tell him my alias. ;)<br>
The shell history is also cool, but a bit to long (even if you grep).<br>
So therefore I was thinking about to combine these functions into one tool.<br>

## Solution

A tool where I can store all my recently used shell commands, list them,
execute them, add new commands (append a comment if I want) and of course also delete them.


So if I am looking e.g. for a command to enter a running docker container - I search in my stored commands:
```shell
cheatsheet.sh -l 'docker exec'
```
and I get an answer of my stored output:<br>
```shell
//-----------------------------//
//-------- cheatsheet  --------//
list of greped commands (with line number)
01: docker exec -it {1} /bin/bash # enter running docker container
//-----------------------------//
```

## Setup

```shell
# clone and install
git clone <repo-url>
cd cheatsheet
chmod u+x install.sh
sudo ./install.sh

# print version
cs -v
```

## Usage

```shell
cs [-a|-l|-e|-r|-b|-i|-h|-v]
```

lets say we actually have following cheatsheet (the commands are simple just to understand the principles):
```shell
//-----------------------------//
//-------- cheatsheet  --------//
list of all commands (with line number)
01:  git add . # add all untracked files
02:  git commit -m "{1}" # commit with a given message
03:  git push origin --force-with-lease # push origin force-with-lease
//-----------------------------//
```

#### You can just run the script and...

##### ...add a command to your cheatsheet:
`$ cs -a 'git status'`<br>
the result would be the same list as above with an additional line for `git status`:
```shell
01:  git add . # add all untracked files
02:  git commit -m "{1}" # commit with a given message
03:  git push origin --force-with-lease # push origin force-with-lease
04:  git status
```

##### ...list all commands in your cheatsheet:
`$ cs -l all`<br>
this would be the same result as the starting list plus the new `git status` command

##### ...show/grep a specific command in your cheatsheet:
`$ cs -l 'commit'`<br>
result would be:<br>
```
//-----------------------------//
//-------- cheatsheet  --------//
list of greped commands (with line number)
02:  git commit -m "{1}" # commit with a given message
//-----------------------------//
```

##### ...execute a command by linenumber:
`$ cs -e 4` <br>
The fourth command `git status` is going to be executed (and shows the status of your current git repo).<br>

##### ...execute a command by linenumber with one additional parameter:
`$ cs -e 2,'this is a message for my commit'`<br>
Then the third command `git commit -m "{1}"` is going to be executed.<br>
Here the additional parameter enables you to put an individual message to the commit.<br>
The result would be the following lines (with the possible output of the execution)<br>
```
//-----------------------------//
//-------- cheatsheet  --------//
now executing following command (possible output below cheatsheet endline)
$ git commit -m "{1}" # commit with a given message
//-----------------------------//
[execution-function 31abc5b] this is a message for my commit
 2 files changed, 15 insertions(+), 15 deletions(-)
```

##### ...remove a command by linenumber from your cheatsheet:
`$ cs -r 1`<br>
the result would be following:<br>
```
//-----------------------------//
//-------- cheatsheet  --------//
successfully removed following command from the cheatsheet
git add . # add all untracked files
//-----------------------------//
```

##### ...remove all commands from your cheatsheet:
`$ cs -r all`
This deletes the whole cheatsheet file.<br>

#### Furthermore you can...

##### ...backup the cheatsheet:
`$ cs -b '[path-for-backup]'`

##### ...import commands from a cheatsheet backup:
`$ cs -i '[path-to-backup]'`

##### ...check the usage/help:
`$ cs -h`

##### ...check the version:
`$ cs -v`


## Environment Info
##### unix
I am not so familiar with all different unix shells, but I think u can use it with all standard shells<br>
##### windows
For windows I take the gitBash shell to use the cheatsheet<br>


## Hint
Actually backslashes in commands are not allowed!! (due to bad display of them)<br>
Don't use a `-` at first character to search a command! (becaus grep think it is a new option) and to add a command.


## Contribution
You are welcome to contribute this project! Please follow the standard rules.<br>
If you find a bug or have an idea for improvement, then please firstly open an issue.<br>
If you are creating a Pull Request, please update the version & date of last change in the script - and use [Semantic Versioning](http://semver.org).<br>
Also please take care to indent with 3 spaces.<br>
Thank you.<br>


## TODO
* [x] add release branch<br>
* [x] add posibility to execute commands<br>
* [x] add a backup function for the cheatsheet<br>
* [x] add a import function to import an existing cheatsheet (rows from an existing cheatsheet)<br>
* [x] add posibility to make comments (and test it) and also search for them (e.g: 'git commit --amend # changes the last commit')<br>
* [ ] improve the export/import to work with different lists<br>
* [ ] add another script for "automated tests" (just to improve scripting skills)<br>


## P.S.
The main reason for this project for me is just to learn more about the git/github behaviour, the versioning (like semver) and also to get some more scripting skills.<br>
So if you have some interesting points, then let me know. :)<br>


## Copyright and License
Copyright :copyright: 2017 Michael Wellner ([@m1well](http://www.twitter.m1well.de))<br>
Code released under the [MIT License](/LICENSE).<br>
