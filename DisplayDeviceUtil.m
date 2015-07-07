#import "DisplayDeviceUtil.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "RCTUtils.h"

@implementation DisplayDeviceUtil

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

- (instancetype)init {
  if ((self = [super init])) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
  }
  
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)displayOrientationDidChange:(NSNotification*)note {
  static NSDictionary *dimensions;
  
  CGSize frameSize = [UIScreen mainScreen].applicationFrame.size;
  
  /* For Non-Orientation Dependant Versions */
  if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)
      && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
    frameSize = CGSizeMake(frameSize.height, frameSize.width);
  }
  
  dimensions = @{ @"width": @(frameSize.width), @"height": @(frameSize.height) };
  
  [_bridge.eventDispatcher sendDeviceEventWithName:@"orientationDidChange" body:dimensions];
}

@end
