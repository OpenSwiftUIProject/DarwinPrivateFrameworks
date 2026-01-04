//
//  RBDevice.h
//  RenderBox

#pragma once

#include <RenderBox/RBBase.h>
#include <Foundation/Foundation.h>
#include <Metal/Metal.h>
#include <RenderBox/RBImageRenderer.h>
#include <dispatch/dispatch.h>

@protocol MTLCaptureScope, MTLDevice, OS_dispatch_queue;

RB_ASSUME_NONNULL_BEGIN

@interface RBDevice: NSObject <RBImageRenderer>

@property (readonly, nonatomic) id<MTLDevice> device;
@property (readonly, nonatomic) NSObject<OS_dispatch_queue> *queue;
@property (readonly, nonatomic, nullable) id<MTLCaptureScope> captureScope;
@property NSUInteger GPUPriority;
@property NSUInteger backgroundGPUPriority;

/* class methods */
+ (nullable instancetype)sharedDefaultDevice;
+ (NSArray<RBDevice *> *)allDevices;
+ (BOOL)isSupported;
+ (void)setAllowsRenderingInBackground:(BOOL)background;
+ (BOOL)allowsRenderingInBackground;
+ (NSUInteger)defaultBackgroundGPUPriority;
+ (NSUInteger)defaultGPUPriority;
+ (BOOL)isRunningInBackground;
+ (void)setDefaultBackgroundGPUPriority:(NSUInteger)gpupriority;
+ (void)setDefaultGPUPriority:(NSUInteger)gpupriority;
+ (nullable instancetype)sharedDevice:(id<MTLDevice>)device;
+ (nullable instancetype)sharedDeviceForDisplay:(unsigned int)display;

/* instance methods */
- (void)dealloc;
- (instancetype)initWithDevice:(id<MTLDevice>)device;
- (nullable CGImageRef)renderImageInRect:(CGRect)rect options:(nullable id)options renderer:(nullable id /* block */)renderer;
- (void)collectResources;
- (void)compileShader:(id)shader completionQueue:(nullable id)queue handler:(nullable id /* block */)handler;
- (BOOL)compileShader:(id)shader error:(id _Nullable * _Nullable)error;
- (nullable id)pipelineDescriptions:(nullable id)descriptions extraColorFormats:(nullable id)formats;
- (void)renderImageInRect:(CGRect)rect options:(nullable id)options renderer:(nullable id /* block */)renderer completionQueue:(nullable id)queue handler:(nullable id /* block */)handler;

@end

RB_ASSUME_NONNULL_END

