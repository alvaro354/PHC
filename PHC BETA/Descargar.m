//
//  Descargar.m
//  LoEncontre
//
//  Created by Alvaro Lancho on 25/11/13.
//  Copyright (c) 2013 Lancho Software. All rights reserved.
//

#import "Descargar.h"

@implementation Descargar

-(void) descargarDeAmigos:(NSString*)ID{
    
     __block NSMutableArray * amigos = [[NSMutableArray alloc]init];

   __block Usuario * usuario;
   
    StringEncryption *crypto = [[StringEncryption alloc] init] ;
    
    NSLog(@"%@ UsuarioID",ID);
    NSLog(@"Obteniendo datos");
    NSDate *myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSLog(@"%@ tokenID",tokenID);
    NSString *post5=[NSString stringWithFormat:@"&token=%@",tokenID];
    
    NSString *post =[NSString stringWithFormat:@"id=%@",ID];
    NSString *post2=[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
    
    NSString *hostStr = @"http://lanchosoftware.com:8080/amigos.php?";
    hostStr = [hostStr stringByAppendingString:post];
    hostStr = [hostStr stringByAppendingString:post2];
    hostStr = [hostStr stringByAppendingString:post5];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSString *_key = @"alvarol2611995";
    
    NSLog(@"URL: %@",hostStr);
    
    _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:hostStr]];
    
    NSOperationQueue *cola = [NSOperationQueue new];
    // now lets make the connection to the web
    
    [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *datas, NSError *error)
     {
         dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
         dispatch_async(myQueue, ^{
             CCOptions padding = kCCOptionECBMode;
             NSString *string = [[NSString alloc] initWithData:datas encoding:NSASCIIStringEncoding];
             NSData *_secretData = [NSData dataWithBase64EncodedString:string];
             
             NSData *encryptedData = [crypto decrypt:_secretData  key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
             NSString* newStr = [[NSString alloc]initWithData:encryptedData encoding:NSASCIIStringEncoding];
             const char *convert = [newStr UTF8String];
             NSString *responseString = [NSString stringWithUTF8String:convert];
             
             
             NSArray *returned = [parser objectWithString:responseString error:nil];
             NSMutableArray *array = [[NSMutableArray alloc]init];
             
             NSLog(@"%@",error);
             NSMutableArray *mmutable = [NSMutableArray array];
             for (NSDictionary *dict in returned){
                 
                 NSLog(@"loo %@ %@", [dict objectForKey:@"usuario"], dict);
                 usuario = [[Usuario alloc] init];
                 [usuario setUsuario:[dict objectForKey:@"usuario"]];
                 [usuario setID:[dict objectForKey:@"id_Usuario"]];
                 
                 [mmutable addObject:usuario];
             }
             
          
             array = mmutable;
             NSMutableArray * nombres = [[NSMutableArray alloc]init];
             
             
             for (Usuario *usuario in array) {
                 [nombres addObject:usuario.usuario];
             }
             
             NSSortDescriptor *orden = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
             NSArray *arrayOrdenado = [nombres sortedArrayUsingDescriptors:[NSArray arrayWithObject:orden]];
             
             for (NSString *nombre in arrayOrdenado) {
                 for (Usuario* usuario in array) {
                     if ([usuario.usuario isEqualToString:nombre]) {
                         [amigos addObject:usuario];
                     }
                 }
                 
             }
             
             NSArray* arrayObjects= [[NSArray alloc]initWithObjects:amigos, nil];
             NSArray* arrayClaves= [[NSArray alloc]initWithObjects:@"Amigos", nil];
             
             NSDictionary *diccionarioPasarDatos =[[NSDictionary alloc]initWithObjects:arrayObjects forKeys:arrayClaves];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"AmigosCargados"
                                                                 object:nil
                                                               userInfo:diccionarioPasarDatos];
             [array removeAllObjects];
        
             
         });  }];
    

 

   
    
}

-(void) descargarImagenes:(NSMutableArray*)array grupo:(NSString*)grupo vez:(NSString*)vez{
    
 
    
   imagenesCargadas = [[NSMutableArray alloc]init];
    AFHTTPClient *httpClient  = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [httpClient.operationQueue setMaxConcurrentOperationCount:1] ;
    NSMutableArray *operationsArray = [NSMutableArray array];
    
  
    NSDate *myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    
    for (Usuario *userA in array) {
        
        
        NSString *hostStr = @"http://lanchosoftware.com:8080/PHC/descargarImagenes.php";
      
        
        NSString * user = [[NSUserDefaults standardUserDefaults]objectForKey:@"ID_usuario"];
        NSString * tokenS = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        
       
        
        
        
        NSString * usuario = [NSString stringWithFormat:@"?userID=%@",user];
        NSString * token = [NSString stringWithFormat:@"&token=%@",tokenS];
        NSString * IDURL = [NSString stringWithFormat:@"&ID=%@",userA.ID];
        NSString * vezU = [NSString stringWithFormat:@"&vez=%@",vez];
        NSString * perfil;
        NSString * date = [NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
        if ([grupo isEqualToString:@"Perfil"]) {
            perfil= [NSString stringWithFormat:@"&perfil=1"];
        }
        else if ([grupo isEqualToString:@"Amigos"]){
             perfil= [NSString stringWithFormat:@"&perfil=2"];
        }
       
        
        
        
        
        
        hostStr=[hostStr stringByAppendingString:usuario];
        hostStr=[hostStr stringByAppendingString:token];
        hostStr=[hostStr stringByAppendingString:IDURL];
         hostStr=[hostStr stringByAppendingString:perfil];
        hostStr=[hostStr stringByAppendingString:date];
         hostStr=[hostStr stringByAppendingString:vezU];
        
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
                                         
                                      } completionBlock:^(NSArray *operations) {
                                         
                                          if(Error){
                                              //[self changeSorting];
                                          }
                                          else{
                                              NSLog(@"Imagenes: %lu", (unsigned long)[imagenesCargadas count]);
                                              
                                              NSArray* arrayObjects= [[NSArray alloc]initWithObjects:grupo,imagenesCargadas, nil];
                                              NSArray* arrayClaves= [[NSArray alloc]initWithObjects:@"grupo",@"Imagenes", nil];
                                              
                                              NSDictionary *diccionarioPasarDatos =[[NSDictionary alloc]initWithObjects:arrayObjects forKeys:arrayClaves];
                                              
                                              if ([grupo isEqualToString:@"Perfil"]) {
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"Perfil"
                                                                                                      object:nil
                                                                                                    userInfo:diccionarioPasarDatos];
                                              }
                                              else if ([grupo isEqualToString:@"Amigos"]){
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"ImagenesCargadas"
                                                                                object:nil
                                                                              userInfo:diccionarioPasarDatos];
                                              }
                                          
                                          }
                                          
                                       //     dispatch_group_leave(group);
                                      }];
   
    

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
