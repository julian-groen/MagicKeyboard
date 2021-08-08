//
//  SystemGraphics.m
//  MagicKeyboard
//
//  Created by Julian Groen on 13/07/2021.
//

#import "SystemGraphics.h"

static OSDManager *_instance = nil;

@implementation SystemGraphics
+ (OSDManager*) shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/OSD.framework"];
        if (![bundle load]) {
            NSLog(@"Error couldn't load OSDManager");
        } else {
            _instance = [NSClassFromString(@"OSDManager") valueForKey:@"sharedManager"];
        }
    });
    return _instance;
}
@end
