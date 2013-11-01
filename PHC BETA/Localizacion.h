//
//  Localizacion.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 31/10/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Localizacion : NSObject

@property(nonatomic, retain) NSString *Lugar;
@property(nonatomic) float longitude;
@property(nonatomic) float latitude;
@property(nonatomic) float tiempo;
@property(nonatomic,retain) NSDateComponents *hora;

@end
