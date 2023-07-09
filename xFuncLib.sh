#!/bin/sh
# only functions here
# call this file as: . ./Demo/xFuncLib.sh (an equivalent of source)
#
ui_etwo () { echo ""; echo ""; clear; clear; echo "\n"; }

fn_Line () {
   echo ""; echo ""; clear;
   DMMrot=$(echo $(pwd)); ### to make sure
   l64chrs="---------------------------------------------------------------";
   printf "%b\n\n" "${l64chrs}";
}

fn_prompt () {
  # USE AS: if ui_prompt "Press Y/yes to confirm (N/n cancel): ";
    local yn="";
    while true; do
        read -p "$1 " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

fn_this () {
   local lstF=""; local fl=""; local rp="";
   local tDir="";

   echo "Hello World ${DMMrot}\n\n";

   tDir=$(dirname "$0");
   rp=$(readlink -f "${tDir}/funcLib.sh");

   echo "\tScript Dir: ${tDir} Script Path: ${rp}";
###Some sinister reaction is source [. ./Demo/file name]
###For some reason did not accept a full path to file

}

ui_pauseExit () {
   local entr=""; echo "";
   printf "%s" "Press Enter to continue ...";
   read entr; echo ""; return 1;
}

# Same function used by installer script
# The function creates its own tmp-file
fn_formBox () {
   local DMMrot=$(echo $(pwd));
   local iTmp="${DMMrot}/zTmp";
   local iFle="${iTmp}/fTemp.ahr";

   if [ ! -d "${iTmp}" ]; then
      mkdir -p "${iTmp}";
      echo "\tDirectory Created: ${iTmp}";
      touch "${iFle}";
   else
      echo "\tDirectory Exists: ${iTmp}";
      touch "${iFle}";
   fi

   local retval="";
   while true ; do
        DIALOG=${DIALOG=dialog}

        iTmp=`iTmp 2>/dev/null` || iTmp="${iFle}$$"
        trap "rm -f $iTmp" 0 1 2 5 15

        $DIALOG --clear --title "AHR(a dialog to?)" \
      --backtitle "A Dialog Experiment" \
      --form "Create Project Space: ${DMMrot}" 12 64 4 \
         "    Project Name Folder: " 1 1 "/Demo" 1 25 25 0 \
         "Dialog Temporary Folder: " 2 1 "/zDtmp" 2 25 25 0 \
         "  Project Backup Folder: " 3 1 "/zBkup" 3 25 25 0 2>"${iFle}";

        retval="$?";
   local nK=1; local vC=1; local vStr="";
   local sk="DMMwrk,DMMtmp,DMMbkp";
   vStr=$(cat "${iFle}");
   vStr=$(echo "${vStr}" | tr '\n' ',');
   vStr=$(echo "${vStr}" | cut  -d',' -f1,2,3);

   for k in $(echo "${sk}" | tr ',' '\n'); do
      v=$(echo "${vStr}" | cut  -d',' -f"${nK}");
      eval $(echo "$k=$v");
   nK=$(($nK + 1));
   done

   rm -R "${DMMrot}/zTmp";

   case "${retval}" in

   0)
   #This is where the action starts
   ui_etwo;
   echo "WorkSpace: ${DMMwrk}\nDTmp: ${DMMtmp}\nBackup: ${DMMbkp}\n\n";
   ui_pauseExit;
   return 0 ;;
   1)
   rm -R "${DMMrot}/zTmp";
        exit;
        return 0;; #Cancel pressed

   255)
   rm -R "${DMMrot}/zTmp";
        return 0;; # ESC pressed
   esac
   done
}

