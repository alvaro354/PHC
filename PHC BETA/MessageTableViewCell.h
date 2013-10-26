//
//  MessageTableViewCell.h
//  PushChatStarter
//
//  Created by Kauserali on 28/03/13.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//
#import "Mensajes.h"
@class Mensajes;

// Table view cell that displays a Message. The message text appears in a
// speech bubble; the sender name and date are shown in a UILabel below that.
@interface MessageTableViewCell : UITableViewCell

- (void)setMessage:( Mensajes*)message;
@property (nonatomic,retain)  NSString* sNombre;
@property (nonatomic,retain)  NSString* sUsuarioID;
@property (nonatomic,retain) IBOutlet UIButton * bPerfil;
@property (nonatomic,retain) IBOutlet UIButton * bBorrar;
@property (nonatomic,retain)Mensajes * mensaje;
@property (nonatomic)BOOL vistaSuperiorOculta;
@property (nonatomic,retain)IBOutlet UIView * viewSuperior;
@property (nonatomic,retain)IBOutlet UIView * viewInferior;

@end
