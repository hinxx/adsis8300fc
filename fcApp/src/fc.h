/* fc.h
 *
 * This is a driver for a FC based on Struck SIS8300 digitizer.
 *
 * Author: Hinko Kocevar
 *         ESS ERIC, Lund, Sweden
 *
 * Created:  January 22, 2017
 *
 */

#include <stdint.h>
#include <epicsEvent.h>
#include <epicsTime.h>
#include <asynNDArrayDriver.h>

#include <sis8300drv.h>

class epicsShareClass Fc : public SIS8300 {
public:
	Fc(const char *portName, const char *devicePath,
			int maxAddr, int numTimePoints, NDDataType_t dataType,
			int maxBuffers, size_t maxMemory, int priority, int stackSize);
	virtual ~Fc();

    /* These are the methods that we override from asynNDArrayDriver */
    virtual void report(FILE *fp, int details);

protected:
	int mFcDummy;
	#define FC_FIRST_PARAM mFcDummy
	#define FC_LAST_PARAM mFcDummy

private:
};
