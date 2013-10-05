//
//  EtiquetasViewController.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 23/06/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Usuario.h"
#import "CeldaInvitacionesCell.h"
#import "AsyncImageView.h"
#import "Amigos.h"



@interface EtiquetasViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>{
            __weak IBOutlet UITableView *tabla;
    NSMutableArray *Urls;
    Usuario *Usupasar;
}
-(IBAction)volver:(id)sender;

@property (nonatomic,retain)  NSMutableArray *arrayMostrar;
@property (nonatomic,strong)  NSString *IDS;
@property (nonatomic,strong)  NSString *URLPasar;
@property (nonatomic,strong)  UIImage * imageP;
@end
