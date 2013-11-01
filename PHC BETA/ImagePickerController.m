 //
//  ImagePickerController.m
//  MaskImage
//
//  Created by Vladimir Boychentsov on 12/26/09.
//  Copyright 2009 www.injoit.com. All rights reserved.
//

#import "ImagePickerController.h"
#import "SubirImagen.h"
#import "SSPhotoCropperViewController.h"


static BOOL toolbarHidden = NO;
static BOOL iadHidden = NO;

#define NUMBER_OF_ITEMS 12
#define ITEM_SPACING 210

@interface ImagePickerController () <UIActionSheetDelegate>
@property (nonatomic, retain)  NSMutableArray *items;
@end


@implementation ImagePickerController
@synthesize carousel;
@synthesize items;@synthesize bannerIsVisible;
@synthesize aPopover;
@synthesize flUploadEngine = _flUploadEngine;
@synthesize flOperation = _flOperation;
@synthesize animator;



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.




// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*
- (void)loadView {
    
   
     NSLog(@"Free Mode");
*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//
        NSLog(@"Free Mode");
        
    }
    return self;
}


- (IBAction)borrar{
    if ([Imagenes count]>0) {
     
        contadorImagenes = [Imagenes count]-1;

        UIView *viewImagenes = [Imagenes objectAtIndex:contadorImagenes];
		[viewImagenes removeFromSuperview];
        [Imagenes removeObjectAtIndex:contadorImagenes];
        [self borrar];
    
}

}

-(IBAction)showActionSheet:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(hidden==NO){
            [info removeFromSuperview];
            hidden=YES;
        }
    }
    if(carousel.isHidden==NO){
        [carousel removeFromSuperview];
    }
	
    popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") destructiveButtonTitle:nil otherButtonTitles:@"Upload Photo",NSLocalizedString(@"Save Photo",@""),NSLocalizedString(@"Main Menu",@""),nil];
	//popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
   // popupQuery.backgroundColor = [UIColor colorWithRed:0.17 green:0.522 blue:0.725 alpha:1];
	[popupQuery showInView:self.view];
	
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    /*
    UIImage *theImage = [UIImage imageNamed:@"detail_menu_bg.png"];
    theImage = [theImage stretchableImageWithLeftCapWidth:32 topCapHeight:32];
    CGSize theSize = actionSheet.frame.size;
    // draw the background image and replace layer content
    UIGraphicsBeginImageContext(theSize);
    [theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];
    theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[actionSheet layer] setContents:(id)theImage.CGImage];
     */
   
    /*
    CGSize mySize = actionSheet.bounds.size;
    CGRect myRect = CGRectMake(0, 0, mySize.width, mySize.height);
    UIImageView *redView = [[UIImageView alloc] initWithFrame:myRect] ;
    [redView setBackgroundColor:[UIColor colorWithRed:0.17 green:0.522 blue:0.725 alpha:1]];
    redView.alpha = 0.3;
    [actionSheet insertSubview:redView atIndex:0];
   // actionSheet.clipsToBounds=YES;
   // actionSheet.layer.cornerRadius = 20.0;
     */
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if(hidden==NO){
                [info removeFromSuperview];
                hidden=YES;
                if (botonPro == YES){
                    [button removeFromSuperview];
                    botonPro=NO;
                    
                }
            }}
        
        barra.frame = CGRectOffset(barra.frame, 0, -barra.frame.size.height);
        barra.alpha = 0;
        toolbarHidden = YES;
        iadHidden = YES;
        adView.frame = CGRectOffset(adView.frame, 0, +adView.frame.size.height);
        adView.alpha = 0;
  //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
       //[UIApplication sharedApplication].keyWindow.frame=CGRectMake(0, 0, 320, 480);
        
        //[self uploadImage:[self captureView:self.view]];
       //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        
        
       //SubirImagen* secondViewController = [[SubirImagen alloc]init];
     
      
        SubirImagen * secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Subir"];
       
        [secondViewController willMoveToParentViewController:self];
        [self addChildViewController:secondViewController];
        CATransition *transition = [CATransition animation];
        transition.duration = 1;
        transition.type = kCATransitionFade;//choose your animation
        [secondViewController.view.layer addAnimation:transition forKey:nil];
        secondViewController.imagen=[self captureView:self.view];
        [self.view addSubview:secondViewController.view];
        [self.view bringSubviewToFront:secondViewController.view];
        [secondViewController didMoveToParentViewController:self];
        /*        barra.frame = CGRectOffset(barra.frame, 0, +barra.frame.size.height);
        barra.alpha = 0.8;
        toolbarHidden = NO;
        iadHidden = NO;
        adView.frame = CGRectOffset(adView.frame, 0, -adView.frame.size.height);
        adView.alpha = 1;
         */
        
        
	}
	if (buttonIndex == 1) {
        [self Guardarfoto];
	}
    if (buttonIndex == 2) {
      
        [self dismissViewControllerAnimated:YES completion:nil];
    
	}
  
}
-(void) uploadImage:(UIImage *)image
{
    
    

    
    NSLog(@"Enviando");
    NSString *_key = @"alvarol2611995";
    
    NSDate *myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
     NSDateFormatter *dma = [NSDateFormatter new];
     NSDateFormatter *hms = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    [dma setDateFormat:@"dd-MM-yyyy"];
      [hms setDateFormat:@"hh:mm:ss"];

 

    
    _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
    NSLog(@" %@ date",[hms stringFromDate:myDate]);
    StringEncryption *crypto = [[StringEncryption alloc] init] ;
    
    
    
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ID_usuario"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
         NSLog(@" Tamaño Imagen : %d",[imageData length]);

  
    
	CCOptions padding = kCCOptionECBMode;
	NSData *encryptedData = [crypto encrypt:imageData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
    
 NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.labelText = NSLocalizedString(@"Cargando", @"");
   
	
	/*NSData *decryptedData = [crypto decrypt:encryptedData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
     
     NSLog(@"decrypted data in dex: %@", decryptedData);
     NSString *str = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
     
     NSLog(@"decrypted data string for export: %@",str);
      */

    
    
   NSData* imagen=[[encryptedData base64EncodingWithLineLength:0] dataUsingEncoding:[NSString defaultCStringEncoding] ] ;

    
      NSString *post =[NSString stringWithFormat:@"id=%@",usuarioID];
      NSString *post2 =[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
     NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
    NSString *post4=[NSString stringWithFormat:@"&hora=%@",[hms stringFromDate:myDate]];
      NSString *post5=[NSString stringWithFormat:@"&token=%@",tokenID];

    NSString *urlString= @"http://lanchosoftware.es/phc/imageupload.php?";
   // NSString *urlString= @"http://lanchosoftware.es/app/imagenperfil.php?";
    urlString = [urlString stringByAppendingString:post];
       urlString = [urlString stringByAppendingString:post2];
        urlString = [urlString stringByAppendingString:post3];
      urlString = [urlString stringByAppendingString:post4];
      urlString = [urlString stringByAppendingString:post5];

 
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];

     
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
   
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"imagename.jpg\"\r\n",index] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imagen]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSOperationQueue *cola = [NSOperationQueue new];
    // now lets make the connection to the web
    
    [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         if ( [returnString isEqualToString:@"Yes"]) {
             
             barra.frame = CGRectOffset(barra.frame, 0, +barra.frame.size.height);
             barra.alpha = 0.8;
             toolbarHidden = NO;
             iadHidden = NO;
             adView.frame = CGRectOffset(adView.frame, 0, -adView.frame.size.height);
             adView.alpha = 1;
             
         UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"OK" message:@"Foto Subida"
                                                               delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
         [alertsuccess show];
         }
         else{
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
             UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"OK" message:@"Error"
                                                                   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
             [alertsuccess show];
         }
         self->returnData=[[NSData alloc]initWithData:data];
         
     }];
    NSLog(@"%u",[returnData length]);
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@ Resultado",returnString);
    
 
    
}




- (IBAction)setUp
{    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    if(hidden==NO){
        [info removeFromSuperview];
        hidden=YES;
        if (botonPro == YES){
            [button removeFromSuperview];
            botonPro=NO;
            
        }
    }}
    [aPopover dismissPopoverAnimated:YES];
   
	//set up data
    items = [NSMutableArray arrayWithObjects:
             
             [UIImage imageNamed:@"Circulobt.png"],
             [UIImage imageNamed:@"Cuadrobt.png"],
             nil];
    NSLog(@"Carrosuel LLamado");
    
    carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
    
    carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        carousel.type = iCarouselTypeLinear;
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            carousel.frame= CGRectMake((self.view.frame.size.width/2)-500,(self.view.frame.size.height/2)-850,1000,1200);
        }
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight ) {
            carousel.frame= CGRectMake((self.view.frame.size.height/2)-400,(self.view.frame.size.width/2)-850,1000,1200);
        }
           NSLog(@"iPad");
    } 
    else{
        carousel.type = iCarouselTypeLinear;    
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
    if (VezAlerta==0) {
        [self alerta];
    }
}


// CARRUSEL //
#pragma mark -
#pragma mark iCarousel methods 

-(void)Carrusel{
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
    butto.frame = CGRectMake(0.0f, 0.0f, 150, 150);
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
    alertaboton=YES;
	if (index == 0){
        [self setImageFromAlbom];
        figura=1;
    }
    if (index == 1){
        [self setImageFromAlbom];
        figura=2;
    }
    if (index == 2){
        [self performSelector:@selector(alerta)
                   withObject:nil
                   afterDelay:0.5];
    }
    if (index == 3){
        [self performSelector:@selector(alerta)
                   withObject:nil
                   afterDelay:0.5];

    }
    if (index == 4){
        [self performSelector:@selector(alerta)
                   withObject:nil
                   afterDelay:0.5];

    }
    if (index == 5){
        [self performSelector:@selector(alerta)
                   withObject:nil
                   afterDelay:0.5];

    }
    if (index == 6){
        [self performSelector:@selector(alerta)
                   withObject:nil
                   afterDelay:0.5];

    }
    if (index == 7){
        [self performSelector:@selector(alerta)
                   withObject:nil
                   afterDelay:0.5];

    }
    if (index == 8){
        [self performSelector:@selector(alerta)
                   withObject:nil
                   afterDelay:0.5];

    }
    if (index == 9){
        [self performSelector:@selector(alerta)
                   withObject:nil
                   afterDelay:0.5];

    }
    if (index == 10){
        [self performSelector:@selector(alerta)
                   withObject:nil
                   afterDelay:0.5];

    }
    if (index == 11){
        [self performSelector:@selector(alerta)
                   withObject:nil
                   afterDelay:0.5];

    }
}

-(void)viewWillAppear:(BOOL)animated{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    barra.barTintColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    barra.tintColor =[UIColor whiteColor];
    barra.translucent=YES;
    
    [self reloadInputViews];
}

-(void)toqueMantenido:(UILongPressGestureRecognizer*)reconocedor{
    NSLog(@"Prueba de toque");
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
     [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
            imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [imageView setImage:[UIImage imageNamed:@"IphoneRetina@2X.png"]];
    
            [self.view insertSubview:imageView atIndex:0];
    
    UILongPressGestureRecognizer *GEST=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(toqueMantenido:)];
    GEST.minimumPressDuration=0.5;
     
    [self.view addGestureRecognizer:GEST];


    Imagenes =[[NSMutableArray alloc]init];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    
        CGRect  rect = [[UIScreen mainScreen] bounds];
        [self.view setFrame:rect]; 
        
       
        [self.view setBackgroundColor:[UIColor grayColor]];
        [self.view setUserInteractionEnabled:YES];
        [self.view setMultipleTouchEnabled:YES];
        View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768,1024)];
        [self.view addSubview:View];
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
            
        
        [self performSelector:@selector(alerta)
                   withObject:nil
                   afterDelay:180];
        [super viewDidLoad];
            }
            else {
        
    
	[self.view setBackgroundColor:[UIColor grayColor]];
     [self.view setUserInteractionEnabled:YES];
	[self.view setMultipleTouchEnabled:YES];
    View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:View];
    [self.view addSubview:barra];
   
        adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        adView.frame = CGRectOffset(adView.frame, 0, 380);
         adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        [self.view addSubview:adView];
        adView.delegate=self;
        self.bannerIsVisible=NO;
     
        
        NSLog(@"4.2 or above");
        
    
  
}
    [self performSelector:@selector(alerta2)
               withObject:nil
               afterDelay:300];
    [super viewDidLoad];
}







-(void)alerta{
    alerta =0;
alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Pro Version",@"") message:NSLocalizedString(@"If you like the App and you want enjoy all the features, please push the button and buy the Pro version.",@"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Buy",@""),NSLocalizedString(@"Cancel",@""),nil];
[alert show];

}
-(void)alerta2{
    alerta=1;
    alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Rate It",@"") message:NSLocalizedString(@"If you like the App, Please rate it in the AppStore.",@"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Rate It",@""),NSLocalizedString(@"Cancel",@""),nil];
    [alert show];
    
}
- (void) alertView:(UIAlertView*)alert3 didDismissWithButtonIndex:(NSInteger)buttonIndex
 
{
   
	if (buttonIndex == 0 && alerta == 0)
	{
        
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/photocollage-pro/id430247672?mt=8&ls=1"]];
     
	}
    if (buttonIndex == 0 && alerta == 1)
	{
        NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
        str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str]; 
        str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
        
        // Here is the app id from itunesconnect
        str = [NSString stringWithFormat:@"%@428361142", str]; 
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

        
	}
	
	if (buttonIndex == 1 && alerta == 1)
	{
        [alert3 removeFromSuperview];
      
       
	}
    if (buttonIndex == 1 && alerta == 0){
        [alert3 removeFromSuperview];
        if(alertaboton==NO){
            VezAlerta=1;
        }
    }
}
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
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)infos

{
    UIImage *image = [infos objectForKey:UIImagePickerControllerOriginalImage];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [aPopover dismissPopoverAnimated:NO];
        cortarimage=image;
        [self CortarImagen];
        
    }
    [self dismissModalViewControllerAnimated:NO];
    
    cortarimage=image;
    [self CortarImagen];
    
    
}
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
   [aPopover dismissPopoverAnimated:NO];
         cortarimage=image;
         [self CortarImagen];
         
     }
    [self dismissModalViewControllerAnimated:NO];
    
    cortarimage=image;
    [self CortarImagen]; 
    
    
    }

*/



-(void)CortarImagen{
    
   
    NSLog(@"BotonCortado");
    if (cortarimage.size.height > cortarimage.size.width) {
        NSLog(@"Mayor altura");
        w = cortarimage.size.width * 2*(self.view.frame.size.width/cortarimage.size.width);
        h = cortarimage.size.height * 2*(self.view.frame.size.height/cortarimage.size.height);
    }
    else{
        NSLog(@"Menor altura");
        w = cortarimage.size.width *1.5*(self.view.frame.size.width/cortarimage.size.height);
        h = cortarimage.size.height *1.5*(self.view.frame.size.height/cortarimage.size.width);
    }
    
    
    CGSize newSize = CGSizeMake(w, h);
    UIGraphicsBeginImageContext( newSize );
    [cortarimage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    SSPhotoCropperViewController *photoCropper =
    [[SSPhotoCropperViewController alloc] initWithPhoto:newImage
                                               delegate:self
                                                 uiMode:SSPCUIModePresentedAsModalViewController
                                        showsInfoButton:YES];
    [photoCropper setMinZoomScale:0.0f];
    [photoCropper setMaxZoomScale:50.50f];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:photoCropper];
    [self presentModalViewController:nc animated:NO];

    [self.view bringSubviewToFront:nc.view];
  

    
}

- (IBAction) setImageFromAlbom {
    [carousel removeFromSuperview];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [aPopover dismissPopoverAnimated:YES];
        [imagePicker dismissModalViewControllerAnimated:NO];
        NSLog(@"Acesso");
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        

     aPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [aPopover setPopoverContentSize:CGSizeMake(320,480)]; 
        [aPopover presentPopoverFromBarButtonItem:Botonmas permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
      
       
    }
    else{
        
	imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	[self presentModalViewController:imagePicker animated:YES];
	
   
    }
   
}



- (UIImageView*)maskImage:(UIImage *)image {
	/*
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	if(figura==1){
	maskImage = [UIImage imageNamed:@"Circulo.png"];
    }
    if(figura==2){
        maskImage = [UIImage imageNamed:@"Cuadro.png"];
    }
	CGImageRef maskImageRef = [maskImage CGImage];
	
	// create a bitmap graphics context the size of the image
	CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
	
	CGColorSpaceRelease(colorSpace);
	if (mainViewContentContext==NULL)
		return NULL;
	
	CGFloat ratio = 0;
    CGFloat scale = 0.5;
	
	ratio = maskImage.size.width/ image.size.width;
	
	if(ratio * image.size.height < maskImage.size.height) {
		ratio = maskImage.size.height/ image.size.height;
	} 
	
	CGRect rect1  = {{0, 0}, {maskImage.size.width, maskImage.size.height}};
	CGRect rect2  = {{-((image.size.width*ratio)-maskImage.size.width)/2 , -((image.size.height*ratio)-maskImage.size.height)/2}, {image.size.width*ratio, image.size.height*ratio}};
	
	
	CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
	CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);
    CGAffineTransformMakeScale(scale,scale);

	// release that bitmap context
	CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
    
    
	UIImage *theImage = [UIImage imageWithCGImage:newImage];
	CGImageRelease(newImage);

	// return the image
	return theImage;
     */
    //CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	if(figura==1){
        maskImage = [UIImage imageNamed:@"Circulo.png"];
    }
    if(figura==2){
        maskImage = [UIImage imageNamed:@"Cuadro.png"];
    }
    CALayer *maskLayer = [CALayer layer];
   
    maskLayer.contents = (id)maskImage.CGImage;
    //  maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.frame = CGRectMake(0.0, 0.0,maskImage.size.width,maskImage.size.height);
    
    UIImageView *viewToMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, maskImage.size.width, maskImage.size.height)];
    viewToMask.image = image;
    
    viewToMask.layer.mask = maskLayer;
    viewToMask.layer.mask.borderWidth= 8;
    viewToMask.layer.mask.borderColor= [UIColor blueColor].CGColor;
    
    return viewToMask;
} 




-(void)scale:(id)sender {
	
	[self.view bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
	
	if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		lastScale = 1.0;
		return;
	}
	
	CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
	
	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
	CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
	
	[[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
	
	lastScale = [(UIPinchGestureRecognizer*)sender scale];
    [self.view bringSubviewToFront:barra];
      [self.view bringSubviewToFront:adView];
}

-(void)rotate:(id)sender {
	
	[self.view bringSubviewToFront:[(UIRotationGestureRecognizer*)sender view]];
	
	if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		lastRotation = 0.0;
		return;
	}
	
	CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
	
	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
	CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
	
	[[(UIRotationGestureRecognizer*)sender view] setTransform:newTransform];
	
	lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    [self.view bringSubviewToFront:barra];
      [self.view bringSubviewToFront:adView];

}

-(void)move:(id)sender {
	
	
	
	[self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
		
		firstX = [[sender view] center].x;
		firstY = [[sender view] center].y;
	}
	
	translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
	
	[[sender view] setCenter:translatedPoint];
	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		CGFloat finalX = translatedPoint.x;
		CGFloat finalY = translatedPoint.y;
		
		if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        

		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.35];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[[sender view] setCenter:CGPointMake(finalX, finalY)];
		[UIView commitAnimations];
        }}
     /*
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UISnapBehavior* snapBehavior = [[UISnapBehavior alloc] initWithItem:[(UIPanGestureRecognizer*)sender view] snapToPoint:translatedPoint];
    [self.animator addBehavior:snapBehavior];
    */
    
    [self.view bringSubviewToFront:barra];
      [self.view bringSubviewToFront:adView];

}
-(void)tap:(id)sender {
[aPopover dismissPopoverAnimated:YES];
}

-(void)tapped:(id)sender {
hidden=YES;
    [[(UIPinchGestureRecognizer*)sender view]removeFromSuperview];
    if (botonPro == YES){
    [button removeFromSuperview];
        botonPro=NO;
         
    }
	
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
                    [UIView beginAnimations:@"toolbar" context:nil];
                    if (toolbarHidden  && iadHidden ) {
                        barra.frame = CGRectOffset(barra.frame, 0, +barra.frame.size.height);
                        barra.alpha = 0.8;
                        toolbarHidden = NO;
                        iadHidden = NO;
                        adView.frame = CGRectOffset(adView.frame, 0, -adView.frame.size.height);
                        adView.alpha = 1;
                       
                    } 
                    else {
                        
                        barra.frame = CGRectOffset(barra.frame, 0, -barra.frame.size.height);
                        barra.alpha = 0;
                        toolbarHidden = YES;
                        iadHidden = YES;
                        adView.frame = CGRectOffset(adView.frame, 0, +adView.frame.size.height);
                        adView.alpha = 0;
                            
                    
                    } 

                    [UIView commitAnimations];
                    
                    
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(hidden==NO){
            [info removeFromSuperview];
            hidden=YES;
            if (botonPro == YES){
                [button removeFromSuperview];
                botonPro=NO;
                
            }
        }}
   
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
  
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	
	return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

-(IBAction)informacion{
    hidden=NO;
    [aPopover dismissPopoverAnimated:YES];
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
          if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                  info = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-250, self.view.center.y-175,500, 350)];
                  info.bounds=CGRectMake(20, 20, 500, 350);
                  info.clipsToBounds = YES;
                  info.layer.cornerRadius = 8.0;
                  info.opaque=YES;
                  [info setBackgroundColor:[UIColor blackColor]];
                  info.alpha = 0.8;
                  
                  [self.view addSubview:info];
                  
                  NSLog(@"View");
                  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
                  [tapRecognizer setNumberOfTapsRequired:1];
                  [tapRecognizer setDelegate:self];
                  [info addGestureRecognizer:tapRecognizer];
                  UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(30,0, 500, 350) ];
                  
                  scoreLabel.textColor = [UIColor whiteColor];
                  scoreLabel.backgroundColor = [UIColor clearColor];
                  scoreLabel.numberOfLines= 20;
                  scoreLabel.lineBreakMode= UILineBreakModeWordWrap;
                  scoreLabel.textAlignment = UITextAlignmentLeft;
                  scoreLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(15.0)];
                  
                  [info addSubview:scoreLabel];
                
                  scoreLabel.text =  NSLocalizedString(@ "*If you touch an image and drag, you can move the image. \n\n*If you pinch an image you can scale their size. \n\n*You can rotate images by pinching and twisting the fingers. \n\n *To delete an image touch it three times.\n\n*Touch twice to hide the interface. \n\n*This is a trial version only has the main functions.", @"");
                  
                   button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                  [button addTarget:self 
                             action:@selector(aMethod)
                   forControlEvents:UIControlEventTouchUpInside];
                  [button setTitle:NSLocalizedString(@"Pro Version",@"") forState:UIControlStateNormal];
                  button.frame = CGRectMake(self.view.center.x-80, self.view.center.y+110, 160.0, 40.0);
                  [self.view addSubview:button];
                 
                  [self.view bringSubviewToFront: adView];
                  [self.view bringSubviewToFront: info];
              [self.view bringSubviewToFront:button];
              botonPro=YES;
                  
                  
                  
              }
          
          if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight ) {
              info = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-120, self.view.center.y-270, 500, 350)];
              info.opaque=YES;
              info.clipsToBounds = YES;
              info.layer.cornerRadius = 8.0;
              [info setBackgroundColor:[UIColor blackColor]];
              info.alpha = 0.8;
              
              [self.view addSubview:info];
              
              NSLog(@"View");
              UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
              [tapRecognizer setNumberOfTapsRequired:1];
              [tapRecognizer setDelegate:self];
              [info addGestureRecognizer:tapRecognizer];
              UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, 0, 500, 350) ];
              
              scoreLabel.textColor = [UIColor whiteColor];
              scoreLabel.backgroundColor = [UIColor clearColor];
              scoreLabel.numberOfLines= 20;
              scoreLabel.lineBreakMode= UILineBreakModeWordWrap;
              scoreLabel.textAlignment = UITextAlignmentLeft;
              scoreLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(15.0)];
              scoreLabel.autoresizesSubviews = YES;
              scoreLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
              scoreLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
              info.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
              info.autoresizingMask = UIViewAutoresizingFlexibleWidth;
              self.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
              info.autoresizesSubviews = YES;
              [info addSubview:scoreLabel];
             
              scoreLabel.text =  NSLocalizedString(@"*If you touch an image and drag, you can move the image. \n\n*If you pinch an image you can scale their size. \n\n*You can rotate images by pinching and twisting the fingers. \n\n *To delete an image touch it three times.\n\n*Touch twice to hide the interface. \n\n*This is a trial version only has the main functions.", @"");
              
             
              [self.view bringSubviewToFront: adView];
              
              
          }     
    
          
      }
    
    
    
      else{
    
 if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
    info = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    info.opaque=YES;
    [info setBackgroundColor:[UIColor blackColor]];
    info.alpha = 0.8;
    
    [self.view addSubview:info];
 
    NSLog(@"View");
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	[tapRecognizer setNumberOfTapsRequired:1];
	[tapRecognizer setDelegate:self];
	[info addGestureRecognizer:tapRecognizer];
    UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, -30, self.view.frame.size.width, self.view.frame.size.height) ];

    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.numberOfLines= 20;
    scoreLabel.lineBreakMode= UILineBreakModeWordWrap;
    scoreLabel.textAlignment = UITextAlignmentLeft;
    scoreLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(15.0)];
    scoreLabel.autoresizesSubviews = YES;
    scoreLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    scoreLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
     info.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
     info.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    info.autoresizesSubviews = YES;
    [info addSubview:scoreLabel];
     
    scoreLabel.text =  NSLocalizedString(@"*If you touch an image and drag, you can move the image. \n\n*If you pinch an image you can scale their size. \n\n*You can rotate images by pinching and twisting the fingers. \n\n *To delete an image touch it three times.\n\n*Touch twice to hide the interface. \n\n*This is a trial version only has the main functions.", @"");
    
     button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [button addTarget:self 
                action:@selector(aMethod)
      forControlEvents:UIControlEventTouchUpInside];
     [button setTitle:NSLocalizedString(@"Pro Version",@"") forState:UIControlStateNormal];
     button.frame = CGRectMake(80.0, 370.0, 160.0, 40.0);
     [self.view addSubview:button];
   
     [self.view bringSubviewToFront: adView];
     [self.view bringSubviewToFront: info];
     [self.view bringSubviewToFront:button];
     botonPro=YES;

     
 }
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight ) {
        info = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
        info.opaque=YES;
        [info setBackgroundColor:[UIColor blackColor]];
        info.alpha = 0.8;
        
        [self.view addSubview:info];
        
        NSLog(@"View");
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [tapRecognizer setDelegate:self];
        [info addGestureRecognizer:tapRecognizer];
        UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, 0, 480, 320) ];
        
        scoreLabel.textColor = [UIColor whiteColor];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.numberOfLines= 20;
        scoreLabel.lineBreakMode= UILineBreakModeWordWrap;
        scoreLabel.textAlignment = UITextAlignmentLeft;
        scoreLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(15.0)];
        scoreLabel.autoresizesSubviews = YES;
        scoreLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        scoreLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        info.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        info.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        info.autoresizesSubviews = YES;
        [info addSubview:scoreLabel];
       
        scoreLabel.text =  NSLocalizedString(@"*If you touch an image and drag, you can move the image. \n\n*If you pinch an image you can scale their size. \n\n*You can rotate images by pinching and twisting the fingers. \n\n *To delete an image touch it three times.\n\n*Touch twice to hide the interface. \n\n*This is a trial version only has the main functions.", @"");
        
         
        [self.view bringSubviewToFront: adView];
        
       
    }     
    
      }}
-(void)aMethod{
    NSLog(@"Pulsado");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/photocollage-pro/id430247672?mt=8&ls=1"]];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:
         (UIInterfaceOrientation)toInterfaceOrientation {
             return YES;
         }

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration

{
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
 
        
        adView.currentContentSizeIdentifier =
        
        ADBannerContentSizeIdentifierLandscape;
        adView.frame = CGRectOffset(adView.frame, 0, -150);
    
    
    }
    else{
   
        adView.currentContentSizeIdentifier =
        
        ADBannerContentSizeIdentifierPortrait;
        adView.frame = CGRectOffset(adView.frame, 0, +150);
        
  
}
   if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
    UIImage * PortraitImage = [[UIImage alloc] initWithCGImage: imageView.image.CGImage
                                                         scale: 1.0
                                                   orientation: UIImageOrientationLeft];
    [imageView removeFromSuperview];
      imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height,self.view.frame.size.width)];
    [imageView setImage:PortraitImage];
    [self.view insertSubview:imageView atIndex:0];
   
    }
   else{
       UIImage * PortraitImage = [[UIImage alloc] initWithCGImage: imageView.image.CGImage
                                                            scale: 1.0
                                                      orientation: UIImageOrientationDown];
       [imageView removeFromSuperview];
       imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
       [imageView setImage:PortraitImage];
       [self.view insertSubview:imageView atIndex:0];
   
   }

}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {

    Borrar = nil;
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    carousel.delegate = nil;
    carousel.dataSource = nil;
   
    adView.delegate=nil;
  
}

#pragma -
#pragma SSPhotoCropperDelegate Methods

- (void) photoCropper:(SSPhotoCropperViewController *)photoCropper
         didCropPhoto:(UIImage *)photo
{
    
    UIImage* image = photo;
    /*image=[self maskImage:image];
    
    
	holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
	imageview = [[UIImageView alloc] initWithFrame:[holderView frame]];
	[imageview setImage:image];
	[holderView addSubview:imageview];
    */
   
	
   
    holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
	[holderView addSubview:[self maskImage:image]];
    
    
   
    
    
	
	UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
	[pinchRecognizer setDelegate:self];
	[holderView addGestureRecognizer:pinchRecognizer];
	
	UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
	[rotationRecognizer setDelegate:self];
	[holderView addGestureRecognizer:rotationRecognizer];
	
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
	[holderView addGestureRecognizer:panRecognizer];
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	[tapRecognizer setNumberOfTapsRequired:3];
	[tapRecognizer setDelegate:self];
	[holderView addGestureRecognizer:tapRecognizer];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        [self.view addSubview:holderView];
        
        CGFloat scale = 0.9;
        
        CGAffineTransform currentTransform = holderView.transform;
        CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
        
        [holderView setTransform:newTransform];
        
        
    
    }
    else{
        [self.view addSubview:holderView];
        
        CGFloat scale = 0.7;
        
        CGAffineTransform currentTransform = holderView.transform;
        CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
        
        [holderView setTransform:newTransform];
       
        
        
    }
    [Imagenes addObject:holderView];
    [photoCropper dismissModalViewControllerAnimated:YES];
}

- (void) photoCropperDidCancel:(SSPhotoCropperViewController *)photoCropper
{
    [photoCropper dismissModalViewControllerAnimated:YES];
}


@end

