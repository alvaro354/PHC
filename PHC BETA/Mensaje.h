//
//  Mensaje.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 30/03/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import "MBProgressHUD.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "SBJson.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Usuario.h"

@interface Mensaje : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>{
    
    __weak IBOutlet UIImageView *imagen;
    Usuario* usuario;
    MBProgressHUD * hud;
    NSString *serverOutput;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *datos;
    __weak IBOutlet UITextField *mensaje;
    __weak IBOutlet UIButton *enviar;
    __weak IBOutlet UIButton *cancelar;
    __weak IBOutlet UIView *viewFondo;
    int alerta;
}


-(IBAction)enviar:(id)sender;
-(IBAction)cancelar:(id)sender;




@property (strong, nonatomic) IBOutlet UIScrollView *viewS;
@property (strong, nonatomic) UITextField *campoActivo;

@end
