//
//  ImagenView.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 03/11/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "ImagenView.h"

@implementation ImagenView
@synthesize url;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
   ImagenView *another = [[ImagenView alloc] init];
 
    
    
    return another;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
