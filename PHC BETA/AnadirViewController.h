//
//  AnadirViewController.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 29/03/13.
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

@interface AnadirViewController : UIViewController <UITableViewDelegate,UISearchBarDelegate, UITableViewDataSource>{
    
    __weak IBOutlet UIView *viewFondo;
     Usuario *item;
    NSMutableArray *array;
    NSMutableArray *arrayMostrar;
    __weak IBOutlet UIView *vistaBuscar;
    __weak IBOutlet UISearchBar *buscar;
    __weak IBOutlet UITableView *tabla;
        MBProgressHUD *hud;
    NSMutableArray * imagenesArray;
    bool animado;
    int IndexPulsado;
}
-(IBAction)volver:(id)sender;
@property (strong, nonatomic) fileUploadEngine *flUploadEngine;
@property (strong, nonatomic) MKNetworkOperation *flOperation;
@end
