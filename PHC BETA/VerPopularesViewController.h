//
//  VerPopularesViewController.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 16/11/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PopularesView.h"

@interface VerPopularesViewController : UITableViewController{
NSMutableArray * viewFotosA;
NSMutableArray *URLs ;
BOOL terminado;
}


@property (strong, nonatomic) IBOutlet PopularesView *ViewFotos;
@end