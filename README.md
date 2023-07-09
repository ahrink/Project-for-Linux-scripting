# Project-for-Linux-scripting
Offers a fast way to customize "the" work space 
A Dialog to? – experiment (transformation, composition, motif)

transformation -- an indirect process residing in memoriam (postmortem)

Prior motif: https://github.com/ahrink/Dialog-sh-script-101

Contains working examples “under the hood” to further explore possibilities of development; 
- bringing up a LAMP server, why not. 
- Until then, the best there is,
San Anton 20230708

Composition? Same motif [as Dialog-sh-script-101] except renamed all files, adding user input process, cleaning up a few leftover. Verified all links and apparently didn’t failed. – it is functioning.

This is now a project that will require many branches depending on the OS version and “tools” employed. 
Thinking of a “title”? -- if it is not a tools box, it is a toy.

Anybody could bring updates as long as it is a working code. 

Composition:
1. Installer is also the initializer: DemoINI.sh -> aDInstall.sh
2. Validator to start Dialog; app_start.sh -> aDStart.sh
3. [work space] a Dialog experiment -> per user-input
4. All other components are Files [used by aDApp.sh]
5. This code was tested and working on fresh Ubuntu 22.04

Process: [all confined to a folder]
Once the app is initialized is expecting the user to enjoy a variety of shell sh programing mostly focused on Dialog usage. However, the working-code includes examples that many coders have a hard time understanding. As a result, a secondary thought is implied eg didactic.

Have fun,
San Anton
PS: All open code, and spare my intellect from wasting time with writing disclaimers, infringements etc.
Fact is, it is provided as is with no liability attach other than didactic.
More when it comes as it comes:
© San Anton™ [t] AHR: in pretio procedere doctrina speramus
        https://www.zerohedge.com/user/339741

20230709 Meanwhile, had the opportunity to run the app with a CentOS Linux release 8.4.2105 that include GNU coreutils 8.30, GNU bash version 4.4.19(1) – of course had to modify the limitation set by the code-internals for Bash 5+. -- Although the app was working, did not performed as expected.

Other issues with current code: Omissions? 
1. net-tools. Is a requirement unless “Network Interfaces” have to be rewritten.
2. Backup as a task listed on “main menu” [if is not there it means I am cooking something]
3. Error checking – forgot about why logs [a Gotcha].

Reminders: “fresh OS install”;
Ubuntu 22.04 Dependencies after fresh install
[if you ask me to replicate -- iWouldn’t remember]
- ssh installer@IP
- the key provided is the ssh password
- setup root # no sudo in this version (perhaps will never be)
   +REM: a sudo user was added during install
- apt-get dist-upgrade
- add-apt-repository universe #includes Dialog
- apt install dialog
- apt install net-tools # issues?
# backup – as it comes when it comes ...
# Error checking ...

… Another note on this subject or rather an interesting fact/discovery is that the code is rewriting three lines [affecting two files] due/Do2 to the user’s input process. A dynamic code? …

Irritating? Challenges are sometimes irritating when unable to validate user-input prior actions. “But I do trust the code. However, never trusted the user”.

An approach or a thought-reminder on how2 error checking improve the code. What is or why “we” have logs? A log file reserved for running each individual “creation” process and deleted if successful phase was completed. 
Composition/Creation (installer, validator, final-app) -> as a result this process will be staged to keep a log-file – the app-log. 
[app-log should be added to “config”.ahr as a reusable item]

Gotcha! Is a good expression for log writing? What if the user starts the final app skipping the process (installer, validator)? 
That is a good Gotcha.
… [do2/due/because diligence]

# disliking long names and baptizing to
1. aDInstall.sh # Installer
2. aDStart.sh # Validator
3. aDApp.sh # main menu
4. aDConfig.ahr # core config-file
5. aDTmp.ahr # dialog required tmp space
6. xChineseQ.ahr # case/example code
7. xFuncLib.sh # case/example code

# asking the proper questions:
uQ="DMMwrk,DMMtmp,DMMbkp";

# assign default names "a good practice"
uQ="DMMwrk:/Demo,DMMtmp:/zDtmp,DMMbkp:/zBkup";

#for each Q a correlated-phrase (if words)
i7F="aDInstall.sh,aDStart.sh,aDApp.sh,aDConfig.ahr,aDTmp.ahr,xChineseQ.ahr,xFuncLib.sh";
20230708 [i7F to code this correlation, looks like it needs error checking and backup]

...
