//
//  SystemGraphics.h
//  MagicKeyboard
//
//  Created by Julian Groen on 13/07/2021.
//

#import <Foundation/Foundation.h>

#ifndef SystemGraphics_h
#define SystemGraphics_h

typedef enum {
    OSDGraphicBacklight                              = 1,
    OSDGraphicSpeaker                                = 3,
    OSDGraphicSpeakerMuted                           = 4,
    OSDGraphicEject                                  = 6,
    OSDGraphicNoWiFi                                 = 9,
    OSDGraphicKeyboardBacklightMeter                 = 11,
    OSDGraphicKeyboardBacklightDisabledMeter         = 12,
    OSDGraphicKeyboardBacklightNotConnected          = 13,
    OSDGraphicKeyboardBacklightDisabledNotConnected  = 14,
    OSDGraphicMacProOpen                             = 15,
    OSDGraphicHotspot                                = 19,
    OSDGraphicSleep                                  = 20,
} OSDGraphic;

typedef enum {
    OSDPriorityDefault = 0x1f4
} OSDPriority;

@interface OSDManager : NSObject
+ (instancetype) sharedManager;
- (void) showImage:(OSDGraphic)image onDisplayID:(CGDirectDisplayID)display priority:(OSDPriority)priority msecUntilFade:(int)timeout;
- (void) showImage:(OSDGraphic)image onDisplayID:(CGDirectDisplayID)display priority:(OSDPriority)priority msecUntilFade:(int)timeout withText:(NSString *)text;
- (void) showImage:(OSDGraphic)image onDisplayID:(CGDirectDisplayID)display priority:(OSDPriority)priority msecUntilFade:(int)timeout filledChiclets:(int)filled totalChiclets:(int)total locked:(BOOL)locked;
@end

@interface SystemGraphics : NSObject
@property (class, readonly) OSDManager * shared;
@end

#endif /* SystemGraphics_h */
