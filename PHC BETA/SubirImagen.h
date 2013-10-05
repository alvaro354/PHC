//
//  SubirImagen.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 14/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "MBProgressHUD.h"
#import "Usuario.h"
#import "fileUploadEngine.h"
#import <QuartzCore/QuartzCore.h>
#import "CeldaInvitacionesCell.h"

@interface SubirImagen : UIViewController <UITextFieldDelegate,UITableViewDelegate,UISearchBarDelegate, UITableViewDataSource>{
 
     MBProgressHUD *hud;
    __weak IBOutlet UITextField *titulo;
    __weak IBOutlet UISearchBar *buscar;
    __weak IBOutlet UITableView *tabla;
    __weak IBOutlet UISegmentedControl *privacidad;
    
    __weak IBOutlet UIButton *subir;
   
    __weak IBOutlet UIButton *cancelar;
    
    __weak IBOutlet UIScrollView *scroll;
    __weak IBOutlet UIView *vistaFondo;
       NSMutableArray * etiquetados ;
    NSMutableArray * amigos ;
    NSMutableArray * arrayMostrar;
    bool animado;
    int IndexPulsado;
    NSData * returnData;
}
-(IBAction)volver:(id)sender;
-(IBAction)SubirImagen:(id)sender;
@property (nonatomic,retain) UIImage * imagen;
@property (strong, nonatomic) fileUploadEngine *flUploadEngine;
@property (strong, nonatomic) MKNetworkOperation *flOperation;
@property (strong, nonatomic) UITextField *campoActivo;
@end
