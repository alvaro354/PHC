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

@interface Descargar : NSObject{
    BOOL Error;
    NSMutableArray* imagenesCargadas;
   
   
}


-(void) descargarDeAmigos:(NSString*)ID;
-(void) descargarImagenes:(NSMutableArray*)array grupo:(NSString*)grupo vez:(NSString*)vez;
-(NSMutableArray*)ObtenerArray;
-(void) guardarDatos:(NSMutableArray*)arrayP grupo:(NSString*)grupoP;

@end
