//
//  Mensajes.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 20/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mensajes : NSObject   <NSCoding>
@property(nonatomic, strong) NSString *IDusuario;
@property(nonatomic, strong) NSString *ID;
@property(nonatomic, strong) NSString *Fecha;
@property(nonatomic, strong) NSString *Texto;
@property(nonatomic, strong) NSString *sender;
@property (nonatomic, assign) CGSize bubbleSize;

@end
