//
//  MacANEJoystickController.h
//  MacJoystickANE
//
//  Created by John Stringham on 12-05-01.
//  Copyright 2012 We Get Signal. All rights reserved.
//

#import "JoystickManager.h"
#import "Joystick.h"
#import "FlashRuntimeExtensions.h"

@interface MacANEJoystickController : NSObject <JoystickNotificationDelegate> {
@private
    JoystickManager *theJoystickManager;
    
}
- (id)initWithContext:(FREContext *)ctx;
- (int)joysticksConnected;

@end
