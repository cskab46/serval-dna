# Included by top-level Android.mk

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
include $(LOCAL_PATH)/sourcefiles.mk
SERVALD_SRC_FILES = \
    $(SQLITE3_SOURCES) \
    $(SERVAL_CLIENT_SOURCES) \
    $(MDP_CLIENT_SOURCES) \
    $(SERVAL_DAEMON_SOURCES) \
    $(ANDROIDONLY_SOURCES)
NACL_BASE = nacl/src
NACL_INC := $(LOCAL_PATH)/nacl/include
include $(LOCAL_PATH)/$(NACL_BASE)/nacl.mk
SQLITE3_INC := $(LOCAL_PATH)/sqlite-amalgamation-3070900

SERVALD_LOCAL_CFLAGS = \
	-g \
	-Wall -Wno-unused-variable -Wno-unused-value -Werror \
        -DSERVALD_VERSION="\"Android\"" -DSERVALD_COPYRIGHT="\"Android\"" \
        -DINSTANCE_PATH="\"/data/data/org.servalproject/var/serval-node\"" \
        -DSHELL -DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\" \
        -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\" -DPACKAGE_URL=\"\" \
	-DHAVE_FUNC_ATTRIBUTE_ERROR=1 \
        -DHAVE_FUNC_ATTRIBUTE_ALIGNED=1 -DHAVE_VAR_ATTRIBUTE_SECTION=1 -DHAVE_FUNC_ATTRIBUTE_USED=1 \
	-DHAVE_FUNC_ATTRIBUTE_ALLOC_SIZE=1 -DHAVE_FUNC_ATTRIBUTE_MALLOC=1 \
	-DHAVE_FUNC_ATTRIBUTE_FORMAT=1 \
	-DHAVE_FUNC_ATTRIBUTE_USED=1 -DHAVE_FUNC_ATTRIBUTE_UNUSED=1 \
        -DHAVE_LIBC=1 -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 \
        -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 \
        -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_STDIO_H=1 \
        -DHAVE_ERRNO_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRINGS_H=1 -DHAVE_UNISTD_H=1 \
        -DHAVE_STRING_H=1 -DHAVE_ARPA_INET_H=1 -DHAVE_SYS_SOCKET_H=1 \
        -DHAVE_SYS_MMAN_H=1 -DHAVE_SYS_TIME_H=1 -DHAVE_POLL_H=1 -DHAVE_NETDB_H=1 \
	-DHAVE_JNI_H=1 -DHAVE_STRUCT_UCRED=1 -DHAVE_CRYPTO_SIGN_NACL_GE25519_H=1 \
        -DBYTE_ORDER=_BYTE_ORDER -DHAVE_LINUX_STRUCT_UCRED -DUSE_ABSTRACT_NAMESPACE \
        -DHAVE_BCOPY -DHAVE_BZERO -DHAVE_NETINET_IN_H -DHAVE_LSEEK64 -DSIZEOF_OFF_T=4 \
        -DHAVE_LINUX_IF_H -DHAVE_SYS_STAT_H -DHAVE_SYS_VFS_H -DHAVE_LINUX_NETLINK_H -DHAVE_LINUX_RTNETLINK_H \
	-DSQLITE_OMIT_DATETIME_FUNCS -DSQLITE_OMIT_COMPILEOPTION_DIAGS -DSQLITE_OMIT_DEPRECATED \
	-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_OMIT_VIRTUALTABLE -DSQLITE_OMIT_AUTHORIZATION \
	-I$(NACL_INC) \
	-I$(SQLITE3_INC)

SERVALD_LOCAL_LDLIBS = -L$(SYSROOT)/usr/lib -llog 

# Build libserval.so
include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(NACL_SOURCES) $(SERVALD_SRC_FILES) version_servald.c android.c
LOCAL_CFLAGS += $(SERVALD_LOCAL_CFLAGS)
LOCAL_LDLIBS := $(SERVALD_LOCAL_LDLIBS)
LOCAL_MODULE := serval
include $(BUILD_SHARED_LIBRARY)

ifdef SERVALD_WRAP
  include $(CLEAR_VARS)
  LOCAL_SRC_FILES:= servalwrap.c
  LOCAL_MODULE:= servald
  LOCAL_CFLAGS += -fPIE
  LOCAL_LDFLAGS += -fPIE -pie
  include $(BUILD_EXECUTABLE)
endif

# Build servald for use with gdb
ifdef SERVALD_SIMPLE
  include $(CLEAR_VARS)
  LOCAL_SRC_FILES:= $(NACL_SOURCES) $(SERVALD_SRC_FILES) version_servald.c
  LOCAL_CFLAGS += $(SERVALD_LOCAL_CFLAGS)
  LOCAL_LDLIBS := $(SERVALD_LOCAL_LDLIBS)
  LOCAL_STATIC_LIBRARIES := $(SERVALD_LOCAL_STATIC_LIBRARIES)
  LOCAL_MODULE:= servaldsimple
  LOCAL_CFLAGS += -fPIE
  LOCAL_LDFLAGS += -fPIE -pie
  include $(BUILD_EXECUTABLE)
endif
