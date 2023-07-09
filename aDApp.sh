#!/bin/sh
#
# aDApp.sh
#

box_fileworks () {
   local fDir="${1}"; local fTmp="${2}";
   local btf=""; local fVar="";

   dialog   --title "Fileworks - ${fDir}" \
            --backtitle "File Explorer" \
            --fselect "${fDir}" 24 64 2>"${fTmp}";

   # capture the action selected
   btf="$?";

   fVar=$(cat "${fTmp}");

   # decsion?
   case "${btf}" in
     0)
        echo "A: ${btf} Dir: ${fDir} VAR: ${fVar}\n";
        # A clipboard is an idea

        ;;
     1) ;;
     255)
     echo "[ESC] key pressed."
   esac

}

run_network () {
   local TmpFile="${DMMfle}"; local bNext="";
   local uVar=""; local iCnt=1; local vPrt="";
   local ifaces=""; local ifk=""; local ires="";
   ifaces=$(echo $(ls /sys/class/net/));

   # format a list to be displayed "%-4s %60s\n"
   for ifk in $(echo "${ifaces}" | tr ' ' '\n'); do

        vPrt=$(printf "%-4s %10s\n" "${vPrt} ${iCnt} ${ifk}");

   iCnt=$(($iCnt + 1));
   done

   # select from list
   dialog   --title "Network Interfaces - ${TmpFile}" \
            --backtitle "Net Experiment" \
            --menu "Select From List " 20 64 16 \
        $(echo "${vPrt}") 2>"${TmpFile}";

   # capture the action selected
   bNext="$?";

   # get data stored in TmpFile using input redirection
   uVar=$(cat "${TmpFile}");

   # decsion?
   case "${bNext}" in
     0)
        local SrcNme=""; local uNme=""; local nCnt=1;
        local k="";

        SrcNme=$(echo $(ls /sys/class/net/));
        for k in $(echo "${SrcNme}" | tr ' ' '\n'); do
                if [ "${uVar}" -eq "${nCnt}" ]; then
                        uNme=$(echo "${k}");
                fi
        nCnt=$(($nCnt + 1));
        done

        view_netiface "${uNme}";
        ;;
     1)
        ;;
     255)
     echo "[ESC] key pressed."
   esac

   rm "${TmpFile}"; sleep 1; touch "${TmpFile}";
}

view_netiface () {
   local nif="${1}"; local rif=""; local b="";
   local vue=""; local netTXT=""; local nGW="";
   rif=$(echo $(ifconfig "${nif}" | grep 'inet [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+'));
   rif=$(echo "${rif}" | sed "s/inet /inet+/");
   rif=$(echo "${rif}" | sed "s/netmask /netmask+/");
   rif=$(echo "${rif}" | sed "s/broadcast /broadcast+/");
   rif=$(echo "${rif}" | sed "s/ /:/");

   nGW=$(echo $(ip route show 0.0.0.0/0 | awk '{print $3}'));
   nGW=$(echo "Gateway ${nGW}");
   ntx="Although displayed, the Gateway IP is ";
   ntx="${ntx}a network system parameter that the interface needs ";
   ntx="${ntx}to communicate with other devices.";
   ntx="${ntx}\n\nGateway? Mostly blocked by MS and alike OSes if no internet.";
   ntx="${ntx}\nSan Anton 20230702";
   for vue in $(echo "${rif}" | tr ':' '\n'); do
        vue=$(echo "${vue}" | sed "s/+/ /");
        netTXT=$(printf '%5s %48s\n'  "${netTXT} ${vue}");
   done

   dialog   --title "Network Interfaces - ${nif}" \
            --backtitle "Net Experiment" \
            --msgbox "Interface Detail: \n${netTXT} \n${nGW}\n\n${ntx}" \
            20 48; ### 2>"${DMMfle}";

   # capture the action selected
   b="$?";

   # decsion? "nothing here"
   case "${b}" in
     0) ;;
     1) ;;
     255)
     echo "[ESC] key pressed."
   esac

}

get_Gvar () {
   local fName=$1; local Gvar=$2; local mEQ="";
   local mText=""; local mSrc=""; local gStr="";
   local k=""; local v="";

   if [ -f "${fName}" ]; then
      mText=$(cat "${fName}");
      gStr=$(echo "${mText}" | grep "${Gvar}" | cut -d'|' -f2);
      gStr=$(echo "${gStr}" | cut -d'=' -f2);

      for k in $(echo "${gStr}" | tr ',' '\n'); do

         for mSrc in $(echo "${mText}" | cut -d'|' -f3); do
            mEQ=$(echo "${mSrc}" | cut -d'=' -f1);
            if [ "${mEQ}" = "${k}" ]; then
               v=$(echo "${mSrc}" | cut -d'=' -f2);
               eval $(echo "$k=$v");
            fi
         done
      done
   fi
}

run_inputbox () {
   local OurFile="${DMMfle}"; local gButton="";
   local test_name="";

   # show the inputbox
   dialog   --title "InputBox Example - ${OurFile}" \
            --backtitle "A Dialog Experiment" \
            --inputbox "Baptize something " 8 60 2>"${OurFile}";

   # capture the button action
   gButton="$?";

   # get data stored in OurFile using input redirection
   test_name=$(cat "${OurFile}");

   # decsion?
   case "${gButton}" in
     0)
        echo ""; echo "";
        echo "Continue Process from user-input: ${test_name}\n";

        ;;
     1)
        sleep 1;
        ;;
     255)
     echo "[ESC] key pressed."
   esac

    echo ""; echo "";
    ui_pauseExit;
}

ui_pauseExit () {
   local entr=""; echo "";
   printf "%s" "Press Enter to continue ...";
   read entr; echo ""; return 1;
}

run_Dialog () {
   while true ; do
        DIALOG=${DIALOG=dialog}

        DMMtmp=`DMMtmp 2>/dev/null` || DMMtmp="${DMMfle}$$"
        trap "rm -f $DMMtmp" 0 1 2 5 15

        $DIALOG --clear --title "AHR(a dialog to?)" \
        --menu "Select a menu option as a staged process" 32 64 16 \
        "1" "Network Interfaces" \
        "2" "Test Input Box ala San Anton" \
        "3" "File Explorer with Dialog" \
        "4" "Include a file or source" \
	"5" "FormBox using sourced FuncLib" \
        "6" "Terminals do not display Chinese" \
        "Test"  "C'mon ... Hello World?" \
        "Exit"  "Exit to terminal mode " 2> $DMMtmp

        retval=$?

        choice=`cat $DMMtmp`

   case $retval in
   0)
        if [ "$choice" = "1" ]; then
           # network
           run_network;
        fi
        if [ "$choice" = "2" ]; then
           # inptbox
           run_inputbox;
        fi
        if [ "$choice" = "3" ]; then
           # File Explorer box
           box_fileworks "${DMMrot}" "${DMMfle}";
           ui_pauseExit;
        fi
        if [ "$choice" = "4" ]; then
      #equivalent of source
      local incDir=$(echo "${DMMini}" | cut -d'/' -f3);
      . ."/${incDir}/xFuncLib.sh";

           clear; fn_Line;
           echo "Include or source file\n";

      # test func included
      fn_this; echo ""; echo "";
      ui_pauseExit;
        fi
	if [ "$choice" = "5" ]; then
	   # FormBox
	local incDir=$(echo "${DMMini}" | cut -d'/' -f3);
	. ."/${incDir}/xFuncLib.sh";
	   fn_formBox;
	fi
        if [ "$choice" = "6" ]; then
           # cat file
           ui_etwo;
           cat "${DMMwrk}/xChineseQ.ahr";
           echo ""; echo "";
           echo "Copy and paste to notepad or word processor";
           echo "[If your terminal does not display such ? tongue]\n";
      echo "Use: BvSsh Client vs Powershell\n";
      echo "\tÂ© San Antonâ„¢ [t] AHR: in pretio procedere doctrina speramus";
      echo "\thttps://www.zerohedge.com/user/339741";
      echo ""; echo "";
      ui_pauseExit;
      
        fi
        if [ "$choice" = "Test" ]; then
           ui_etwo;
           echo "\n\tHello World\n";
           ui_pauseExit;
        fi
        if [ "$choice" = "Exit" ]; then
                ui_etwo;
                exit;
        fi

      ;;

   1)
        exit;
        return 0;; #Cancel pressed

   255)
        return 0;; # ESC pressed
   esac
   done
}

# "hardcoded because we know - config?"
cfgFile='/zLoc/VPN/aDConfig.ahr';
if [ -f "${cfgFile}" ]; then
        get_Gvar "${cfgFile}" "loc=";
        get_Gvar "${cfgFile}" "mma=";
        run_Dialog;
else
        echo "[Dialog APP] Missing Configuration: ${cfgFile}";
        sleep 4;
        exit 2;
fi
