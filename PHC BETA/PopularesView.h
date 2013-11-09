//
//  PopularesView.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 03/11/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopularesView : UIView <NSCopying>{
    

    NSMutableArray * Imagenes;
}

-(void)ImagenesDe:(NSMutableArray*)URLS;


@property(nonatomic,retain) IBOutlet UIImageView * F1;
@property(nonatomic,retain) IBOutlet UIImageView * F2;
@property(nonatomic,retain) IBOutlet UIImageView * F3;
@property(nonatomic,retain) IBOutlet UIImageView * F4;
@property(nonatomic,retain) NSMutableArray * Marcos;


@end
