//
//  PhcAppDelegate.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 04/01/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "PhcAppDelegate.h"
#include <math.h>
#import "Dia.h"

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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *now = [NSDate date];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ;
    [dateFormatter setDateFormat:@"EEEE"];
    NSLog(@"Day Name : %@", [dateFormatter stringFromDate:now]);
 
    if (datos== NULL) {
        Dia * day = [[Dia alloc]init];
        day.DiaSemana=@"Monday";
        [array addObject:day];
        Dia * day2 = [[Dia alloc]init];
      
        day2.DiaSemana=@"Tuesday";
        [array addObject:day2];
        Dia * day3 = [[Dia alloc]init];
    
        day3.DiaSemana=@"Wednesday";
        [array addObject:day3];
        Dia * day4 = [[Dia alloc]init];
       
        day4.DiaSemana=@"Thursday";
        [array addObject:day4];
        Dia * day5 = [[Dia alloc]init];
      
        day5.DiaSemana=@"Friday";
        [array addObject:day5];
        Dia * day6 = [[Dia alloc]init];
        
        day6.DiaSemana=@"Saturday";
        [array addObject:day6];
        Dia * day7 = [[Dia alloc]init];
      
        day7.DiaSemana=@"Sunday";
        [array addObject:day7];
        NSData *datos3 = [NSKeyedArchiver archivedDataWithRootObject:array];
        [[NSUserDefaults standardUserDefaults] setObject:datos3 forKey:@"Localizaciones"];
        
        
    }

    if (datos!= NULL) {
        array = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
    }
    
    
    for (int i =0; i <[array count];i++) {
        Dia * day = [array objectAtIndex:i];
        for (int d =0; d<24;d++) {
            NSMutableArray * hora =[day.Horas objectAtIndex:d];
            for (Localizacion *lz in hora ) {
             NSLog(@"Dia: %@ Localizacion: %f %f Lugar : %@  Hora: %d Tiempo: %f" ,day.DiaSemana,lz.latitude,lz.longitude,lz.Lugar,d,lz.tiempo);
        }
        }
        
    }
   /* NSMutableArray * array2= [[NSMutableArray alloc]init];
    NSData *datos2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"Frecuentes"];
    if (datos2!= NULL) {
        array2 = [NSKeyedUnarchiver unarchiveObjectWithData:datos2];
    }
    */
  // NSLog(@"Numero Datos: %d" ,[datos length]);
   /*  NSLog(@"Numero Localizaciones: %d" ,[array count]);
    //NSLog(@"Numero Frecuentes: %d" ,[array2 count]);
      NSLog(@"Localizaciones" );
    for (Localizacion * lz in array) {
        
        NSLog(@"Localizacion: %f %f Lugar : %@  Hora: %ld Tiempo: %f" ,lz.latitude,lz.longitude,lz.Lugar,(long)lz.hora.hour,lz.tiempo);
   
        
    }
     NSLog(@"Localizacion Frecuentes" );
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
    NSLog(@"Nueva Ubicacion");
   
    CLLocationDistance distance = [newLocation distanceFromLocation:oldLocation];
      NSLog(@"Distancia de Separacion: %f",distance );
    //Comprobar que la distancia es superior a 200
    if (distance > 200) {

    
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }
    
    anadir =YES;
    
    
    CLGeocoder*  geocoder = [[CLGeocoder alloc] init];
    NSMutableArray * arrayDias= [[NSMutableArray alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ;
    NSDate *now = [NSDate date];
    [dateFormatter setDateFormat:@"EEEE"];
    [dateFormatter stringFromDate:now];
    
 
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSHourCalendarUnit + NSMinuteCalendarUnit fromDate:now];
    
    NSData *datos = [[NSUserDefaults standardUserDefaults] objectForKey:@"Localizaciones"];
        
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * dataTemp = [userDefaults objectForKey:@"Temporal"];
        
        arrayDias = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
   //NSLog(@"Data Temp Length: %d" ,[dataTemp length]);
	//[userDefaults setObject:myObject forKey:@"Temporal"];
    
    if (datos!= NULL) {
    
        if (dataTemp == NULL) {
             NSLog(@"Generado Temporal 1º");
            Localizacion * lTemporalGuardar=[[Localizacion alloc]init];
            lTemporalGuardar.latitude=newLocation.coordinate.latitude;
            lTemporalGuardar.longitude=newLocation.coordinate.longitude;
            lTemporalGuardar.hora=comps;
            
            [geocoder reverseGeocodeLocation:newLocation completionHandler:
             ^(NSArray* placemarks, NSError* error){
                 if ([placemarks count] > 0)
                 {
                     CLPlacemark *placemark = [placemarks objectAtIndex:0];
                     lTemporalGuardar.Lugar =placemark.name;
                     
                 }
             }];
            NSData *dataT = [NSKeyedArchiver archivedDataWithRootObject:lTemporalGuardar];
            
           [userDefaults setObject:dataT forKey:@"Temporal"];
        }
        else{
 
    Localizacion * lTemporal =  [NSKeyedUnarchiver unarchiveObjectWithData:dataTemp];
            float tiempo= abs(comps.hour-lTemporal.hora.hour)+ (abs(comps.minute-lTemporal.hora.minute)/60)+ 0.01*abs(comps.minute-lTemporal.hora.minute);
             NSLog(@"Tiempo: %.2f Horas.Minutos" ,tiempo);
            if (tiempo>0.10) {
                
                //Falta Añadir A el Dia
                [dateFormatter setDateFormat:@"EEEE"];
               
                for (int i =0; i <[arrayDias count];i++) {
                    Dia * day = [arrayDias objectAtIndex:i];
                 //   NSLog(@"Dia %@ %@",day.DiaSemana,[dateFormatter stringFromDate:now]);
                    if ([day.DiaSemana isEqualToString: [dateFormatter stringFromDate:now]]) {
                        NSLog(@"Añadido Al Dia");
                        for (int d =lTemporal.hora.hour; d< comps.hour ; d++) {
                            NSMutableArray *array=[day.Horas objectAtIndex:d];
                            [array addObject:lTemporal];
                            [day.Horas replaceObjectAtIndex:d withObject:array];
                        }
                        [arrayDias replaceObjectAtIndex:i withObject:day];
                        break;
                        
                    }
                }

                
                
                Localizacion * lTemporalGuardar=[[Localizacion alloc]init];
                lTemporalGuardar.latitude=newLocation.coordinate.latitude;
                lTemporalGuardar.longitude=newLocation.coordinate.longitude;
                lTemporalGuardar.hora=comps;
                
                [geocoder reverseGeocodeLocation:newLocation completionHandler:
                 ^(NSArray* placemarks, NSError* error){
                     if ([placemarks count] > 0)
                     {
                         CLPlacemark *placemark = [placemarks objectAtIndex:0];
                         lTemporalGuardar.Lugar =placemark.name;
                         
                     }
                 }];
                
                NSData *dataT = [NSKeyedArchiver archivedDataWithRootObject:lTemporalGuardar];
                
                [userDefaults setObject:dataT forKey:@"Temporal"];
                NSData *datos3 = [NSKeyedArchiver archivedDataWithRootObject:arrayDias];
                [[NSUserDefaults standardUserDefaults] setObject:datos3 forKey:@"Localizaciones"];
             NSLog(@"Temporal Cambiado");
                
            }
        

    [[NSUserDefaults standardUserDefaults]synchronize];
    // Handle location updates as normal, code omitted for brevity.
    // The omitted code should determine whether to reject the location update for being too
    // old, too close to the previous one, too inaccurate and so forth according to your own
    // application design.
   
        }   }}
}

@end
