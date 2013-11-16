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
-(void) iniciarConUrl:(NSURL*)url{
    NSString *fileName = [url absoluteString];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"?" withString:@"&"];
    
    
    /*
    
    NSArray *array = [fileName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]];
    for (NSString * st in array) {
        //   NSLog(@"%@",st);
        if ([st rangeOfString:@"idF"].location != NSNotFound) {
            self.idf= [NSString stringWithString:st];
        }
        if ([st rangeOfString:@"vez"].location != NSNotFound) {
            self.vez= [NSString stringWithString:st];
        }
        if ([st rangeOfString:@"perfil"].location != NSNotFound) {
            self.perfil= [NSString stringWithString:st];
        }
    }
    
    
*/
    
    
    
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
