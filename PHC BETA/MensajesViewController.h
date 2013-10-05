//
//  MensajesViewController.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 20/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Usuario.h"
#import "CeldaInvitacionesCell.h"

@class CeldaInvitacionesCell;
@interface MensajesViewController : UITableViewController  {
    
    NSMutableArray * mensajes;
    NSMutableArray * arrayGuardado;
      NSMutableArray * arrayMostrar;
    UIRefreshControl *refreshControl ;
    int indexTocado;
}
-(void)Mensajes;
@end
