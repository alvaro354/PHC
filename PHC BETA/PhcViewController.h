//
//  PhcViewController.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 04/01/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface PhcViewController : BaseViewController
{
    IBOutlet UIView* notificationView;
    
    IBOutlet UILabel* commentCountLabel;
    IBOutlet UILabel* likeCountLabel;
    IBOutlet UILabel* followerCountLabel;
    
    UIButton* showButton;
    UIButton* hideButton;
}

@property (nonatomic, retain) IBOutlet UIView* notificationView;
@property(nonatomic, retain) NSString *usuarioID;
@property (nonatomic, retain) IBOutlet UILabel* commentCountLabel;
@property (nonatomic, retain) IBOutlet UILabel* likeCountLabel;
@property (nonatomic, retain) IBOutlet UILabel* followerCountLabel;
@property (nonatomic, retain) UIButton* showButton;
@property (nonatomic, retain) UIButton* hideButton;
@end