#Makefile at top of application tree
TOP = .
include $(TOP)/configure/CONFIG
DIRS += configure
DIRS += fcApp

#ifeq ($(BUILD_IOCS), YES)
#DIRS += fcDemoApp
#fcDemoApp_DEPEND_DIRS += fcApp
#iocBoot_DEPEND_DIRS += fcDemoApp
#DIRS += iocBoot
#endif

include $(TOP)/configure/RULES_TOP
