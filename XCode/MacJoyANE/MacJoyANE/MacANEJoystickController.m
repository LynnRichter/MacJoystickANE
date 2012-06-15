//
//  MacANEJoystickController.m
//  MacJoystickANE
//
//  Created by JP Stringham on 12-05-01.
//  Copyright 2012 We Get Signal. All rights reserved.
//

// A shitty liason between the JoystickManager (knows nothing of FRE)
// and FlashRuntimeExtensions

// Whatever you don't love me like you said you did
// that night
// it was all passion
// fleeting
// and inevitable
//





//


// but fruitless

#import "MacANEJoystickController.h"

@implementation MacANEJoystickController

FREContext *context;

- (id)initWithContext:(FREContext *)ctx
{
    self = [super init];
    if (self) {
        context = ctx;
        
        theJoystickManager = [JoystickManager sharedInstance];
        [theJoystickManager setJoystickAddedDelegate:self];
        
    }
    
    return self;
}

- (int)joysticksConnected {
    return [theJoystickManager connectedJoysticks];
}

- (void)joystickAdded:(Joystick *)joystick {
    [joystick registerForNotications:self];
    
    NSString *eventCode = @"JOYSTICK_ADDED";
    NSString *eventLevel = [NSString stringWithFormat:@"%d,%d,%d",[theJoystickManager deviceIDByReference:[joystick device]],[joystick numAxes],[joystick numButtons]+[joystick numHats]*4];
    
    FREDispatchStatusEventAsync(context, (uint8_t*)[eventCode UTF8String], (uint8_t*)[eventLevel UTF8String]);
}

- (void)joystickRemoved:(int)joystickID {
    NSString *eventCode = @"JOYSTICK_REMOVED";
    NSString *eventLevel = [NSString stringWithFormat:@"%d",joystickID];
    
    FREDispatchStatusEventAsync(context, (uint8_t*)[eventCode UTF8String], (uint8_t*)[eventLevel UTF8String]);
}

- (void)joystickButtonPushed:(int)buttonIndex onJoystick:(Joystick *)joystick {
    NSString *eventCode = @"JOYSTICK_BUTTON_PUSHED";
    NSString *eventLevel = [NSString stringWithFormat:@"%d,%d",[theJoystickManager deviceIDByReference:[joystick device]],buttonIndex];
    
    FREDispatchStatusEventAsync(context, (uint8_t*)[eventCode UTF8String], (uint8_t*)[eventLevel UTF8String]);
}

- (void)joystickButtonReleased:(int)buttonIndex onJoystick:(Joystick *)joystick {
    NSString *eventCode = @"JOYSTICK_BUTTON_RELEASED";
    NSString *eventLevel = [NSString stringWithFormat:@"%d,%d",[theJoystickManager deviceIDByReference:[joystick device]],buttonIndex];
    
    FREDispatchStatusEventAsync(context, (uint8_t*)[eventCode UTF8String], (uint8_t*)[eventLevel UTF8String]);
}

- (void)joystickStateChanged:(Joystick *)joystick {
    NSString *eventCode = @"JOYSTICK_AXES_UPDATED";
    NSString *eventLevel;
    
    eventLevel = [NSString stringWithFormat:@"%d",[theJoystickManager deviceIDByReference:[joystick device]]];
    int i;
    
    for (i=0; i<[joystick numAxes]; ++i) {
        eventLevel = [NSString stringWithFormat:@"%@,%f",eventLevel,[joystick getRelativeValueOfAxesIndex:i]];
    }
    
    FREDispatchStatusEventAsync(context, (uint8_t*)[eventCode UTF8String], (uint8_t*)[eventLevel UTF8String]);
}

- (void)dealloc
{
    [super dealloc];
}

@end


// call me