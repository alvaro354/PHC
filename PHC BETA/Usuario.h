//
//  Usuario.h
//  Location
//
//  Created by Alvaro Lancho on 22/07/12.
//  Copyright (c) 2012 Burgo Ventanas I S.L.U. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mensajes.h"

@interface Usuario : NSObject <NSCoding>
@property(nonatomic, retain) NSString *usuario;
@property(nonatomic, retain) NSString *longitude;
@property(nonatomic, retain) NSString *latitude;
@property(nonatomic, retain) UIImage *imagen;
@property(nonatomic, retain) NSString *URLimagen;
@property(nonatomic, retain) NSString *Estado;
@property(nonatomic, retain) NSString *posicion;
@property(nonatomic, retain) NSString *token;
@property(nonatomic, retain) NSString *ID;
@property(nonatomic, retain) NSString *XML;
@property(nonatomic, retain) NSMutableArray *mensajes;

@end
