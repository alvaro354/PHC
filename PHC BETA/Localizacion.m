//
//  Localizacion.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 31/10/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "Localizacion.h"

@implementation Localizacion

@synthesize Lugar, latitude,longitude,hora,tiempo;
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:hora forKey:@"hora"];
    [encoder encodeObject:Lugar forKey:@"lugar"];
    [encoder encodeFloat:latitude forKey:@"latitude"];
    [encoder encodeFloat:longitude forKey:@"longitude"];
    [encoder encodeFloat:tiempo forKey:@"tiempo"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
      hora = [decoder decodeObjectForKey:@"hora"];
    Lugar = [decoder decodeObjectForKey:@"lugar"];
    latitude = [decoder decodeFloatForKey: @"latitude"];
    longitude = [decoder decodeFloatForKey: @"longitude"];
    tiempo = [decoder decodeFloatForKey:@"tiempo"];
 
    
    return self;
}


@end
