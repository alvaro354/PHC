//
//  Login.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 09/02/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#include <math.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "NSString+AESCrypt.h"
#import <Security/Security.h>
#import "MBProgressHUD.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "SBJson.h"
#import <Security/Security.h>
#import "UICKeyChainStore.h"

@interface Login : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UIAlertViewDelegate>{
    NSMutableArray *xy;
    NSMutableArray* xz;
    NSMutableArray *Imagenes;
    NSMutableArray *ImagesViewArray;
     NSMutableArray *fondo;
    NSTimer *autoTimer;
     __weak IBOutlet UIImageView * phc;
    NSConditionLock* albumReadLock;
    UIView *vistaFondo;
    StringEncryption * encriptador;
    int contador;
    NSString *serverOutput;
    NSString *comprobacion;
    NSString *usuarioID;
    MBProgressHUD* hud;
    UICKeyChainStore *keychain;
    __weak IBOutlet UITextField *usuarioText;
    __weak IBOutlet UITextField *correoText;
    __weak IBOutlet UITextField *contrasenaText;
    __weak IBOutlet UIButton *aceptarB;
    __weak IBOutlet UIButton *registrarB;
    BOOL crear;
    BOOL COUNT;
    BOOL registrar;
    BOOL registrando;
    BOOL exito;
}
- (UIView *)collage:(NSMutableArray *)fotos;
- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
-(void)cambiarFotos;
-(void)Comprobar;


@property (weak, nonatomic) IBOutlet UIView *viewLongearse;
-(IBAction)sendData:(id)sender;
-(IBAction)registrar:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *viewS;
@property (strong, nonatomic) UITextField *campoActivo;

@end
