//
//  PhcViewController.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 04/01/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "PhcViewController.h"
#import "CustomNavigationBar.h"

@interface PhcViewController (PrivateMethods)
-(UIButton*) buttonWithText:(NSString*) text;


@end

@implementation PhcViewController 
@synthesize notificationView, commentCountLabel, likeCountLabel, followerCountLabel, showButton, hideButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.barTintColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    
    self.tabBar.tintColor = [UIColor whiteColor];
    //  self.tabBar.backgroundColor = [UIColor whiteColor];
    
    self.tabBar.selectedImageTintColor =[UIColor redColor];
    
    
    //[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.backgroundColor =[UIColor colorWithRed:0.17 green:0.522 blue:0.725 alpha:1];
 //   self.view.backgroundColor =[UIColor colorWithRed:0.17 green:0.522 blue:0.725 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.17 green:0.522 blue:0.725 alpha:1];
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:0.17 green:0.522 blue:0.725 alpha:1]];
    
    self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"Amigos" image:[[UIImage imageNamed:@"112-group.png"]imageWithRenderingMode:UIImageRenderingModeAutomatic]],
                            [self viewControllerWithTabTitle:@"News" image:[[UIImage imageNamed:@"news.png"]imageWithRenderingMode:UIImageRenderingModeAutomatic]],
                            [self viewControllerWithTabTitle:@"Collage" image:nil],
                            [self viewControllerWithTabTitle:@"Popular" image:[UIImage imageNamed:@"28-star.png"]],
                            [self viewControllerWithTabTitle:@"User" image:[UIImage imageNamed:@"123-id-card.png"]],
                            nil];
        [self addCenterButtonWithImage:[UIImage imageNamed:@"123-id-card.png"] highlightImage:nil];
 
  

//    [self addCenterButtonWithImage:nil highlightImage:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
   
        
        //[self setSelectedIndex:0];
    
}
@end
