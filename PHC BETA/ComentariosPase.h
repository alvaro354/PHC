//
//  MensajesParse.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 20/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mensajes.h"
#import "GDataXMLNode.h"
#import "SBJson.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "Mensajes.h"
#import "Imagen.h"


@interface ComentariosPase : NSObject   <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLConnectionDownloadDelegate>
{
    
    NSString *_key;
    NSString *textoS;
    NSString *IDMS;
    NSString *privadoS;
    NSString *userS;
    Mensajes *mensaje;
    NSMutableArray * arraymensajes;
    NSData *xmlData;
    BOOL acabado;
    BOOL existe;
    BOOL enviar;
    BOOL Preprocesar;
    
    int total;
    int parcial;
    int Utotal;
    int Uparcial;
    NSMutableData *returnData;
    NSMutableArray *Users;
    Imagen *imagen;
    NSString *stringRespuesta;
    NSMutableArray * arrayGuardado;
}


-(BOOL *)EnviarComentarioIDM:(NSString *)IDM usuario:(NSString *)userE privado:(NSString *)privado texto:(NSString *)texto;
-(BOOL *)descargarComentarioIDM:(NSString *)IDM usuario:(NSString *)userE privado:(NSString*)privado perfil:(NSString*)perfil;

- (void)saveData:(NSData *)datos;
-(void) uploadImage:(NSData *)XML;

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;

@end
