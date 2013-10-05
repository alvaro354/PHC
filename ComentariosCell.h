//
//  ComentariosCell.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 29/09/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mensajes.h"
#import <QuartzCore/QuartzCore.h>

@interface ComentariosCell : UITableViewCell{
    
    IBOutlet UILabel * nombre;
    IBOutlet UILabel * fecha;
    IBOutlet UILabel * texto;
   
    
}
@property (nonatomic,retain)UIImageView * imagen;
+ (CGSize)sizeForText:(NSString*)text;
- (void)setMessage:(Mensajes*)message image:(UIImage*)image;
- (void)setFoto:(UIImage*)image;

@end
