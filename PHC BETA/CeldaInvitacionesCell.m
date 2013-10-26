//
//  CeldaInvitacionesCell.m
//  Location
//
//  Created by Alvaro Lancho on 31/08/12.
//  Copyright (c) 2012 Burgo Ventanas I S.L.U. All rights reserved.
//

#import "CeldaInvitacionesCell.h"

@implementation CeldaInvitacionesCell
@synthesize name, image,datos,viewSuperior,vistaSuperiorOculta,bBorrar,bPerfil,sNombre,sUsuarioID,viewInferior;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
   
        image.clipsToBounds=YES;
        image.layer.cornerRadius = 8.0;
        image.layer.borderWidth=1.5;
        image.layer.borderColor=[UIColor blackColor].CGColor;
        [self.contentView addSubview:image];
        [self reloadInputViews];
       
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
