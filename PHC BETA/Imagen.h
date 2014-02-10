//
//  Imagen.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 16/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Imagen : NSObject  <NSCoding>
@property(nonatomic, strong) NSString *IDusuario;
@property(nonatomic, strong) NSString *ID;
@property(nonatomic, strong) NSString *Fecha;
@property(nonatomic, strong) UIImage *imagen;
@property(nonatomic, strong) NSString *Etiquetas;
@property(nonatomic, strong) NSString *Nombre;
@property(nonatomic, strong) NSString *perfil;
@property(nonatomic, strong) NSString *publico;
@property(nonatomic, strong) NSString *vez;
@property(nonatomic, strong) NSString *altura;
@property(nonatomic, retain) NSMutableArray *comentarios;
@property(nonatomic, retain) NSString *XML;
@property(nonatomic, retain) NSString *URL;
//@property(nonatomic, strong) NSString *ID;

@end
