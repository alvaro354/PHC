//
//  PopularesViewController.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 03/11/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopularesView.h"

@interface PopularesViewController : UIViewController{
    NSMutableArray * viewFotosA;
    
}


@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) IBOutlet PopularesView *ViewFotos;

@end
