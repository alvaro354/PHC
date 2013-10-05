//
//  Usuario.m
//  Location
//
//  Created by Alvaro Lancho on 22/07/12.
//  Copyright (c) 2012 Burgo Ventanas I S.L.U. All rights reserved.
//

#import "Usuario.h"

@implementation Usuario
@synthesize usuario, latitude,longitude,imagen,Estado,posicion,token,ID,XML,mensajes,URLimagen;
-(void)encodeWithCoder:(NSCoder *)encoder
{

    [encoder encodeObject:usuario forKey:@"usuario"];
    [encoder encodeObject:latitude forKey:@"latitude"];
    [encoder encodeObject:longitude forKey:@"longitude"];
    [encoder encodeObject:imagen forKey:@"imagen"];
    [encoder encodeObject:Estado forKey:@"Estado"];
    [encoder encodeObject:posicion forKey:@"posicion"];
    [encoder encodeObject:token forKey:@"token"];
    [encoder encodeObject:ID forKey:@"ID"];
    [encoder encodeObject:XML forKey:@"XML"];
    [encoder encodeObject:mensajes forKey:@"mensajes"];
      [encoder encodeObject:URLimagen forKey:@"URLimagen"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
   
    usuario = [decoder decodeObjectForKey:@"usuario"];
    latitude = [decoder decodeObjectForKey:@"latitude"];
    longitude = [decoder decodeObjectForKey:@"longitude"];
    Estado = [decoder decodeObjectForKey:@"Estado"];
    imagen = [decoder decodeObjectForKey:@"imagen"];
    posicion = [decoder decodeObjectForKey:@"posicion"];
    token = [decoder decodeObjectForKey:@"token"];
    ID = [decoder decodeObjectForKey:@"ID"];
        XML = [decoder decodeObjectForKey:@"XML"];
    mensajes= [decoder decodeObjectForKey:@"mensajes"];
    URLimagen = [decoder decodeObjectForKey:@"URLimagen"];
    
    return self;
}
@end
