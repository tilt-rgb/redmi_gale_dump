#! /system/bin/sh

DATA_DUMPLOG_PATH=/data/miuilog/bsp/audio
args="$1"

function CaptureAudioBinderInfo(){
   umask 000
   CURTIME=`date +%F-%H-%M-%S`
   BINDER_INFO_DIR=${DATA_DUMPLOG_PATH}/audio_crash_binderinfo/binder_audio_crash_${CURTIME}
   if [ ! -d ${SDCARD_LOG_BASE_PATH}/binder_info/ ];then
   mkdir -p ${BINDER_INFO_DIR}
   fi
   cat /dev/binderfs/binder_logs/state > ${BINDER_INFO_DIR}/state
   cat /dev/binderfs/binder_logs/stats > ${BINDER_INFO_DIR}/stats
   cat /dev/binderfs/binder_logs/transaction_log > ${BINDER_INFO_DIR}/transaction_log
   cat /dev/binderfs/binder_logs/transactions > ${BINDER_INFO_DIR}/transactions
   ps -A -T > ${BINDER_INFO_DIR}/ps.txt
   debuggerd -b $(pidof audioserver) > ${BINDER_INFO_DIR}/audioserver.txt
   debuggerd -b $(pidof android.hardware.audio.service-aidl.mediatek) > ${BINDER_INFO_DIR}/android.hardware.audio.service-aidl.mediatek.txt
   debuggerd -b $(pidof audiohalservice.qti) > ${BINDER_INFO_DIR}/audiohalservice.qti.txt
   debuggerd -b $(pidof system_server) > ${BINDER_INFO_DIR}/system_server.txt
   # sleep 1
   # cp -r /data/anr/*  ${BINDER_INFO_DIR}/
   # cp -r /data/tombstones/*  ${BINDER_INFO_DIR}/
   logcat -d | timeout 2 cat > ${BINDER_INFO_DIR}/logcat.txt
}

case "$args" in
    "captureAudioBinderInfo")
        CaptureAudioBinderInfo
        ;;
       *)
      ;;
esac
