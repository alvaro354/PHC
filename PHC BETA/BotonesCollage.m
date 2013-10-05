//
//  BotonesCollage.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 05/03/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "BotonesCollage.h"
#import "ImagePickerController.h"


#define NUMBER_OF_ITEMS 2
#define ITEM_SPACING 4

@interface BotonesCollage ()
@property (nonatomic, retain)  NSMutableArray *items;
@end

@implementation BotonesCollage
@synthesize carousel;
@synthesize items;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)automatico:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDidStopSelector:@selector(removeMyView)];
    
    manual.alpha=0;
    manual.alpha=0;
    
    [UIView commitAnimations];
    
 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    }
        
        //set up data
        items = [NSMutableArray arrayWithObjects:
                 
                 [UIImage imageNamed:@"Automatico1.JPG"],
                 [UIImage imageNamed:@"Automatico2.JPG"],
                 nil];
        NSLog(@"Carrosuel LLamado");
        
        carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
        
        carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            carousel.type = iCarouselTypeCoverFlow;
            if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                carousel.frame= CGRectMake((self.view.frame.size.width/2)-500,(self.view.frame.size.height/2)-700,1000,1200);
            }
            if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight ) {
                carousel.frame= CGRectMake((self.view.frame.size.height/2)-400,(self.view.frame.size.width/2)-850,1000,1200);
            }
            NSLog(@"iPad");
        }
        else{
            carousel.type = iCarouselTypeCoverFlow;
            NSLog(@"iPhone");
        }
        carousel.dataSource = self;
        NSLog(@"Carrosuel Llamado2");
        [self.view addSubview:carousel];
        [self.view bringSubviewToFront:carousel];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [tapRecognizer setNumberOfTapsRequired:2];
        [tapRecognizer setDelegate:self];
        [carousel addGestureRecognizer:tapRecognizer];
        
    
}
-(IBAction)manual:(id)sender{
   // ImagePickerController* secondViewController = [[ImagePickerController alloc] initWithNibName:@"ImagePickerController" bundle:[NSBundle mainBundle]];
    UIViewController* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Collages"];

    [UIView beginAnimations:@"pageCurlUp" context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:NO];
    [[[self parentViewController] parentViewController] dismissViewControllerAnimated:YES completion:nil];
    [self presentViewController:secondViewController animated:NO completion:nil];
    [UIView commitAnimations];
       [self.view removeFromSuperview];
}

-(void)Carrusel{
    Carrousuelpuesto =YES;
    NSLog(@"Carrosuel LLamado3");
    carousel.type = iCarouselTypeCoverFlow2;
    
    carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
    
    carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    carousel.dataSource = self;
    
    
    [self.view addSubview:carousel];
    [self.view bringSubviewToFront:carousel];
    
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [items count];
}


- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    NSLog(@"Carrosuel Fabricado");
    //no button available to recycle, so create new one
    UIImage *image = [items objectAtIndex:index];
    UIButton *butto = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [butto setBackgroundImage:image forState:UIControlStateNormal];
    butto = [UIButton buttonWithType:UIButtonTypeCustom];
    butto.frame = CGRectMake(0.0f, 0.0f, image.size.width/3, image.size.height/3);
    [butto setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [butto setBackgroundImage:image forState:UIControlStateNormal];
    butto.titleLabel.font = [butto.titleLabel.font fontWithSize:50];
    [butto addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return butto;
}
- (void)buttonTapped:(UIButton *)sender
{
	//get item index for button
	NSInteger index = [carousel indexOfItemView:sender];
    
	if (index == 0 ){
       
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            AutomaticVCI* ViewController = [[AutomaticVCI alloc] initWithNibName:@"AutomaticVCI" bundle:[NSBundle mainBundle]];
            [UIView beginAnimations:@"pageCurlUp" context:NULL];
            [UIView setAnimationDuration:1];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:NO];
            [[[self parentViewController] parentViewController] dismissModalViewControllerAnimated:NO];
            [self presentModalViewController:ViewController animated:NO];
            [UIView commitAnimations];
            NSLog(@"Automatico 1 IPAD");
            
        }
        else{
            AutomaticVC* ViewController = [[AutomaticVC alloc] initWithNibName:@"AutomaticVC" bundle:[NSBundle mainBundle]];
            [UIView beginAnimations:@"pageCurlUp" context:NULL];
            [UIView setAnimationDuration:1];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:NO];
            [[[self parentViewController] parentViewController] dismissModalViewControllerAnimated:NO];
            [self presentModalViewController:ViewController animated:NO];
            [UIView commitAnimations];
            NSLog(@"Automatico 1");
        }}
    if (index == 1){
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            AutomaticVCI2* ViewController = [[AutomaticVCI2 alloc] initWithNibName:@"AutomaticVCI2" bundle:[NSBundle mainBundle]];
            [UIView beginAnimations:@"pageCurlUp" context:NULL];
            [UIView setAnimationDuration:1];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:NO];
            [[[self parentViewController] parentViewController] dismissModalViewControllerAnimated:NO];
            [self presentModalViewController:ViewController animated:NO];
            [UIView commitAnimations];
            NSLog(@"Automatico 1 IPAD");
            
        }
        else{
            AutomaticVC2* ViewController2 = [[AutomaticVC2 alloc] initWithNibName:@"AutomaticVC2" bundle:[NSBundle mainBundle]];
            [UIView beginAnimations:@"pageCurlUp" context:NULL];
            [UIView setAnimationDuration:1];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:NO];
            [[[self parentViewController] parentViewController] dismissModalViewControllerAnimated:NO];
            [self presentModalViewController:ViewController2 animated:NO];
            [UIView commitAnimations];
            
            NSLog(@"Automatico 2");
        }}
    
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	//Get all the touches.
	NSSet *allTouches = [event allTouches];
	
	//Number of touches on the screen
	switch ([allTouches count])
	{
		case 1:
		{
			//Get the first touch.
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			
			switch([touch tapCount])
			{
				case 1://Single tap
                    if (Carrousuelpuesto==NO) {
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:0.5];
                        
                        [UIView setAnimationDidStopSelector:@selector(removeMyView)];
                        
                        self.view.frame=CGRectMake(400, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                        
                        [UIView commitAnimations];
                    }
                    else{
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.5];
                    
                    [UIView setAnimationDidStopSelector:@selector(removeMyView)];
                  
                        carousel.alpha=0;
                    
                        [UIView commitAnimations];
                    }
                    
                  //  [self.view removeFromSuperview];
					
					break;
		
			}
        }
            break;
	}
	
}
- (void) removeMyView
{
    if (Carrousuelpuesto==NO) {
          [self.view removeFromSuperview];
    }
    else{
      
        [carousel removeFromSuperview];
        Carrousuelpuesto=NO;
    }

    
}



- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
