//
//  Dia.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 07/11/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "Dia.h"

@implementation Dia

@synthesize DiaSemana,Horas;

-(id)init{
    NSLog(@"INICIADO");
    Horas=[[NSMutableArray alloc]init];
    for (int i =0; i<24; i++) {
        NSMutableArray* array= [[NSMutableArray alloc]init];
        [Horas addObject:array];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:DiaSemana forKey:@"DiaSemana"];
    [encoder encodeObject:Horas forKey:@"Horas"];

}

-(id)initWithCoder:(NSCoder *)decoder
{
    DiaSemana = [decoder decodeObjectForKey:@"DiaSemana"];
    Horas = [decoder decodeObjectForKey:@"Horas"];

    
    
    return self;
}






@end
