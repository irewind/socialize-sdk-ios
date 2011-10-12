
//
//  SampleSdkAppAppDelegate.m
//  SampleSdkApp
//
//  Created by Sergey Popenko on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SampleSdkAppAppDelegate.h"
#import <Socialize/Socialize.h>
#import "TestListController.h"
#include <AvailabilityMacros.h>

#if RUN_GHUNIT_TESTS
#import <GHUnitIOS/GHUnit.h>
#endif

#if RUN_KIF_TESTS
#import "SampleSdkAppKIFTestController.h"
#endif

//#import "SocializeLike.h"

@implementation SampleSdkAppAppDelegate


@synthesize window=_window, rootController;

+ (id)sharedDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{  
    UIViewController* rootViewController = nil;
    
    _socialize = [[Socialize alloc] initWithDelegate:self];
    
    // we check the authentication here.
    rootViewController = [[[AuthenticateViewController alloc] initWithNibName:@"AuthenticateViewController" bundle:nil] autorelease];
 
    rootController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self.window addSubview:rootController.view];
    [self.window makeKeyAndVisible];
    
#if RUN_GHUNIT_TESTS
    int retVal = [GHTestRunner run];
    printf("return value from test runner is: %d\n", retVal);
    NSAssert1(retVal == 0, @"There were %i failures during logic integration tests.", retVal);
#endif
#if RUN_KIF_TESTS
    [[SampleSdkAppKIFTestController sharedInstance] startTestingWithCompletionBlock:^{
        // Exit after the tests complete so that CI knows we're done
        int failureCount = [[SampleSdkAppKIFTestController sharedInstance] failureCount];
        NSLog(@"failure count %i", failureCount);
        if( getenv("KIF_CLI") ) {
            exit(failureCount);
        }
    }];
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
//    AuthenticateViewController* auth = [rootController.viewControllers objectAtIndex:0];
//    return [auth.socialize.authService handleOpenURL: url];
    return [Socialize handleOpenURL:url];
}

- (void)dealloc
{
    [rootController  release];
    [_window release];
    [super dealloc];
}

@end