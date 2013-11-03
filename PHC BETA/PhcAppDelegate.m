//
//  PhcAppDelegate.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 04/01/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "PhcAppDelegate.h"
#include <math.h>

@implementation PhcAppDelegate
@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   /*
       CLLocation *location1 = [[CLLocation alloc] initWithLatitude:120.001 longitude:40.0];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:120.0 longitude:40.0 ];
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    
   
        NSLog(@"Distancia: %f",distance);
    
    */
    
    NSMutableArray * array= [[NSMutableArray alloc]init];
    NSData *datos = [[NSUserDefaults standardUserDefaults] objectForKey:@"Localizaciones"];
    if (datos!= NULL) {
        array = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
    }
    
   /* NSMutableArray * array2= [[NSMutableArray alloc]init];
    NSData *datos2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"Frecuentes"];
    if (datos2!= NULL) {
        array2 = [NSKeyedUnarchiver unarchiveObjectWithData:datos2];
    }
    */
  // NSLog(@"Numero Datos: %d" ,[datos length]);
     NSLog(@"Numero Localizaciones: %d" ,[array count]);
    //NSLog(@"Numero Frecuentes: %d" ,[array2 count]);
      NSLog(@"Localizaciones" );
    for (Localizacion * lz in array) {
        
        NSLog(@"Localizacion: %f %f Lugar : %@ " ,lz.longitude,lz.latitude,lz.Lugar);
   
        
    }
    /* NSLog(@"Localizacion Frecuentes" );
    for (Localizacion * lz in array2) {
       
        NSLog(@"Localizacion: %f %f Lugar : %@ Tiemp: %f" ,lz.longitude,lz.latitude,lz.Lugar,lz.tiempo);
        
        
    }*/
    
    
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
     [locationManager startMonitoringSignificantLocationChanges];
     [locationManager stopMonitoringSignificantLocationChanges];
  
    
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
    
    [locationManager stopMonitoringSignificantLocationChanges];
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
     [locationManager startMonitoringSignificantLocationChanges];
   }

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }
    
    anadir =YES;
    NSMutableArray * array= [[NSMutableArray alloc]init];
    NSData *datos = [[NSUserDefaults standardUserDefaults] objectForKey:@"Localizaciones"];
    if (datos!= NULL) {
    array = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
    }
    
 //   NSLog(@"Numero Datos: %d" ,[datos length]);
    NSLog(@"Numero Localizaciones: %d" ,[array count]);
    
    NSMutableArray * array2= [[NSMutableArray alloc]init];
    NSData *datos2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"Frecuentes"];
    if (datos2!= NULL) {
        array2 = [NSKeyedUnarchiver unarchiveObjectWithData:datos2];
    }
  CLGeocoder*  geocoder = [[CLGeocoder alloc] init];
    

    
    Localizacion*l2 =[[Localizacion alloc]init];
    l2.latitude=newLocation.coordinate.latitude;
    l2.longitude=newLocation.coordinate.longitude;
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             l2.Lugar =placemark.name;
             
         }
     }];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSHourCalendarUnit + NSMinuteCalendarUnit fromDate:now];
    
    l2.hora= comps;
    
    
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:oldLocation.coordinate.latitude longitude:oldLocation.coordinate.longitude];
    for (int i =0 ; i < [array count] ; i ++) {
      //  NSLog(@"Localizacion: %@ %@ Lugar : %@ Hora: %@" ,lz.longitude,lz.latitude,lz.Lugar,lz.hora);
 
        Localizacion * lz = [array objectAtIndex:i];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:lz.latitude longitude:lz.longitude ];
        CLLocationDistance distance = [location1 distanceFromLocation:location2];
        
        if ((0< distance && distance < 300.0) || (lz.latitude ==l2.latitude && lz.longitude==l2.longitude)) {
             anadir=NO;
             NSLog(@"Distancia: %f",distance);
             NSLog(@"Tiempo: %f",lz.tiempo);
            NSLog(@"Lugar Repetido");
            Localizacion*l3 =[[Localizacion alloc]init];
            l3.latitude=lz.latitude;
            l3.longitude=lz.longitude;
            l3.Lugar=lz.Lugar;
            l3.hora=comps;
            float tiempo = abs(l3.hora.hour-lz.hora.hour)+ (abs(l3.hora.minute-lz.hora.minute)/60)+ 0.01*abs(l3.hora.minute-lz.hora.minute);
            l3.tiempo=tiempo;
            
            [array replaceObjectAtIndex:i withObject:l3];
            break;
           /* if ([array2 containsObject:lz]) {
           NSLog(@"Lo Contiene");
            [array2 replaceObjectAtIndex:[array2 indexOfObjectIdenticalTo:lz] withObject:l2];
            }
            else{
                
                NSLog(@"Nuevo Ubicacion Frecuente");
                [array2 addObject:lz];
            }*/
            
            
            
        }
        if (i== [array count]-1 && anadir== YES) {
            NSLog(@"Nueva Localizacion");
            [array addObject:l2];
            break;
        
        }
      
        
    }
    
    if ([array count]==0) {
        NSLog(@"Nueva Localizacion 0");
        [array addObject:l2];
    }
    
 



    NSData *datos3 = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:datos3 forKey:@"Localizaciones"];
    NSData *datos4 = [NSKeyedArchiver archivedDataWithRootObject:array2];
    [[NSUserDefaults standardUserDefaults] setObject:datos4 forKey:@"Frecuentes"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    // Handle location updates as normal, code omitted for brevity.
    // The omitted code should determine whether to reject the location update for being too
    // old, too close to the previous one, too inaccurate and so forth according to your own
    // application design.
   
    
}

@end
