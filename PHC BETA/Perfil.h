//
//  Amigos.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 09/02/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Usuario.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import "NSString+AESCrypt.h"
#import <Security/Security.h>
#import "MBProgressHUD.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "SBJson.h"
#import "iCarousel.h"
#import "UICKeyChainStore.h"
#import "fileUploadEngine.h"
#import "Descargar.h"


@interface Perfil: UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate,iCarouselDataSource,iCarouselDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    UIImagePickerController *imagePicker;
       MBProgressHUD * hud;
    __weak IBOutlet UIButton *cerrar;
    CGPoint pointCell;
    NSArray *array;
    Usuario *usuario;
    NSString * Amigo;
    NSString * ID;
    __weak IBOutlet UILabel *label;
    __weak IBOutlet UIBarButtonItem *volver;
    NSData * returnData;
    IBOutlet UIView *viewFotos;
    NSMutableArray * imagenes;
    NSMutableArray * imagenesCargadas;
    NSMutableArray * imagePaths;
     NSMutableArray * UrlDatos;
    NSString *Url;
    int vez;
    int SPACING;
    BOOL act;
    BOOL completado;
    UICKeyChainStore * keychain;
 
    NSInteger indexTocado;
  //  NSArray* intVisible;
    float width;
    float height;
    int VezF;
}
-(void) uploadImage:(UIImage *)image;
-(IBAction)cambiarImagen:(id)sender;
-(IBAction)refrescar:(id)sender;
- (void)imagenes;
- (void)obtenerImagenPerfil:(NSNotification *)notification;
- (void)terminado;
@property (nonatomic, retain) __block NSTimer *timer;
@property (nonatomic, retain) NSTimer *timer2;
@property(nonatomic,strong) NSString * Amigo;
@property(nonatomic,strong)IBOutlet UILabel *Estado;
@property(nonatomic,strong)IBOutlet UILabel *Name;
@property(nonatomic,retain, readwrite)IBOutlet UIImageView *Img;
@property (nonatomic, retain) NSArray *imageURLs;
@property(nonatomic,retain)IBOutlet UIImage *Imagen;
@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) fileUploadEngine *flUploadEngine;
@property (strong, nonatomic) MKNetworkOperation *flOperation;

@end
