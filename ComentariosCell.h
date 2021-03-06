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
@property (nonatomic,retain) IBOutlet UILabel * nombre;
@property (nonatomic,retain)  NSString* sNombre;
@property (nonatomic,retain)  NSString* sUsuarioID;
@property (nonatomic,retain) IBOutlet UIButton * bPerfil;
@property (nonatomic,retain) IBOutlet UIButton * bBorrar;
@property (nonatomic,retain)Mensajes * mensaje;
@property (nonatomic)BOOL vistaSuperiorOculta;
@property (nonatomic,retain)IBOutlet UIView * viewSuperior;
@property (nonatomic,retain)IBOutlet UIView * viewInferior;
+ (CGSize)sizeForText:(NSString*)text;
- (void)setMessage:(Mensajes*)message image:(UIImage*)image;
- (void)setFoto:(UIImage*)image;

@end
