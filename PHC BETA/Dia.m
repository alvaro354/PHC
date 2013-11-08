//
//  Dia.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 07/11/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "Dia.h"

@implementation Dia

@synthesize DiaSemana,Lugares;

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:DiaSemana forKey:@"DiaSemana"];
    [encoder encodeObject:Lugares forKey:@"Lugares"];

}

-(id)initWithCoder:(NSCoder *)decoder
{
    DiaSemana = [decoder decodeObjectForKey:@"DiaSemana"];
    Lugares = [decoder decodeObjectForKey:@"Lugares"];

    
    
    return self;
}






@end
