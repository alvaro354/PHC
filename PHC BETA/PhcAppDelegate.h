//
//  PhcAppDelegate.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 04/01/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flurry.h"
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>
#import "Localizacion.h"


@interface PhcAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>
{
    UIWindow *window;
    UINavigationController *navigationController;
    BOOL internet;
    NSTimer *timer;
    NSTimer *timer2;
    UIAlertView *alert;
    CLLocationManager* locationManager ;
    BOOL anadir;
}
-(void)internet;
-(void)alert;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
