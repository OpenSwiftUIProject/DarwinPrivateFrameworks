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

/**
 * @header AGDebugServer.h
 * @abstract AttributeGraph Debug Server API for runtime debugging and inspection.
 * @discussion The debug server provides runtime debugging capabilities for AttributeGraph applications,
 * allowing external tools to connect and inspect graph state, dependencies, and execution.
 * This API is only available on Darwin platforms and requires network interface access
 * when used in network mode.
 */

AG_ASSUME_NONNULL_BEGIN

AG_IMPLICIT_BRIDGING_ENABLED

/**
 * @typedef AGDebugServerRef
 * @abstract An opaque reference to a debug server instance.
 * @discussion The debug server manages a connection endpoint that external debugging tools
 * can use to inspect AttributeGraph runtime state. Only one debug server instance
 * can be active at a time.
 */
typedef struct AGDebugServerStorage *AGDebugServerRef AG_SWIFT_STRUCT AG_SWIFT_NAME(DebugServer);

/**
 * @typedef AGDebugServerMode
 * @abstract Configuration modes for the debug server.
 * @discussion These flags control how the debug server operates and what interfaces it exposes.
 * Multiple modes can be combined using bitwise OR operations.
 */
typedef AG_OPTIONS(uint32_t, AGDebugServerMode) {
    /**
     * @abstract No debug server functionality.
     * @discussion Use this mode to disable all debug server operations.
     */
    AGDebugServerModeNone = 0,
    
    /**
     * @abstract Enable basic debug server validation and setup.
     * @discussion This mode enables the debug server with minimal functionality and is required 
     * for any debug server operation. All other modes must be combined with this flag.
     */
    AGDebugServerModeValid = 1 << 0,
    
    /**
     * @abstract Enable network interface for remote debugging.
     * @discussion When enabled, the debug server will listen on a network interface, allowing 
     * remote debugging tools to connect. Requires AGDebugServerModeValid to be set.
     */
    AGDebugServerModeNetworkInterface = 1 << 1,
} AG_SWIFT_NAME(AGDebugServerRef.Mode);

// MARK: - Exported C functions

AG_EXTERN_C_BEGIN

/**
 * @function AGDebugServerStart
 * @abstract Starts the shared debug server with the specified mode.
 * @discussion Creates and starts a new shared debug server instance. If a server is already
 * running, this function will return the existing instance.
 * 
 * The returned reference should not be manually managed. Use AGDebugServerStop()
 * to properly shut down the shared server.
 * @param mode Configuration flags controlling server behavior.
 *             Must include AGDebugServerModeValid for basic operation.
 * @result A reference to the started shared debug server, or NULL if the server
 *         could not be started (e.g., due to network permissions, conflicts, or existing server).
 */
AG_EXPORT
AG_REFINED_FOR_SWIFT
AGDebugServerRef _Nullable AGDebugServerStart(AGDebugServerMode mode) AG_SWIFT_NAME(AGDebugServerRef.start(mode:));

/**
 * @function AGDebugServerStop
 * @abstract Stops and deletes the running shared debug server.
 * @discussion Shuts down the active shared debug server instance and cleans up all associated
 * resources. If no shared debug server is currently running, this function has no effect.
 * 
 * This function should be called before application termination to ensure
 * proper cleanup of network resources and connections.
 */
AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGDebugServerStop(void) AG_SWIFT_NAME(AGDebugServerRef.stop());

/**
 * @function AGDebugServerCopyURL
 * @abstract Returns the URL for connecting to the shared debug server.
 * @discussion Returns the URL that external debugging tools should use to connect to
 * the currently running shared debug server. The URL format depends on the server
 * configuration and may be a local or network address.
 * 
 * The returned URL is only valid while the shared debug server is running.
 * It may change if the server is restarted.
 * @result A CFURLRef containing the connection URL, or NULL if no shared debug server
 *         is currently running or if the server doesn't expose a connectable interface.
 *         The caller is responsible for releasing the returned URL.
 */
AG_EXPORT
AG_REFINED_FOR_SWIFT
CFURLRef _Nullable AGDebugServerCopyURL(void) AG_SWIFT_NAME(AGDebugServerRef.copyURL());

/**
 * @function AGDebugServerRun
 * @abstract Runs the shared debug server event loop.
 */
AG_EXPORT
AG_REFINED_FOR_SWIFT
void AGDebugServerRun(int timeout) AG_SWIFT_NAME(AGDebugServerRef.run(timeout:));

AG_EXTERN_C_END

AG_IMPLICIT_BRIDGING_DISABLED

AG_ASSUME_NONNULL_END

#endif

#endif /* AGDebugServer_h */
