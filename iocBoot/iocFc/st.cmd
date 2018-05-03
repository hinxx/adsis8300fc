< envPaths
errlogInit(20000)

dbLoadDatabase("$(TOP)/dbd/fcDemoApp.dbd")
fcDemoApp_registerRecordDeviceDriver(pdbbase)

# Prefix for all records
epicsEnvSet("PREFIX", "FC:")
# The port name for the detector
epicsEnvSet("PORT",   "FC")
# The queue size for all plugins
epicsEnvSet("QSIZE",  "20")
# The maximum number of time series points in the NDPluginStats plugin
epicsEnvSet("NCHANS", "64")
# The maximum number of time series points in the NDPluginTimeSeries plugin
epicsEnvSet("TSPOINTS", "600000")
# The maximum number of frames buffered in the NDPluginCircularBuff plugin
epicsEnvSet("CBUFFS", "500")
# The search path for database files
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")

epicsEnvSet("AICH0",      "AI0")
epicsEnvSet("AICH1",      "AI1")
epicsEnvSet("AICH2",      "AI2")
epicsEnvSet("AICH3",      "AI3")
epicsEnvSet("AICH4",      "AI4")
epicsEnvSet("AICH5",      "AI5")
epicsEnvSet("AICH6",      "AI6")
epicsEnvSet("AICH7",      "AI7")
epicsEnvSet("AICH8",      "AI8")
epicsEnvSet("AICH9",      "AI9")

# ADDR 0 .. 9 are for AI data
epicsEnvSet("NUM_CH",        "10")
# Number of samples to acquire
epicsEnvSet("NUM_SAMPLES",   "300000")
# The maximum number of time series points in the NDPluginTimeSeries plugin
epicsEnvSet("TSPOINTS",      "600000")

asynSetMinTimerPeriod(0.001)

# Uncomment the following line to set it in the IOC.
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "30000000")

# Create a Fc driver
# FcConfig(const char *portName, const char *devicePath,
#            int maxAddr, int numSamples, NDDataType_t dataType,
#            int maxBuffers, size_t maxMemory, int priority, int stackSize)
FcConfig("$(PORT)", "/dev/sis8300-5", $(NUM_CH), $(NUM_SAMPLES), 7, 0, 0)
dbLoadRecords("$(SIS8300)/db/SIS8300.template",        "P=$(PREFIX),R=,           PORT=$(PORT),ADDR=0,TIMEOUT=1")
dbLoadRecords("$(SIS8300)/db/SIS8300N.template",       "P=$(PREFIX),R=$(AICH0):,  PORT=$(PORT),ADDR=0,TIMEOUT=1,NAME=$(AICH0)")
dbLoadRecords("$(SIS8300)/db/SIS8300N.template",       "P=$(PREFIX),R=$(AICH1):,  PORT=$(PORT),ADDR=1,TIMEOUT=1,NAME=$(AICH1)")
dbLoadRecords("$(SIS8300)/db/SIS8300N.template",       "P=$(PREFIX),R=$(AICH2):,  PORT=$(PORT),ADDR=2,TIMEOUT=1,NAME=$(AICH2)")
dbLoadRecords("$(SIS8300)/db/SIS8300N.template",       "P=$(PREFIX),R=$(AICH3):,  PORT=$(PORT),ADDR=3,TIMEOUT=1,NAME=$(AICH3)")
dbLoadRecords("$(SIS8300)/db/SIS8300N.template",       "P=$(PREFIX),R=$(AICH4):,  PORT=$(PORT),ADDR=4,TIMEOUT=1,NAME=$(AICH4)")
dbLoadRecords("$(SIS8300)/db/SIS8300N.template",       "P=$(PREFIX),R=$(AICH5):,  PORT=$(PORT),ADDR=5,TIMEOUT=1,NAME=$(AICH5)")
dbLoadRecords("$(SIS8300)/db/SIS8300N.template",       "P=$(PREFIX),R=$(AICH6):,  PORT=$(PORT),ADDR=6,TIMEOUT=1,NAME=$(AICH6)")
dbLoadRecords("$(SIS8300)/db/SIS8300N.template",       "P=$(PREFIX),R=$(AICH7):,  PORT=$(PORT),ADDR=7,TIMEOUT=1,NAME=$(AICH7)")
dbLoadRecords("$(SIS8300)/db/SIS8300N.template",       "P=$(PREFIX),R=$(AICH8):,  PORT=$(PORT),ADDR=8,TIMEOUT=1,NAME=$(AICH8)")
dbLoadRecords("$(SIS8300)/db/SIS8300N.template",       "P=$(PREFIX),R=$(AICH9):,  PORT=$(PORT),ADDR=9,TIMEOUT=1,NAME=$(AICH9)")

# Create a standard arrays plugin, set it to get data from Fc driver.
NDStdArraysConfigure("Image1", 3, 0, "$(PORT)", 0)
# This creates a waveform large enough for 1000000x10 arrays.
#dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Float64,FTVL=DOUBLE,NELEMENTS=10000000")
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Float64,FTVL=DOUBLE,NELEMENTS=3000")

# Time series plugin for converted AI data
NDTimeSeriesConfigure("TS0", $(QSIZE), 0, "$(PORT)", 0, 10)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(PREFIX),R=TS0:,   PORT=TS0,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0,NCHANS=$(TSPOINTS),TIME_LINK=,ENABLED=1")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(PREFIX),R=TS0:0:, PORT=TS0,ADDR=0,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(AICH0)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(PREFIX),R=TS0:1:, PORT=TS0,ADDR=1,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(AICH1)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(PREFIX),R=TS0:2:, PORT=TS0,ADDR=2,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(AICH2)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(PREFIX),R=TS0:3:, PORT=TS0,ADDR=3,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(AICH3)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(PREFIX),R=TS0:4:, PORT=TS0,ADDR=4,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(AICH4)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(PREFIX),R=TS0:5:, PORT=TS0,ADDR=5,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(AICH5)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(PREFIX),R=TS0:6:, PORT=TS0,ADDR=6,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(AICH6)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(PREFIX),R=TS0:7:, PORT=TS0,ADDR=7,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(AICH7)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(PREFIX),R=TS0:8:, PORT=TS0,ADDR=8,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(AICH8)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(PREFIX),R=TS0:9:, PORT=TS0,ADDR=9,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(AICH9)")

# Timing MTCA EVR 300
# As per EVR MTCA 300 engineering manual ch 5.3.5
epicsEnvSet("SYS"               "FC")
epicsEnvSet("DEVICE"            "EVR")
epicsEnvSet("EVR_PCIDOMAIN"     "0x0")
epicsEnvSet("EVR_PCIBUS"        "0x8")
epicsEnvSet("EVR_PCIDEVICE"     "0x0")
epicsEnvSet("EVR_PCIFUNCTION"   "0x0")

#require mrfioc2,2.7.13
mrmEvrSetupPCI($(DEVICE), $(EVR_PCIDOMAIN), $(EVR_PCIBUS), $(EVR_PCIDEVICE), $(EVR_PCIFUNCTION))
dbLoadRecords("$(MRFIOC2)/db/evr-mtca-300.db", "DEVICE=$(DEVICE), SYS=$(SYS), Link-Clk-SP=88.0525")

# Trigger pulse
dbLoadRecords("$(MRFIOC2)/db/evr-softEvent.template", "DEVICE=$(DEVICE), SYS=$(SYS), EVT=14, CODE=14")
# MLVDS 0 (RearUniv32)
dbLoadRecords("$(MRFIOC2)/db/evr-pulserMap.template", "DEVICE=$(DEVICE), SYS=$(SYS), PID=0, F=Trig, ID=0, EVT=14")

set_requestfile_path("$(SIS8300)/SIS8300App/Db")
set_requestfile_path("$(FC)/fcApp/Db")

#asynSetTraceIOMask("$(PORT)",0,2)
#asynSetTraceMask("$(PORT)",0,255)

iocInit()

###############################################################################

# Set some defaults for FC
# internal clock; ~83.3 MHz
#dbpf $(PREFIX)ClockSource 0
#dbpf $(PREFIX)ClockDiv 3
# SMA clock; 88.0525 MHz
dbpf $(PREFIX)ClockSource 2
dbpf $(PREFIX)ClockDiv 1
# external trigger
dbpf $(PREFIX)TrigSource 1
# backplane 0
dbpf $(PREFIX)TrigLine 4
dbpf $(PREFIX)TrigRepeat 1
# SIS8900 RTM
dbpf $(PREFIX)RTMType 1
# Enable all channels
dbpf $(PREFIX)Enable 1
