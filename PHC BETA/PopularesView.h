//
//  PopularesView.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 03/11/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagenView.h"

@interface PopularesView : UITableViewCell{
    

    NSMutableArray * Imagenes;
  
}
-(void)ImagenesDe:(NSURL*)URLS;


@property(nonatomic,retain) IBOutlet ImagenView* Imagen;
@property(nonatomic)  BOOL descargado;
@property(nonatomic,retain) NSMutableArray * Marcos;


@end
