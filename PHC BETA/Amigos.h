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
#import "NSString+AESCrypt.h"
#import <Security/Security.h>
#import "MBProgressHUD.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "SBJson.h"
#import "iCarousel.h"
#import "Imagen.h"
#import "DescargaImagenes.h"
#import "fileUploadEngine.h"


@interface Amigos : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate,iCarouselDataSource,iCarouselDelegate>{
    
    NSInteger indexTocado;
    __weak IBOutlet UIButton *cerrar;
 CGPoint pointCell;
    NSArray *array;
    Usuario *usuario;
    NSString * Amigo;

    __weak IBOutlet UILabel *label;
    __weak IBOutlet UIBarButtonItem *volver;
    
    NSMutableArray * UrlDatos;
   NSMutableArray * imagenesCargadas;
     NSString *Url;
    IBOutlet UIView *viewFotos;
    NSMutableArray * imagenes;
    float width;
    float height;
    int vez;
    int SPACING;
  __block  BOOL completado;
}
-(IBAction)volver:(id)sender;
-(IBAction)mensaje:(id)sender;
- (void)imagenes;
- (void)terminado;
@property (nonatomic,strong) NSString* url;
@property (nonatomic, retain) __block NSTimer *timer;
@property (nonatomic, retain) NSTimer *timer2;
@property(nonatomic,strong) NSString * Amigo;
@property(nonatomic,strong) NSString *UrlP;
@property(nonatomic,strong) NSString * ID;
@property(nonatomic) BOOL Etiquetas;
@property(nonatomic,strong)IBOutlet UILabel *Estado;
@property (nonatomic, retain) NSArray *imageURLs;
@property(nonatomic,strong)IBOutlet UILabel *Name;
@property(nonatomic,strong)IBOutlet UIImageView *Img;
@property(nonatomic,strong)IBOutlet UIImage *Imagen;
@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property ( nonatomic) fileUploadEngine *flUploadEngine;
@property (strong, nonatomic) MKNetworkOperation *flOperation;

@end
