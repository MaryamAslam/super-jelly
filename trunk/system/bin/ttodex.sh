#!/system/bin/sh

# tommytomatoe customs.
echo "brought to you by tommytomatoe customs"
echo ""
echo "PLEAESE READ ENTIRE SCRIPT BEFORE PROCEEDING"
echo ""

# Mounting system as R/W
echo "Mounting System with R/W"
mount -t yaffs2 -o remount,rw /dev/block/mtdblock3 /system

# Wipe dalvik-cache
echo "Wiping data/dalvik-cache";
rm /data/dalvik-cache/*;
echo ""

odex_core()
{	echo "Deleting existing .odex files";
	rm /system/framework/*.odex;
	echo "tommytomatoe odex: initiating dexopt-wrapper on core framework files";
	dexopt-wrapper /system/framework/core.jar /system/framework/core.odex;
	dexopt-wrapper /system/framework/ext.jar /system/framework/ext.odex;
	dexopt-wrapper /system/framework/framework.jar /system/framework/framework.odex
	dexopt-wrapper /system/framework/android.policy.jar /system/framework/android.policy.odex;
	dexopt-wrapper /system/framework/services.jar /system/framework/services.odex;
}

odex_core_aosp_gb()
{	echo "Deleting existing .odex files";
	rm /system/framework/*.odex;
	echo "tommytomatoe odex: initiating dexopt-wrapper on core framework files";
	dexopt-wrapper /system/framework/core.jar /system/framework/core.odex;
	dexopt-wrapper /system/framework/bouncycastle.jar /system/framework/bouncycastle.odex
	dexopt-wrapper /system/framework/ext.jar /system/framework/ext.odex;
	dexopt-wrapper /system/framework/framework.jar /system/framework/framework.odex
	dexopt-wrapper /system/framework/android.policy.jar /system/framework/android.policy.odex;
	dexopt-wrapper /system/framework/services.jar /system/framework/services.odex;
	dexopt-wrapper /system/framework/core-junit.jar /system/framework/core-junit.odex
}

odex_core_sense_gb()
{	echo "Deleting existing .odex files";
	rm /system/framework/*.odex;
	echo "tommytomatoe odex: initiating dexopt-wrapper on core framework files";
	dexopt-wrapper /system/framework/core.jar /system/framework/core.odex;
	dexopt-wrapper /system/framework/bouncycastle.jar /system/framework/bouncycastle.odex
	dexopt-wrapper /system/framework/ext.jar /system/framework/ext.odex;
	dexopt-wrapper /system/framework/framework.jar /system/framework/framework.odex
	dexopt-wrapper /system/framework/android.policy.jar /system/framework/android.policy.odex;
	dexopt-wrapper /system/framework/services.jar /system/framework/services.odex;
	dexopt-wrapper /system/framework/core-junit.jar /system/framework/core-junit.odex
	dexopt-wrapper /system/framework/com.htc.commonctrl.jar /system/framework/com.htc.commonctrl.odex
	dexopt-wrapper /system/framework/com.htc.framework.jar /system/framework/com.htc.framework.odex
	dexopt-wrapper /system/framework/com.htc.android.pimlib.jar /system/framework/com.htc.android.pimlib.odex
	dexopt-wrapper /system/framework/com.htc.android.easopen.jar /system/framework/com.htc.android.easopen.odex
	dexopt-wrapper /system/framework/com.scalado.util.ScaladoUtil.jar /system/framework/com.scalado.util.ScaladoUtil.odex
	dexopt-wrapper /system/framework/com.orange.authentication.simcard.jar /system/framework/com.orange.authentication.simcard.odex
}

odex_framework()
{	echo "tommytomatoe odex: initiating 	dexopt-wrapper on framework files";
	for i in /system/framework/*
		do
			odex=`echo $i | sed -e 's/.jar/.odex/g'`
			echo "tt odex: dexopt-wrapper $i $odex"
			dexopt-wrapper $i $odex
		done
}

odex_system()
{	echo "removing existing odex files";
	rm system/app/*odex;
echo "tommytomatoe odex: initiating 	dexopt-wrapper on system apps";
	for i in /system/app/*.apk
	do
	odex=`echo $i | sed -e 's/.apk/.odex/g'`
	echo "dexopt-wrapper $i $odex"
	dexopt-wrapper $i $odex
	done
}

odex_data()
{	echo "removing existing odex files";
	rm data/app/*odex
echo "tommytomatoe odex: initiating 	dexopt-wrapper on data apps";
	for i in /data/app/*.apk
		do
			odex=`echo $i | sed -e 's/.apk/.odex/g'`
			echo "tt odex: dexopt-wrapper $i $odex"
			dexopt-wrapper $i $odex
		done

echo "tommytomatoe odex: initiating  dex-wrapper on data app-private";
	for i in /data/app-private/*.apk
		do
			odex=`echo $i | sed -e 's/.apk/.odex/g'`
			echo "tt odex: dexopt-wrapper $i $odex"
			dexopt-wrapper $i $odex
		done
}

if [[ "${1}" == "-CO-a" ]]
	then
		odex_core;
		exit;
else
	if [[ "${1}" == "-CO-b" ]]
		then
			odex_core_aosp_gb;
			exit;
		else
			if [[ "${1}" == "-CO-c" ]]
				then
					odex_core_sense_gb;
					exit;
				else
					if [[ "${1}" == "-FA" ]]
						then
							odex_framework;
							exit;
						else
							if [[ "${1}" == "-SA" ]]
								then
									odex_system;
									exit;
								else
									if [[ "${1}" == "-DA" ]]
										then
											odex_data;
											exit;
										else
											if [[ "${1}" == "-ALL-a" ]]
												then 
													odex_core;
													odex_framework;
													odex_system;
													odex_data;
													exit;
												else
													if [[ "${1}" == "-ALL-b" ]]
														then
															odex_core_aosp_gb;
															odex_framework;
															odex_system;
															odex_data;
															exit;
														else
															if [[ "${1}" == "-ALL-c" ]]
																then
																	odex_core_sense_gb;
																	odex_framework;
																	odex_system;
																	odex_data;
																	exit;
								else
									echo "What you need to do"
									echo "To optimize dalvik executable..."
									echo ""
									echo "Commands | Please use syntax 'sh ttodex.sh -__'"
									echo ""
									echo " [-CO-a]  |  Core Framework Files-Sense Froyo"
									echo " [-CO-b]  |  Core Framework Files-AOSP GB"
									echo " [-CO-c]  |  Core Framework Files-Sense GB"
									echo " [-FW]  	|  Framework Files"
									echo " [-SA]  	|  System Apps"
									echo " [-DA]  	|  Data Apps/App-Private"
									echo " [-ALL-a] |  Everything in Correct Order-Sense Froyo"
									echo " [-ALL-b] |  Everything in Correct Order-AOSP GB"
									echo " [-ALL-c] |  Everything in Correct Order-Sense GB"
									echo ""
									echo ""
									echo "Notes."
									echo "Correct order to Odex ROM..."
									echo "1. Core Files first"
									echo "2. then Framework Files"
									echo "3. then System Apps and Data Apps"
									echo "Never odex apps before framework."									
									echo "Never odex apps before framework."
									echo "Never odex apps before framework."
									echo "else you will go into a bootloop frenzy..."
									echo ""
									echo "If you have not made a nandroid backup..."
									echo "Please do so now!"
									echo ""
									echo "For Troubleshooting"
									echo "please visit themikmik.com"
									echo ""
									echo "brought to you by"
									echo ""
									echo "tommytomatoe"
									echo ""
									echo "enjoy the possibilities"
									echo ""
											fi
										fi
									fi
								fi
							fi
						fi
					fi
			fi
fi
	
	
