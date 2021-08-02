#!../../bin/linux-x86_64/Keithley2600

## You may have to change Keithley2600 to something else
## everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/Keithley2600.dbd"
Keithley2600_registerRecordDeviceDriver pdbbase

asynSetAutoConnectTimeout(1.0)
drvAsynIPPortConfigure( "SOURC1", "10.112.8.72:5025 tcp", 0, 0, 0 )
epicsEnvSet "STREAM_PROTOCOL_PATH", "$(KEITHLEY2600)/protocol"


#enables debugging 0xff is the max setting
asynSetTraceIOMask("SOURC1", 0,0x1)
asynSetTraceMask("SOURC1", 0,0x8)


## Load record instances
dbLoadRecords("db/keithley2600.db")

######################################################
#Autosave
epicsEnvSet("IOCNAME","bl4a-Keithley2600")
epicsEnvSet("SAVE_DIR","/home/controls/var/$(IOCNAME)")

save_restoreSet_Debug(0)

### status-PV prefix, so save_restore can find its status PV's.
save_restoreSet_status_prefix("BL4A:SM2600:")

set_requestfile_path("$(SAVE_DIR)")
set_savefile_path("$(SAVE_DIR)")

save_restoreSet_NumSeqFiles(3)
save_restoreSet_SeqPeriodInSeconds(600)
set_pass0_restoreFile("$(IOCNAME).sav")
############################################################




cd "${TOP}/iocBoot/${IOC}"
iocInit




epicsThreadSleep(5)
makeAutosaveFileFromDbInfo("$(SAVE_DIR)/$(IOCNAME).req", "autosaveFields")
create_monitor_set("$(IOCNAME).req", 5)

