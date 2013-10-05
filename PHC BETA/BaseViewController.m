//
//  BaseViewController.m
//  CustomTabBarNotification
//
//  Created by Peter Boctor on 3/7/11.
//
//  Copyright (c) 2011 Peter Boctor
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE

#import "BaseViewController.h"
#import "BotonesCollage.h"
#import "ImagePickerController.h"

@implementation BaseViewController

- (void)drawRect:(CGRect)rect {
   
    
  //  self.tabBar.tintColor = [UIColor colorWithRed:(44/255) green:(169/255) blue:(241/255) alpha:1];

 //  [[UITabBar appearance] setTintColor:[UIColor colorWithRed:(44/255) green:(169/255) blue:(241/255) alpha:1]];
    
   // [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
   
}

// Create a view controller and setup it's tab bar item with a title and image
- (void)hideTabBar
{
    
    NSLog(@"Ocultar");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    button.hidden=YES;
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }
    
    [UIView commitAnimations];
}

- (void)showTabBar
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    button.hidden=NO;
    for(UIView *view in self.view.subviews)
    {
        NSLog(@"%@", view);
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
            
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
    }
    
    [UIView commitAnimations];
}

-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image 
{
    self.hidesBottomBarWhenPushed=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideTabBar)
                                                 name:@"Ocultar"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showTabBar)
                                                 name:@"Aparecer"
                                               object:nil];
 
    

   // self.tabBar.translucent =YES;
 
    
     self.tabBar.barTintColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    
     self.tabBar.tintColor = [UIColor whiteColor];
   //  self.tabBar.backgroundColor = [UIColor whiteColor];
    
     self.tabBar.selectedImageTintColor =[UIColor redColor];
    
    
    UIViewController* secondViewController;
    if(tag==0){
        secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"login1"];
        secondViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
        
        
    

    }
    if(tag==1){
        secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"login2"];
        secondViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
        
    }
    if(tag==2){
        secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"login3"];
        secondViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
        
    }
    if(tag==3){
        secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"login1"];
        secondViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
        
    }
    if(tag==4){
        secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"login2"];
        secondViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
        
    }
 
    
    tag++;
    return secondViewController;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:self
                 action:@selector(ButtonAction)
       forControlEvents:UIControlEventTouchUpInside];
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
  
    
}
-(void) ArrayViewControllers:(NSArray*)array{
      self.viewControllers= array;
}
-(void)ButtonAction{
    
     UIViewController* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Collage"];
    [secondViewController willMoveToParentViewController:self];
    [self addChildViewController:secondViewController];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush ;//choose your animation
    [secondViewController.view.layer addAnimation:transition forKey:nil];
    
    [self.view addSubview:secondViewController.view];
    [secondViewController didMoveToParentViewController:self];
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
@end