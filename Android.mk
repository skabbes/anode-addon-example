# Set up the following environment variables
# NODE_ROOT: location of the node root directory (for include files)
# ANODE_ROOT: location of the anode root directory (for the libjninode binary)
ANODE_ROOT := /Users/steven/projects/android-hack/skabbes-anode
NODE_ROOT := $(ANODE_ROOT)/../node

# =============================================
# STEP 1 - buliding sqlite3 as a shared library
# =============================================

# Variable definitions for Android applications
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

# Modify this line to configure to the module name.
LOCAL_MODULE := sqlite3
LOCAL_SRC_FILES :=  deps/sqlite3.c

# The STL implementation we chose earlier
LOCAL_SHARED_LIBRARIES := gnustl_shared

# looked up build flags from the wscript file
LOCAL_CFLAGS := -DSQLITE_ENABLE_RTREE=1 -fPIC -O3 -DNDEBUG

include $(BUILD_SHARED_LIBRARY)

# =============================================
# STEP 2 - building the sqlite3 node bindings
# =============================================

include $(CLEAR_VARS)
LOCAL_CPP_EXTENSION :=.cc

LOCAL_MODULE := sqlite3_bindings

# Add any additional defines or compiler flags.
# Do not delete these existing flags as these are required
# for the included node header files.
LOCAL_CFLAGS := \
	-D__POSIX__ \
	-DBUILDING_NODE_EXTENSION \
	-include sys/select.h

# grabbed these compiler flags out of the wscript file for node-sqlite3
LOCAL_CPPFLAGS := -g -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -DSQLITE_ENABLE_RTREE=1 -pthread -Wall

# Add any additional required directories for the include path.
# Do not delete these existing directories as these are required
# for the included node header files.
LOCAL_C_INCLUDES := $(NODE_ROOT)/src \
	./deps \
	$(NODE_ROOT)/deps/v8/include \
	$(NODE_ROOT)/deps/uv/include

# Add any additional required shared libraries that the addon depends on.
LOCAL_LDLIBS := \
	$(ANODE_ROOT)/libs/armeabi/libjninode.so

LOCAL_SRC_FILES :=\
	src/database.cc \
	src/sqlite3.cc \
	src/statement.cc

# say that this node addon depends on the sqlite3 shared library
LOCAL_SHARED_LIBRARIES := sqlite3

# Do not edit this line.
include $(ANODE_ROOT)/sdk/addon/build-node-addon.mk
