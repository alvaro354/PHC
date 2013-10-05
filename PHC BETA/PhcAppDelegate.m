//
//  PhcAppDelegate.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 04/01/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "PhcAppDelegate.h"

@implementation PhcAppDelegate
@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry startSession:@"N55J4NXHT6NYDMNF2B3W"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
   
    navigationController.delegate = self;
   //  self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.17 green:0.522 blue:0.725 alpha:1];
    window.tintColor = [UIColor whiteColor];
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
   
    return YES;
}

- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
 
    if ([viewController respondsToSelector:@selector(willAppearIn:)])
        [viewController performSelector:@selector(willAppearIn:) withObject:navController];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	
    NSString *string = [NSString stringWithFormat:@"%@",deviceToken];
       string= [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string= [string stringByReplacingOccurrencesOfString:@"<" withString:@""];
    string= [string stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"PushToken"];
    
    NSLog(@"My token is: %@", string);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}


-(void)internet{
    
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    
    if (networkStatus == NotReachable) {
       // NSLog(@"There IS NO internet connection");
        internet=YES;
       
           timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(alert) userInfo:nil repeats:YES];
        
    } else {
        internet=NO;
        timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(alert) userInfo:nil repeats:YES];
      //  NSLog(@"There IS internet connection");
        
        
    }

}

-(void)alert{
    dispatch_async(dispatch_get_main_queue(), ^{
    
    if (internet == YES && alert ==nil) {
        alert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Esperando la red"
                                          delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
    }
    if (internet ==YES && alert != nil) {
       timer2= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(internet) userInfo:nil repeats:YES];
    }
    if (internet == NO) {
        NSLog(@"Quitar Notificacion");

        [timer invalidate];
        [timer2 invalidate];
        [alert removeFromSuperview];
    }
    });
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
