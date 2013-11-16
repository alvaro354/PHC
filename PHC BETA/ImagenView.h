//
//  ImagenView.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 03/11/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagenView : UIImageView <NSCopying>


-(void) iniciarConUrl:(NSURL*)url;
@property(nonatomic,retain) NSString * url;
@property(nonatomic,retain) NSString * ID;
@property(nonatomic,retain) NSString * usuarioID;
@property(nonatomic,retain) NSString * usuario;
@property(nonatomic,retain) NSString * perfil;

@end
