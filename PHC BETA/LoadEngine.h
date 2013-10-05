//
//  LoadEngine.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 27/03/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "MKNetworkEngine.h"


@interface LoadEngine : MKNetworkEngine



typedef void (^ImagesResponseBlock)(NSData* datas);

-(MKNetworkOperation*) imagesForID:(NSString*)ID completionHandler:(ImagesResponseBlock) imageURLBlock errorHandler:(MKNKErrorBlock) errorBlock;

@end

/*
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
 [request setURL:[NSURL URLWithString:hostStr]];
 
 
 NSString *string = [[NSString alloc] initWithData:dataURL encoding:NSASCIIStringEncoding];
 NSData *_secretData = [NSData dataWithBase64EncodedString:string];
 
 NSData *encryptedData = [crypto decrypt:_secretData  key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
 
 
 Usuarios.imagen= [[UIImage alloc] initWithData:encryptedData];
 
 NSLog(@"%f,%f",Usuarios.imagen.size.width,Usuarios.imagen.size.height);
 
 
 NSOperationQueue *cola = [NSOperationQueue new];
 // now lets make the connection to the web
 
 [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *datas, NSError *error)
 {
 CCOptions padding = kCCOptionECBMode;
 NSString *string = [[NSString alloc] initWithData:datas encoding:NSASCIIStringEncoding];
 NSData *_secretData = [NSData dataWithBase64EncodedString:string];
 
 NSData *encryptedData = [crypto decrypt:_secretData  key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
 
 
 Usuarios.imagen= [[UIImage alloc] initWithData:encryptedData];
 
 NSLog(@"%f,%f",Usuarios.imagen.size.width,Usuarios.imagen.size.height);
 
 [collection reloadData];
 
 }];
 */