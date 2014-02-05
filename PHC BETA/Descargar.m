//
//  Descargar.m
//  LoEncontre
//
//  Created by Alvaro Lancho on 25/11/13.
//  Copyright (c) 2013 Lancho Software. All rights reserved.
//

#import "Descargar.h"

@implementation Descargar

-(void) descargarImagenes:(NSMutableArray*)array grupo:(NSString*)grupo{
    
    
   imagenesCargadas = [[NSMutableArray alloc]init];
    AFHTTPClient *httpClient  = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [httpClient.operationQueue setMaxConcurrentOperationCount:1] ;
    NSMutableArray *operationsArray = [NSMutableArray array];
    
  
    NSDate *myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    
    for (Usuario *userA in array) {
        
        //   NSLog(@"URL: %@", us.URLimagen);
        
        
        NSString *hostStr = @"http://lanchosoftware.com:8080/PHC/descargarImagenes.php";
        // hostStr = [hostStr stringByAppendingString:post];
        
      
        
        /*NSData *decryptedData = [crypto decrypt:encryptedData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
         
         NSLog(@"decrypted data in dex: %@", decryptedData);
         NSString *str = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
         
         NSLog(@"decrypted data string for export: %@",str);
         */
        
        //  NSLog(@"encrypted data string for export: %@",[encryptedDataCon base64EncodingWithLineLength:0]);
        
        NSString * user = [[NSUserDefaults standardUserDefaults]objectForKey:@"ID_usuario"];
        NSString * tokenS = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        
       
        
        
        
        NSString * usuario = [NSString stringWithFormat:@"?userID=%@",user];
        NSString * token = [NSString stringWithFormat:@"&token=%@",tokenS];
        NSString * IDURL = [NSString stringWithFormat:@"&ID=%@",userA.ID];
        NSString * perfil = [NSString stringWithFormat:@"&perfil=0"];
        NSString * date = [NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
       
        
        
        
        
        
        hostStr=[hostStr stringByAppendingString:usuario];
        hostStr=[hostStr stringByAppendingString:token];
        hostStr=[hostStr stringByAppendingString:IDURL];
         hostStr=[hostStr stringByAppendingString:perfil];
        hostStr=[hostStr stringByAppendingString:date];
        
        hostStr = [hostStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSURL * URL = [[NSURL alloc]initWithString:hostStr];
        NSLog(@"URL: %@",URL);
        
        AFImageRequestOperation *getImageOperation =
        [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:URL]
                                             imageProcessingBlock:nil
                                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                              //
                                                              // Save image
                                                              //
                                                              if(image != nil){
                                                                  [imagenesCargadas addObject:image];
                                                              }
                                                              else{
                                                                  Error=YES;
                                                                  NSLog(@"Image request CACHE error!");
                                                              }
                                                          }
                                                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                              if((error.domain == NSURLErrorDomain) && (error.code == NSURLErrorCancelled))
                                                                  NSLog(@"Image request cancelled!");
                                                              else
                                                                  NSLog(@"Image request error!");
                                                          }];
        
        [operationsArray addObject:getImageOperation];
        
        
        //
        // Lock user interface by pop-up dialog with process indicator and "Cancel download" button
        //
        
        
        
        
    }
    
    [httpClient enqueueBatchOfHTTPRequestOperations:operationsArray
                                      progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                                          //
                                          // Handle process indicator
                                          //
                                          //   NSLog(@"Imagenes: %@", imagenesCargadas);
                                          //  NSLog(@"Completado");
                                      } completionBlock:^(NSArray *operations) {
                                          //
                                          // Remove blocking dialog, do next tasks
                                          //+
                                          if(Error){
                                              //[self changeSorting];
                                          }
                                          else{
                                              NSLog(@"Imagenes: %lu", (unsigned long)[imagenesCargadas count]);
                                              
                                              NSArray* arrayObjects= [[NSArray alloc]initWithObjects:grupo,imagenesCargadas, nil];
                                              NSArray* arrayClaves= [[NSArray alloc]initWithObjects:@"grupo",@"Imagenes", nil];
                                              
                                              NSDictionary *diccionarioPasarDatos =[[NSDictionary alloc]initWithObjects:arrayObjects forKeys:arrayClaves];
                                              
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"ImagenesCargadas"
                                                                                object:nil
                                                                              userInfo:diccionarioPasarDatos];
                                          
                                          }
                                          
                                       //     dispatch_group_leave(group);
                                      }];
    
    
    //dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    

}
-(NSMutableArray*)ObtenerArray{
    return imagenesCargadas;
}

-(NSMutableArray*) descargarDeGrupo:(NSString*)grupo{
 
    return nil;
}



-(void) guardarDatos:(NSMutableArray*)arrayP grupo:(NSString*)grupoP{
    
    //Prueba Git 2
    
    NSData *datos = [NSKeyedArchiver archivedDataWithRootObject:arrayP];
    [[NSUserDefaults standardUserDefaults] setObject:datos forKey:grupoP];
    
}

@end
