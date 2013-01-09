#!/system/bin/sh
#

target=`getprop ro.board.platform`
case "$target" in
    "msm8960")
     echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
     echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
     echo 85 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
     echo 25000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
     echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
     echo 4 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
     echo 10 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential
     echo 384000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
     echo 384000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
     chown system /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
     chown system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
     chown system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
     chown system /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
     chown system /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
     chown root.system /sys/devices/system/cpu/mfreq
     chmod 220 /sys/devices/system/cpu/mfreq
     chown root.system /sys/devices/system/cpu/cpu1/online
     chmod 664 /sys/devices/system/cpu/cpu1/online
     chown system /sys/power/perflock
     chown system /sys/power/cpufreq_ceiling
     chown system /sys/power/cpunum_floor
     chown system /sys/power/cpunum_ceiling
     chown system /sys/power/powersave
     chown system /sys/power/launch_event
     chown system /sys/power/pnpmgr/apps/activity_trigger
     chmod 664 /sys/power/pnpmgr/apps/media_mode
     chown media.system /sys/power/pnpmgr/apps/media_mode
     chown system /sys/module/restart/parameters/notify_efs_sync
     echo "0,2,4,7,9,12" > /sys/module/lowmemorykiller/parameters/adj
	 echo "0" > /sys/devices/system/cpu/cpufreq/ondemand/powersave_bias
     chmod 444 /sys/devices/system/cpu/cpufreq/ondemand/powersave_bias
        ;;
esac

chown system /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate

emmc_boot=`getprop ro.emmc`
case "$emmc_boot"
    in "1")
        chown system /sys/devices/platform/rs300000a7.65536/force_sync
        chown system /sys/devices/platform/rs300000a7.65536/sync_sts
        chown system /sys/devices/platform/rs300100a7.65536/force_sync
        chown system /sys/devices/platform/rs300100a7.65536/sync_sts
    ;;
esac


# Post-setup services
case "$target" in
    "msm8660" | "msm8960")
        start adaptive
    ;;
esac

# Optimize SQlite databases of apps
if [ -e /data/adrenaline/engine/etc/sq_c ]; then
	echo "SQlite Counter File Exists"
	CNT=/data/adrenaline/engine/etc/sq_c
	SC=`cat $CNT`
	if [ $SC -eq 0 ]; then
		echo "1" > $CNT
		echo "First Boot"
		exit
	elif [ $SC -eq 1 ]; then
		echo "2" > $CNT
		echo "Second Boot"
		exit
	elif [ $SC -eq 2 ]; then
		echo "3" > $CNT
		echo "Third Boot"
		exit
	elif [ $SC -eq 3 ]; then
		echo "4" > $CNT
		echo "Forth Boot"
		exit
	elif [ $SC -eq 4 ]; then
		echo "Fifth Boot"
		echo "Now Optimizing"
		rm -f /data/adrenaline/engine/etc/sq_c
		touch /data/adrenaline/engine/etc/sq_c
		echo "0" > /data/adrenaline/engine/etc/sq_c
		for i in \
		`busybox find /data -iname "*.db"`; 
		do \
			/system/xbin/sqlite3 $i 'VACUUM;'; 
			/system/xbin/sqlite3 $i 'REINDEX;'; 
		done;

		if [ -d "/dbdata" ]; then
			for i in \
			`busybox find /dbdata -iname "*.db"`; 
			do \
				/system/xbin/sqlite3 $i 'VACUUM;'; 
				/system/xbin/sqlite3 $i 'REINDEX;'; 
			done;
		fi;


		if [ -d "/datadata" ]; then
			for i in \
			`busybox find /datadata -iname "*.db"`; 
			do \
				/system/xbin/sqlite3 $i 'VACUUM;'; 
				/system/xbin/sqlite3 $i 'REINDEX;'; 
			done;
		fi;


		for i in \
		`busybox find /sdcard -iname "*.db"`; 
		do \
			/system/xbin/sqlite3 $i 'VACUUM;'; 
			/system/xbin/sqlite3 $i 'REINDEX;'; 
		done;
	fi;
else
	touch /data/adrenaline/engine/etc/sq_c
	echo "0" > /data/adrenaline/engine/etc/sq_c
	echo "First Installation"
	echo "Now Optimizing"
		for i in \
		`busybox find /data -iname "*.db"`; 
		do \
			/system/xbin/sqlite3 $i 'VACUUM;'; 
			/system/xbin/sqlite3 $i 'REINDEX;'; 
		done;

		if [ -d "/dbdata" ]; then
			for i in \
			`busybox find /dbdata -iname "*.db"`; 
			do \
				/system/xbin/sqlite3 $i 'VACUUM;'; 
				/system/xbin/sqlite3 $i 'REINDEX;'; 
			done;
		fi;


		if [ -d "/datadata" ]; then
			for i in \
			`busybox find /datadata -iname "*.db"`; 
			do \
				/system/xbin/sqlite3 $i 'VACUUM;'; 
				/system/xbin/sqlite3 $i 'REINDEX;'; 
			done;
		fi;


		for i in \
		`busybox find /sdcard -iname "*.db"`; 
		do \
			/system/xbin/sqlite3 $i 'VACUUM;'; 
			/system/xbin/sqlite3 $i 'REINDEX;'; 
		done;
fi;

#capleds
echo 2 > /sys/class/leds/button-backlight/currents

#zipalign
LOG_FILE=/data/zipalign.log
ZIPALIGNDB=/data/zipalign.db

if [ -e $LOG_FILE ]; then
	rm $LOG_FILE;
fi;

if [ ! -f $ZIPALIGNDB ]; then
	touch $ZIPALIGNDB;
fi;

echo "Starting Automatic ZipAlign $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE

for DIR in /system/app /data/app ; do
  cd $DIR
  for APK in *.apk ; do
    if [ $APK -ot $ZIPALIGNDB ] && [ $(grep "$DIR/$APK" $ZIPALIGNDB|wc -l) -gt 0 ] ; then
      echo "Already checked: $DIR/$APK" | tee -a $LOG_FILE
    else
      zipalign -c 4 $APK
      if [ $? -eq 0 ] ; then
        echo "Already aligned: $DIR/$APK" | tee -a $LOG_FILE
        grep "$DIR/$APK" $ZIPALIGNDB > /dev/null || echo $DIR/$APK >> $ZIPALIGNDB
      else
        echo "Now aligning: $DIR/$APK" | tee -a $LOG_FILE
        zipalign -f 4 $APK /cache/$APK
        busybox mount -o rw,remount /system
        cp -f -p /cache/$APK $APK
        busybox rm -f /cache/$APK
        grep "$DIR/$APK" $ZIPALIGNDB > /dev/null || echo $DIR/$APK >> $ZIPALIGNDB
      fi
    fi
  done
done

touch $ZIPALIGNDB
echo "Automatic ZipAlign finished at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE

#Fix Contacts
CONTACT_DATA_DIR="/data/data/com.android.providers.contacts"
CONTACT_PIC_DIR="$CONTACT_DATA_DIR/files"
CONTACT_DB="$CONTACT_DATA_DIR/databases/contacts2.db"

if $TEST -d $CONTACT_PIC_DIR ; then
  $LOG -p i "Fixing contacts permissions"
  $CHMOD 666 $CONTACT_PIC_DIR/*
fi

if $TEST -f $SQLITE ; then
  RESTCONT=`$SQLITE $CONTACT_DB 'SELECT count(*) FROM raw_contacts WHERE is_restricted=1';`
  if [ "$RESTCONT" != 0 ] ; then
    $LOG -p i "Fixing contacts restrictions"
    $SQLITE $CONTACT_DB 'UPDATE raw_contacts SET is_restricted=0 WHERE is_restricted=1';
fi
  fi
  if [ -e /data/data/com.android.providers.contacts/databases/contacts2.db ] ; then
   /system/xbin/sqlite3 /data/data/com.android.providers.contacts/databases/contacts2.db VACUUM
   /system/xbin/sqlite3 /data/data/com.android.providers.contacts/databases/contacts2.db REINDEX
  fi 

# Optimized remounts
mount -o remount,nodev,nodiratime,noatime,delalloc,noauto_da_alloc,barrier=1 /system /system
mount -o remount,nodev,nodiratime,noatime,delalloc,noauto_da_alloc,barrier=0 /cache /cache
mount -o remount,nodev,nodiratime,noatime,delalloc,noauto_da_alloc,barrier=0 /data /data  

# mount system rw
mount -o remount,rw /dev/block/mmcblk0p35 /system

# Deep sleep volume wake
echo 1 > /sys/keyboard/vol_wakeup
