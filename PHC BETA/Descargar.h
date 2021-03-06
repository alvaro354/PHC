//
//  Descargar.h
//  LoEncontre
//
//  Created by Alvaro Lancho on 25/11/13.
//  Copyright (c) 2013 Lancho Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+AESCrypt.h"
#import <Security/Security.h>
#import "MBProgressHUD.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "SBJson.h"
#import "AFHTTPClient.h"
#import "AFImageRequestOperation.h"
#import "Usuario.h"
#import "Imagen.h"

@interface Descargar : NSObject{
    
    
    BOOL Error;
    NSMutableArray* imagenesCargadas;
    NSMutableArray* urlsTemp;
    NSString* grupoTmp;
   
   
}


-(void) descargarDeAmigos:(NSString*)ID completationBlock:(void (^)(NSMutableArray * amigos))success;
-(NSMutableArray*)ObtenerArray;
-(void) guardarDatos:(NSMutableArray*)arrayP grupo:(NSString*)grupoP;
-(void)subirImagen:(UIImage*)imagen perfil:(int)perfil;
-(void) descargarImagenPerfil:(NSMutableArray*)array grupo:(NSString*)grupo completationBlock:(void (^)(NSMutableArray * imagenesDescargadas))success;
-(void) descargarImagenes:(NSMutableArray*)array grupo:(NSString*)grupo fotos:(int)fotos completationBlock:(void (^)( NSMutableArray* imagenesDescargadas))success;

@end
