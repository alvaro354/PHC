#import "AutomaticVCI2.h"

static BOOL toolbarHidden = NO;
static BOOL iadHidden = NO;

@interface AutomaticVCI2 ()

@end

@implementation AutomaticVCI2
@synthesize bannerIsVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    imgInt=0;
    return self;
}

-(IBAction)Boton1:(id)sender{
    NSLog(@"Boton1");
    [self setImageFromAlbom];
    imgInt=1;
    
}
-(IBAction)Boton2:(id)sender{
    [self setImageFromAlbom];
    imgInt=2;
    
}
-(IBAction)Boton3:(id)sender{
    [self setImageFromAlbom];
    imgInt=3;
    
}
-(IBAction)Boton4:(id)sender{
    [self setImageFromAlbom];
    imgInt=4;
    
}
-(IBAction)Boton5:(id)sender{
    [self setImageFromAlbom];
    imgInt=5;
    
}


- (void) setImageFromAlbom {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [aPopover dismissPopoverAnimated:YES];
        [imagePicker dismissModalViewControllerAnimated:NO];
        NSLog(@"Acesso");
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        
        
        aPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [aPopover setPopoverContentSize:CGSizeMake(320,480)];
        [aPopover presentPopoverFromBarButtonItem:boton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
    }
    else{
        
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];
        
        
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [aPopover dismissPopoverAnimated:YES];
        if (imgInt==1) {
            Uimage1.image = image;
        }
        if (imgInt==2) {
            Uimage2.image = image;
        }
        if (imgInt==3) {
            Uimage3.image = image;
        }
        if (imgInt==4) {
            Uimage4.image = image;
        }
        if (imgInt==5) {
            Uimage5.image = image;
        }
     
        
        imgInt=0;
    }
    else{
        [self dismissModalViewControllerAnimated:NO];
        if (imgInt==1) {
            Uimage1.image = image;
        }
        if (imgInt==2) {
            Uimage2.image = image;
        }
        if (imgInt==3) {
            Uimage3.image = image;
        }
        if (imgInt==4) {
            Uimage4.image = image;
        }
        if (imgInt==5) {
            Uimage5.image = image;
        }
     
        
        imgInt=0;
    }
}
-(void)tap:(id)sender {
    [aPopover dismissPopoverAnimated:YES];
}

-(void)tapped:(id)sender {
    hidden=YES;
    [[(UIPinchGestureRecognizer*)sender view]removeFromSuperview];
	
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
					
					break;
				case 2://Double tap.
                    
                    break;
			}
        }
            break;
	}
	
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

-(IBAction)Guardarfoto{
    // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //   if(hidden==NO){
    //     [info removeFromSuperview];
    //   hidden=YES;
    // if (botonPro == YES){
    //   [button removeFromSuperview];
    // botonPro=NO;
    
    barra.frame = CGRectOffset(barra.frame, 0, -barra.frame.size.height);
    barra.alpha = 0;
    toolbarHidden = YES;
    iadHidden = YES;
    adView.frame = CGRectOffset(adView.frame, 0, +adView.frame.size.height);
    adView.alpha = 0;
    
    [self saveScreenshotToPhotosAlbum:self.view];
    
}

- (UIImage*)captureView:(UIView *)view {
	CGRect rect = [[UIScreen mainScreen] bounds];
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[view.layer renderInContext:context];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;
}

- (void)saveScreenshotToPhotosAlbum:(UIView *)view {
	UIImageWriteToSavedPhotosAlbum([self captureView:view], nil, nil, nil);
    NSString *message = NSLocalizedString(@"This image has been saved to your Photos album", @"");
    ;
    UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:nil
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert2 show];
   
    barra.frame = CGRectOffset(barra.frame, 0, +barra.frame.size.height);
    barra.alpha = 1;
    toolbarHidden = NO;
    iadHidden = NO;
    adView.frame = CGRectOffset(adView.frame, 0, -adView.frame.size.height);
    adView.alpha = 1;
}


- (void)viewDidLoad
{
    Uimage1.layer.borderWidth=1.5;
    Uimage1.layer.borderColor=[UIColor blackColor].CGColor;
    [self.view addSubview:Uimage1];
    Uimage2.layer.borderWidth=1.5;
    Uimage2.layer.borderColor=[UIColor blackColor].CGColor;
    [self.view addSubview:Uimage2];
    Uimage3.layer.borderWidth=1.5;
    Uimage3.layer.borderColor=[UIColor blackColor].CGColor;
    [self.view addSubview:Uimage3];
    Uimage4.layer.borderWidth=1.5;
    Uimage4.layer.borderColor=[UIColor blackColor].CGColor;
    [self.view addSubview:Uimage4];
    Uimage5.layer.borderWidth=1.5;
    Uimage5.layer.borderColor=[UIColor blackColor].CGColor;
    [self.view addSubview:Uimage5];
    
    [self.view bringSubviewToFront:barra];
    [self.view bringSubviewToFront:adView];

    [self.view reloadInputViews];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        CGRect  rect = [[UIScreen mainScreen] bounds];
        [self.view setFrame:rect];
        [self.view setUserInteractionEnabled:YES];
        [self.view setMultipleTouchEnabled:YES];
        [self.view addSubview:barra];
        NSLog(@"IPAD");
        
       
            adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
            adView.frame = CGRectOffset(adView.frame, 0, 1000);
            adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
            adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
            [self.view addSubview:adView];
            adView.delegate=self;
            self.bannerIsVisible=NO;
           
            
            NSLog(@"4.2 or above");
            
        
        
        [super viewDidLoad];
    } else {
        
        
        [self.view setUserInteractionEnabled:YES];
        [self.view setMultipleTouchEnabled:YES];
        
        [self.view addSubview:barra];
        [self.view bringSubviewToFront:self.view];
        
        
       
            adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
            adView.frame = CGRectOffset(adView.frame, 0, 380);
            adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
            adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
            [self.view addSubview:adView];
            adView.delegate=self;
            self.bannerIsVisible=NO;
            
            
            NSLog(@"4.2 or above");
            
        
        [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
    }}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            NSLog(@"Anuncio Cargado IPAD");
            [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
            // banner is invisible now and moved out of the screen on 50 px
            banner.frame = CGRectOffset(banner.frame, 0, -45);
            [UIView commitAnimations];
            self.bannerIsVisible = YES;
        }
        else{
            NSLog(@"Anuncio Cargado");
            [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
            // banner is invisible now and moved out of the screen on 50 px
            banner.frame = CGRectOffset(banner.frame, 0, 50);
            [UIView commitAnimations];
            self.bannerIsVisible = YES;
        }}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            NSLog(@"Anuncio No cargado IPAD");
            [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
            // banner is visible and we move it out of the screen, due to connection issue
            banner.frame = CGRectOffset(banner.frame, 0,-50);
            [UIView commitAnimations];
            self.bannerIsVisible = NO;
            
            
        }
        else{
            NSLog(@"Anuncio No cargado");
            [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
            // banner is visible and we move it out of the screen, due to connection issue
            banner.frame = CGRectOffset(banner.frame, 0,-50);
            [UIView commitAnimations];
            self.bannerIsVisible = NO;
        }}
    
}

-(IBAction)showActionSheet:(id)sender {
	[aPopover dismissPopoverAnimated:NO];
    
    popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Save Photo",@""),NSLocalizedString(@"Main Menu",@""),nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
	
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == 0) {
        [self Guardarfoto];
        
        
	}
    if (buttonIndex == 1) {
         [self.view removeFromSuperview];
        
        
        
        
	}
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidUnload {

    
    [super viewDidUnload];
}
@end