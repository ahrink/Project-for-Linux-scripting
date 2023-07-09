#!/bin/sh
#
ui_etwo () { echo ""; echo ""; clear; clear; echo "\n"; }

ini_FileNdx () {
   local NdxFile=$1; local varNdx=""; local tCnt=1;
   local NdxLne=""; local fClone="${NdxFile}.tmp";
   local varNdx=$(cat "${NdxFile}");

   if [ ! -f "${fClone}" ]; then
        touch "${fClone}";
   else
        rm "${fClone}";
        sleep 1;
        touch "${fClone}";
   fi

   for NdxLne in $(echo "${varNdx}"); do
        echo "${tCnt}|${NdxLne}" >> "${fClone}";
   tCnt=$(($tCnt + 1));
   done

   rm "${NdxFile}";
   mv "${fClone}" "${NdxFile}";
   sleep 1;
}

run_Install () {
   ui_etwo;
   echo "${DMMwrk}\n${DMMtmp}\n${DMMbkp}\n";
   check_Version;
   # app structure and initialization
   local DMMrot=$(echo $(pwd));

   # Set defaults if not override
   if [ -z "${DMMwrk}" ]; then
	local DMMwrk="${DMMrot}/Demo";
   else
	local DMMwrk="${DMMrot}${DMMwrk}";
   fi
   if [ -z "${DMMtmp}" ]; then
	local DMMtmp="${DMMrot}/zDtmp";
   else
	local DMMtmp="${DMMrot}${DMMtmp}";
   fi
   if [ -z "${DMMbkp}" ]; then
	local DMMbkp="${DMMrot}/zBkup";
   else
	local DMMbkp="${DMMrot}${DMMbkp}";
   fi
   # files and path to file
   local DMMrun="${DMMrot}/aDStart.sh"; 	# app_start.sh
   local DMMfle="${DMMtmp}/aDTmp.ahr"; 		# mm_Temp.ahr
   local DMMapp="${DMMwrk}/aDApp.sh"; 		# mm_app.sh
   local DMMini="${DMMwrk}/aDConfig.ahr"; 	# ini_Demo.ahr
   local DMMcin="${DMMwrk}/xChineseQ.ahr"; 	# ChineseQ.ahr
   local DMMtxt="${DMMwrk}/xFuncLib.sh";	# FuncLib.sh

   # create workspace
   local dirNames="${DMMwrk},${DMMtmp},${DMMbkp}";
   ini_DirCre "${dirNames}";

   # create Dialog temporary file (DMMfle)
   echo "Dialog temporary file";
   if [ ! -f "${DMMfle}" ]; then
        touch "${DMMfle}";
        echo "\tCreated File: ${DMMfle}";
   else
        echo "\tFile Exists: ${DMMfle}";
   fi

   # mapping names k=v prospective (cumulate manipulate)
   if [ ! -f "${DMMini}" ]; then

     ## group ver
     local GiniDsc="Bash Version,CoreUtil Version,Dialog Version";
     local GiniVar="VerBash,VerCoreUtl,VerDialog";
     local k=""; local res="";

     # pack the key=val for further needs
     for k in $(echo "${GiniVar}" | tr ',' '\n'); do
        ###res=$(eval "res=\$$k");
	res=$(eval echo \${$k});
        rkey="${rkey}:${k}=${res}";
     done

     # call the config writer
     ini_Str2File "ver" "${rkey}" "${GiniDsc}" "${DMMini}";

     ## group loc
     local k=""; local rkey=""; local res="";
     local GlocDsc="Directory Path,Configuration File";
     local GlocVar="DMMrot,DMMini";

     # loc-pack the key=val
     for k in $(echo "${GlocVar}" | tr ',' '\n'); do
        res=$(eval echo \${$k});
        ###res=$(eval "res=\$$k");
        rkey="${rkey}:${k}=${res}";
     done

     ini_Str2File "loc" "${rkey}" "${GlocDsc}" "${DMMini}";

     ## group mma
     local k=""; local rkey=""; local res="";
     local GmmaDsc="Dialog Work Space,Dialog TMP-Folder,Dialog TMP-File,Dialog Application";
     local GmmaVar="DMMwrk,DMMtmp,DMMfle,DMMapp";

     # mma-pack the key=val
     for k in $(echo "${GmmaVar}" | tr ',' '\n'); do
        ###res=$(eval "res=\$$k");
	res=$(eval echo \${$k});
        rkey="${rkey}:${k}=${res}";
     done

     ini_Str2File "mma" "${rkey}" "${GmmaDsc}" "${DMMini}";

     ## reindex config file
     ini_FileNdx "${DMMini}";

     ## move files where they belong
     mv "${DMMrot}/aDApp.sh" "${DMMapp}";  # aDApp.sh
     mv "${DMMrot}/xChineseQ.ahr" "${DMMcin}"; # xChineseQ.ahr
     mv "${DMMrot}/xFuncLib.sh" "${DMMtxt}"; # xFuncLib.sh
     # copy components to backup
     cp "${DMMapp}" "${DMMbkp}/aDApp.sh";
     cp "${DMMrun}" "${DMMbkp}/aDStart.sh";
     cp "${DMMini}" "${DMMbkp}/aDConfig.ahr"
     cp "${DMMcin}" "${DMMbkp}/xChineseQ.ahr";
     cp "${DMMtxt}" "${DMMbkp}/xFuncLib.sh";
     cp "${DMMrot}/aDInstall.sh" "${DMMbkp}/aDInstall.sh";
     rm "${DMMrot}/aDInstall.sh";
     chmod +x "${DMMapp}";
     chmod +x "${DMMrun}";

     echo "Backup Complete to: ${DMMbkp}";
###     ls -l "${DMMbkp}";

   fi

   echo ""; echo ""; #ui_twoLine;
   echo "Display Config File: ${DMMini}";
   cat "${DMMini}";

   # only one file in DMMrot directory is aDStart.sh
   ls -l;

   # three lines must be replaced
   local orgFile="${DMMrot}/aDStart.sh";
   local srcLn='local ckFile=';
   local rplLn="local ckFile=\'${DMMini}\';";
   sed -i '/'"${srcLn}"'/'"c\\${rplLn}"'/' "${orgFile}";
   sleep 1;
   sed -i -e "s:;\/:;:" "${orgFile}";
   srcLn='local RunAPP=';
   rplLn="local RunAPP=\'${DMMwrk}/aDApp.sh\';";
   sed -i '/'"${srcLn}"'/'"c\\${rplLn}"'/' "${orgFile}";
   sleep 1;
   sed -i -e "s:;\/:;:" "${orgFile}";

   orgFile="${DMMapp}";
   srcLn='cfgFile=';
   rplLn="cfgFile=\'${DMMini}\';";
   sed -i '/'"${srcLn}"'/'"c\\${rplLn}"'/' "${orgFile}";
   sleep 1;
   sed -i -e "s:;\/:;:" "${orgFile}";

   echo "\n\n\tPlease run: sh ${DMMrun}";

}

run_aDialog () {
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

#	ui_mask;
	run_Install;

	ui_pauseExit;
	### rm -R "${DMMrot}/zTmp"; 
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
   #rm -R "${DMMrot}/zTmp";
   echo "End of programm\n\n";
}

ini_Str2File () {
   #
   local grpName=$1; local grpKey=$2; local grpDsc=$3;
   local grpFile=$4;
   local iDate=$(date +"%Y%m%d%H%M%S");

   # create ini file
   if [ ! -f "${grpFile}" ]; then
        echo "\nConfig File NOT found: ${grpFile}";
        touch "${grpFile}";
        echo "\t\tCreated File: ${grpFile}";
   fi

   # replace 1st occurance
   local grpKey=$(echo "${grpKey}" | sed "s/://");

   # Group is an array of keys  (pOne/Part One)
   # cumulate keys in a group
   local pOne=""; local k=""; local eqKey="";
   local pTwo=""; local eqVal=""; local dk="";

   for k in $(echo "${grpKey}" | tr ':' '\n'); do
        eqKey=$(echo "${k}" | cut -d'=' -f1);
        eqVal=$(echo "${k}" | cut -d'=' -f2);
        pOne="${pOne},${eqKey}";
        pTwo="${pTwo}:${eqKey}=${eqVal}";
   done

   pOne=$(echo "${pOne}" | sed "s/,//");
   pOne="${grpName}=${pOne}|";
   pTwo=$(echo "${pTwo}" | sed "s/://");

   # the last part is to combine pOne+pTwo+Description+Date
   local k=""; local outrCt=1;
   local grpDsc=$(echo "${grpDsc}" | sed "s/ /.+./g");

   for dk in $(echo "${grpDsc}" | tr ',' '\n'); do
        local inrCnt=1;
        for k in $(echo "${pTwo}" | tr ':' '\n'); do
           if [ "${inrCnt}" -eq "${outrCt}" ]; then
                echo "${pOne}${k}|${dk}|${iDate}" >> "${grpFile}";
                sleep 1;
                echo "\tAdd: ${pOne}${k}|${dk}|${iDate}";
           fi

        inrCnt=$(($inrCnt + 1));
        done

   outrCt=$(($outrCt + 1));
   done
}

ui_pauseExit () {
   local entr=""; echo "";
   printf "%s" "Press Enter to continue ...";
   read entr; echo ""; return 1;
}

check_Version () {
   VerBash=""; VerCoreUtl=""; VerDialog="";
   VerBash=$(echo $(bash --version | cut -d',' -f2));
   VerBash=$(echo "${VerBash}" | cut -d' ' -f2 | cut -d'.' -f1,2);
   VerBash=$(echo "(${VerBash}/1)" | bc);

   VerCoreUtl=$(echo $(dd --version | cut -d' ' -f3));
   VerCoreUtl=$(echo "${VerCoreUtl}" | cut -d' ' -f1);
   VerCoreUtl=$(echo "(${VerCoreUtl}/1)" | bc);

   VerDialog=$(echo $(dialog --version | cut -d' ' -f2));
   VerDialog=$(echo "${VerDialog}" | cut -d'-' -f1);
   VerDialog=$(echo "(${VerDialog}/1)" | bc);
   ckVer="";

   if [ "${VerBash}" -lt 5 ]; then
        ckVer="${ckVer}\t\tRequires Bash version 5 or greater\n";
   fi

   if [ "${VerCoreUtl}" -lt 8 ]; then
        ckVer="${ckVer}\t\tRequires GNU CoreUtilities version 8 or greater\n";
   fi

   if [ "${VerDialog}" -lt 1 ]; then
        ckVer="${ckVer}\t\tRequires Dialog version 1 or greater\n";
   fi

   if [ ! -z "${ckVer}" ]; then
        printf "%b"  "${ckVer}";
        exit 1;
   fi
}

ini_DirCre () {
   local MMdir=$1; local MMcnt=1;
   echo "Directory Structure";
   for v in $(echo "${MMdir}" | tr ',' '\n') ; do

        if [ ! -d "${v}" ]; then
                mkdir -p "${v}";
                echo "\t${MMcnt}. Created: ${v}";
        else
                echo "\t${MMcnt}. Directory Exists: ${v}";
        fi

   MMcnt=$(($MMcnt + 1));
   done
}

run_aDialog;
