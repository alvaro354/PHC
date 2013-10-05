//
//  Mensajes.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 20/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "Mensajes.h"

@implementation Mensajes
@synthesize ID,IDusuario,Texto, Fecha,sender;
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:ID forKey:@"ID"];
    [encoder encodeObject:IDusuario forKey:@"IDusuario"];
    
    [encoder encodeObject:Texto forKey:@"Texto"];
    [encoder encodeObject:Fecha forKey:@"Fecha"];
     [encoder encodeObject:sender forKey:@"sender"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    ID = [decoder decodeObjectForKey:@"ID"];
    IDusuario = [decoder decodeObjectForKey:@"IDusuario"];
    Texto= [decoder decodeObjectForKey:@"Texto"];
    Fecha = [decoder decodeObjectForKey:@"Fecha"];
    sender = [decoder decodeObjectForKey:@"sender"];
    
    
    return self;
}
@end


