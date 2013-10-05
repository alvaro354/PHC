//
//  ImagenAsync.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 08/06/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "ImagenAsync.h"

@implementation ImagenAsync
@synthesize imagen;

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:imagen forKey:@"ID"];

}

-(id)initWithCoder:(NSCoder *)decoder
{
    imagen = [decoder decodeObjectForKey:@"ID"];

    
    return self;
}
@end

