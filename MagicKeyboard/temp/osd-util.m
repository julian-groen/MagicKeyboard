//
//  osd-util.m
//  MagicKeyboard
//
//  Created by Julian Groen on 16/07/2021.
//

#import "osd-util.h"

static OSDManager *_instance = nil;

@implementation OSDUtil
+ (OSDManager *) shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/OSD.framework"];
        if ([bundle load]) {
            _instance = [NSClassFromString(@"OSDManager") valueForKey:@"sharedManager"];
        }
    });
    return _instance;
}
@end
