
#import <UIKit/UIKit.h>
#import "SSPhotoCropperViewController.h"
#import <iAd/iAd.h>

#import <QuartzCore/QuartzCore.h>

@interface AutomaticVCI2 : UIViewController < UIAlertViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate,ADBannerViewDelegate,UIActionSheetDelegate,UIPopoverControllerDelegate,SSPhotoCropperDelegate,UIPopoverControllerDelegate> {
    
    UIImagePickerController *imagePicker;
    
    IBOutlet UIImageView *Uimage1;
    
    IBOutlet UIImageView *Uimage2;
    
    IBOutlet UIImageView *Uimage3;
    
    IBOutlet UIImageView *Uimage4;
    
    IBOutlet UIImageView *Uimage5;
    
   
    
    IBOutlet UIButton *Uibuton1;
    
    IBOutlet UIButton *Uibuton2;
    
    IBOutlet UIButton *Uibuton3;
    
    IBOutlet UIButton *Uibuton4;
    
    IBOutlet UIButton *Uibuton5;
    
   
    UIActionSheet *popupQuery;
    int imgInt;
    IBOutlet UIBarButtonItem *boton;
    BOOL hidden;
    IBOutlet UIToolbar *barra;
    UIPopoverController *aPopover;
    IBOutlet ADBannerView *adView;
    BOOL bannerIsVisible;
    UIView *View;
    BOOL Permitir;
}

-(IBAction)Boton1:(id)sender;
-(IBAction)Boton2:(id)sender;
-(IBAction)Boton3:(id)sender;
-(IBAction)Boton4:(id)sender;
-(IBAction)Boton5:(id)sender;

- (void) setImageFromAlbom;
- (UIImage*)captureView:(UIView *)view;
- (void)saveScreenshotToPhotosAlbum:(UIView *)view;
-(IBAction)showActionSheet:(id)sender;

@property (nonatomic,assign) BOOL bannerIsVisible;
@end
