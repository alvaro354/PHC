//
//  Cell.m
//  Location
//
//  Created by Alvaro Lancho on 22/07/12.
//  Copyright (c) 2012 Burgo Ventanas I S.L.U. All rights reserved.
//

#import "Cell.h"

@implementation Cell
@synthesize name, image, actividad, indicador;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        name = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 90, 80, 20)];
        name.textAlignment= UITextAlignmentCenter;
        [self.contentView addSubview:name];

    
        image = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 83, 82)];
        image.clipsToBounds=YES;
        image.layer.cornerRadius = 8.0;
        //image.layer.masksToBounds=YES;
        image.layer.borderWidth=1;
        image.layer.borderColor=[UIColor blackColor].CGColor;
        image.layer.shadowOffset = CGSizeMake(5.0, 5.0);
        image.layer.shadowColor = [UIColor blackColor].CGColor;
        image.layer.shadowRadius = 5;
        [image.layer setShadowOpacity:0.8];
        image.layer.shadowPath =
        [UIBezierPath bezierPathWithRect:image.layer.bounds].CGPath;
        
        if (actividad) {
             NSLog(@"Avitivdad CELDA");
            indicador = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            indicador.frame= CGRectMake(image.center.x, image.center.y ,50, 50);
            indicador.center=image.center;
           
            [image addSubview:indicador];
            [indicador startAnimating];
        }
        else{
            [indicador stopAnimating];
            [indicador removeFromSuperview];
            
        }
        [self.contentView addSubview:image];
        [self.contentView bringSubviewToFront:image];
        
        
    }
    return self;
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
