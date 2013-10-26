//
//  CeldaInvitacionesCell.h
//  Location
//
//  Created by Alvaro Lancho on 31/08/12.
//  Copyright (c) 2012 Burgo Ventanas I S.L.U. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CeldaInvitacionesCell : UITableViewCell{
}
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain)IBOutlet UIImageView *image;
@property (nonatomic, retain)IBOutlet UILabel *datos;
@property (nonatomic,retain)  NSString* sNombre;
@property (nonatomic,retain)  NSString* sUsuarioID;
@property (nonatomic,retain) IBOutlet UIButton * bPerfil;
@property (nonatomic,retain) IBOutlet UIButton * bBorrar;

@property (nonatomic)BOOL vistaSuperiorOculta;
@property (nonatomic,retain)IBOutlet UIView * viewSuperior;
@property (nonatomic,retain)IBOutlet UIView * viewInferior;

@end
