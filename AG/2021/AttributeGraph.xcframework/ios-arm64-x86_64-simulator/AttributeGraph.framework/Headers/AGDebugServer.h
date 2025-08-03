//
//  AGDebugServer.h
//  AttributeGraph
//
//  Audited for 6.5.1
//  Status: Complete

#ifndef AGDebugServer_h
#define AGDebugServer_h

#include <AttributeGraph/AGBase.h>

#if AG_TARGET_OS_DARWIN

AG_ASSUME_NONNULL_BEGIN

AG_IMPLICIT_BRIDGING_ENABLED

typedef struct AGDebugServerStorage *AGDebugServerRef AG_SWIFT_STRUCT AG_SWIFT_NAME(DebugServer);

typedef AG_OPTIONS(uint32_t, AGDebugServerMode) {
    AGDebugServerModeNone = 0,
    AGDebugServerModeValid = 1 << 0,
    AGDebugServerModeNetworkInterface = 1 << 1,
} AG_SWIFT_NAME(AGDebugServerRef.Mode);

// MARK: - Exported C functions

AG_EXTERN_C_BEGIN

AG_EXPORT
AGDebugServerRef _Nullable AGDebugServerStart(AGDebugServerMode mode) AG_SWIFT_NAME(AGDebugServerRef.start(mode:));

AG_EXPORT
void AGDebugServerStop(void) AG_SWIFT_NAME(AGDebugServerRef.stop());

AG_EXPORT
CFURLRef _Nullable AGDebugServerCopyURL(void) AG_SWIFT_NAME(AGDebugServerRef.copyURL());

AG_EXPORT
void AGDebugServerRun(int timeout) AG_SWIFT_NAME(AGDebugServerRef.run(timeout:));

AG_EXTERN_C_END

AG_IMPLICIT_BRIDGING_DISABLED

AG_ASSUME_NONNULL_END

#endif

#endif /* AGDebugServer_h */
