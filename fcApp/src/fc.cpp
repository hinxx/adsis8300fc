/* fc.cpp
 *
 * This is a driver for a FC based on Struck SIS8300 digitizer.
 *
 * Author: Hinko Kocevar
 *         ESS ERIC, Lund, Sweden
 *
 * Created:  January 22, 2017
 *
 */


#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>
#include <math.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <assert.h>
#include <string>
#include <stdarg.h>

#include <epicsTime.h>
#include <epicsThread.h>
#include <epicsEvent.h>
#include <epicsExit.h>
#include <iocsh.h>

#include <asynNDArrayDriver.h>
#include <epicsExport.h>

#include <SIS8300.h>
#include <fc.h>


static const char *driverName = "Fc";


double time_msec() {
	struct timespec ts;

	clock_gettime(CLOCK_MONOTONIC, &ts);
	return (double) ts.tv_sec * 1.0e3 + ts.tv_nsec / 1.0e6;
}

/** Constructor for Fc; most parameters are simply passed to SIS8300::SIS8300.
  * After calling the base class constructor this method creates a thread to compute the simulated detector data,
  * and sets reasonable default values for parameters defined in this class and SIS8300.
  * \param[in] portName The name of the asyn port driver to be created.
  * \param[in] devicePath The path to the /dev entry.
  * \param[in] maxAddr The maximum  number of asyn addr addresses this driver supports. 1 is minimum.
  * \param[in] numParams The number of parameters in the derived class.
  * \param[in] numSamples The initial number of samples.
  * \param[in] dataType The initial data type (NDDataType_t) of the arrays that this driver will create.
  * \param[in] maxBuffers The maximum number of NDArray buffers that the NDArrayPool for this driver is
  *            allowed to allocate. Set this to -1 to allow an unlimited number of buffers.
  * \param[in] maxMemory The maximum amount of memory that the NDArrayPool for this driver is
  *            allowed to allocate. Set this to -1 to allow an unlimited amount of memory.
  * \param[in] priority The thread priority for the asyn port driver thread if ASYN_CANBLOCK is set in asynFlags.
  * \param[in] stackSize The stack size for the asyn port driver thread if ASYN_CANBLOCK is set in asynFlags.
  */
Fc::Fc(const char *portName, const char *devicePath,
			int maxAddr, int numSamples, NDDataType_t dataType,
			int maxBuffers, size_t maxMemory, int priority, int stackSize)

	    : SIS8300(portName, devicePath,
	    		maxAddr,
				numSamples,
				dataType,
				maxBuffers, maxMemory,
				priority,
				stackSize)

{
		D(printf("%d addresses\n", maxAddr));

    /* adjust number of NDArrays we need to handle, 0 - AI, 1 - FC */
    mNumArrays = 2;

		I(printf("Init done...\n"));
}

Fc::~Fc() {
	I(printf("Shutdown complete!\n"));
}

/** Report status of the driver.
  * Prints details about the driver if details>0.
  * It then calls the ADDriver::report() method.
  * \param[in] fp File pointed passed by caller where the output is written to.
  * \param[in] details If >0 then driver details are printed.
  */
void Fc::report(FILE *fp, int details)
{
    fprintf(fp, "FC\n");
    if (details > 0) {
    }

    /* Invoke the base class method */
    SIS8300::report(fp, details);
}

/** Configuration command, called directly or from iocsh */
extern "C" int FcConfig(const char *portName, const char *devicePath,
		int maxAddr, int numSamples, int dataType, int maxBuffers, int maxMemory,
		int priority, int stackSize)
{
    new Fc(portName, devicePath,
    		maxAddr,
    		numSamples,
			(NDDataType_t)dataType,
			(maxBuffers < 0) ? 0 : maxBuffers,
			(maxMemory < 0) ? 0 : maxMemory,
			priority, stackSize);
    return(asynSuccess);
}

/** Code for iocsh registration */
static const iocshArg configArg0 = {"Port name",     iocshArgString};
static const iocshArg configArg1 = {"Device path",   iocshArgString};
static const iocshArg configArg2 = {"# channels",    iocshArgInt};
static const iocshArg configArg3 = {"# samples",     iocshArgInt};
static const iocshArg configArg4 = {"Data type",     iocshArgInt};
static const iocshArg configArg5 = {"maxBuffers",    iocshArgInt};
static const iocshArg configArg6 = {"maxMemory",     iocshArgInt};
static const iocshArg configArg7 = {"priority",      iocshArgInt};
static const iocshArg configArg8 = {"stackSize",     iocshArgInt};
static const iocshArg * const FcConfigArgs[] = {&configArg0,
												 &configArg1,
												 &configArg2,
												 &configArg3,
												 &configArg4,
												 &configArg5,
												 &configArg6,
												 &configArg7,
												 &configArg8};
static const iocshFuncDef configFc = {"FcConfig", 9, FcConfigArgs};
static void configFcCallFunc(const iocshArgBuf *args)
{
    FcConfig(args[0].sval, args[1].sval, args[2].ival, args[3].ival,
    		args[4].ival, args[5].ival, args[6].ival, args[7].ival, args[8].ival);
}


static void FcRegister(void)
{
    iocshRegister(&configFc, configFcCallFunc);
}

extern "C" {
epicsExportRegistrar(FcRegister);
}
