//
//  MacJoystickManager
//#import <Foundation/Foundation.h>
#include "FlashRuntimeExtensions.h"
//#import <UIKit/UIKit.h>
#include "MacANEJoystickController.h"

MacANEJoystickController *theJoystickController;


FREObject initializeGamepads(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    theJoystickController = [[MacANEJoystickController alloc] initWithContext:ctx];
    
    NSString *eventCode = @"blahcode";
    NSString *eventLevel = @"blahlevel";
    
    FREDispatchStatusEventAsync(ctx, (uint8_t*)[eventCode UTF8String], (uint8_t*)[eventLevel UTF8String]);
    
    return NULL;
}


FREObject numJoysticksConnected(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    FREObject result;
    int numJoysticks = [theJoystickController joysticksConnected];
    
    FRENewObjectFromInt32(numJoysticks, &result);
    
    return result;
}

//------------------------------------
//
// Required Methods.
//
//------------------------------------

// ContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.
void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
						uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) 
{
    
	*numFunctionsToTest = 2;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * 2);
	func[0].name = (const uint8_t*) "initializeGamepads";
	func[0].functionData = NULL;
    func[0].function = &initializeGamepads;
    
	func[1].name = (const uint8_t*) "numJoysticksConnected";
	func[1].functionData = NULL;
    func[1].function = &numJoysticksConnected;
    
	*functionsToSet = func;
}

// ContextFinalizer()
//
// The context finalizer is called when the extension's ActionScript code
// calls the ExtensionContext instance's dispose() method.
// If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls
// ContextFinalizer().

void ContextFinalizer(FREContext ctx) {
    
    NSLog(@"Entering ContextFinalizer()");
    
    // Nothing to clean up.
    
    NSLog(@"Exiting ContextFinalizer()");
    
	return;
}

void ExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
                    FREContextFinalizer* ctxFinalizerToSet) {
    
    NSLog(@"Entering ExtInitializer()");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &ContextInitializer;
    *ctxFinalizerToSet = &ContextFinalizer;
    
    NSLog(@"Exiting ExtInitializer()");
}

// ExtFinalizer()
//
// The extension finalizer is called when the runtime unloads the extension. However, it is not always called.

void ExtFinalizer(void* extData) {
    
    NSLog(@"Entering ExtFinalizer()");
    
    // Nothing to clean up.
    
    NSLog(@"Exiting ExtFinalizer()");
    return;
}