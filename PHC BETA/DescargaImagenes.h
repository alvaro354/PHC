//
//  DescargaImagenes.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 16/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Imagen.h"
#import "SBJson.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"


@interface DescargaImagenes : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLConnectionDownloadDelegate>

{
    NSString *cacheDirectoryName;
    NSString * nombreImagen;
    NSString *IDFCache;
    NSString *_key;
    NSString *UIDS;
    Imagen * imagen;
    BOOL cache;
    NSMutableArray *total;
    NSMutableDictionary *receivedData;
    int vezd;
}

-(void)cache:(Imagen*)img;
-(void)descargarImagenIDF:(NSString *)IDF perfil:(NSString *)perfil  vez:(NSString *)vez UID:(NSString *)UID;
-(NSMutableArray *) devolverArray;
-(void)eliminaObjetos;

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;


@end


