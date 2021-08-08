//
//  osd-util.h
//  MagicKeyboard
//
//  Created by Julian Groen on 16/07/2021.
//

#import <Foundation/Foundation.h>

typedef enum {
    OSDGraphicBacklight                              = 0x01,
    OSDGraphicSpeaker                                = 0x03,
    OSDGraphicSpeakerMuted                           = 0x04,
    OSDGraphicEject                                  = 0x06,
    OSDGraphicNoWiFi                                 = 0x09,
    OSDGraphicKeyboardBacklightMeter                 = 0x0B,
    OSDGraphicKeyboardBacklightDisabledMeter         = 0x0C,
    OSDGraphicKeyboardBacklightNotConnected          = 0x0D,
    OSDGraphicKeyboardBacklightDisabledNotConnected  = 0x0E,
    OSDGraphicMacProOpen                             = 0x0F,
    OSDGraphicHotspot                                = 0x13,
    OSDGraphicSleep                                  = 0x14,
} OSDGraphic;

typedef enum {
    OSDPriorityDefault = 0x1f4
} OSDPriority;

@interface OSDManager : NSObject
+ (instancetype) sharedManager;
- (void) showImage:(OSDGraphic)image onDisplayID:(CGDirectDisplayID)display priority:(OSDPriority)priority msecUntilFade:(int)timeout;
- (void) showImage:(OSDGraphic)image onDisplayID:(CGDirectDisplayID)display priority:(OSDPriority)priority msecUntilFade:(int)timeout filledChiclets:(int)filled totalChiclets:(int)total locked:(BOOL)locked;
- (void) showImage:(OSDGraphic)image onDisplayID:(CGDirectDisplayID)display priority:(OSDPriority)priority msecUntilFade:(int)timeout withText:(NSString *)text;
@end

@interface OSDUtil : NSObject
@property (class, readonly) OSDManager * shared;
@end
