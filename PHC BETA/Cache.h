//
//  Cache.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 30/08/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cache : NSObject{
    
}

-(void)obtenerRutaCache: (NSURL *) URL;
-(UIImage *)procesarDatos: (NSData *)datas;
-(NSData*)comprobarCache:(NSURL *)URL;

@property (nonatomic, strong) NSString *dataPath;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *idf;
@property (nonatomic, strong)  NSString *perfil;
@property (nonatomic, strong)  NSString *vez;
@end
