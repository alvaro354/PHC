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

-(void) descargarImagenes:(NSMutableArray*)array grupo:(NSString*)grupo fotos:(int)fotos{
    
    NSLog(@"Descargando Imagenes");
    int vez=0;
    
   imagenesCargadas = [[NSMutableArray alloc]init];
    AFHTTPClient *httpClient  = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [httpClient.operationQueue setMaxConcurrentOperationCount:1] ;
    NSMutableArray *operationsArray = [NSMutableArray array];
    
  
    NSDate *myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    
    for (Usuario *userA in array) {
        while (vez<fotos) {
        
        NSString *hostStr = @"http://lanchosoftware.com:8080/PHC/descargarImagenes.php";
      
        
        NSString * user = [[NSUserDefaults standardUserDefaults]objectForKey:@"ID_usuario"];
        NSString * tokenS = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        
       
        
        
        
        NSString * usuario = [NSString stringWithFormat:@"?userID=%@",user];
        NSString * token = [NSString stringWithFormat:@"&token=%@",tokenS];
        NSString * IDURL = [NSString stringWithFormat:@"&ID=%@",userA.ID];
        NSString * vezU = [NSString stringWithFormat:@"&vez=%d",vez];
        NSString * perfil= [NSString stringWithFormat:@"&perfil=2"];
        NSString * date = [NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
     
        hostStr=[hostStr stringByAppendingString:usuario];
        hostStr=[hostStr stringByAppendingString:token];
        hostStr=[hostStr stringByAppendingString:IDURL];
         hostStr=[hostStr stringByAppendingString:perfil];
        hostStr=[hostStr stringByAppendingString:date];
         hostStr=[hostStr stringByAppendingString:vezU];
        
        hostStr = [hostStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSURL * URL = [[NSURL alloc]initWithString:hostStr];
       NSLog(@"URL Imagen %d: %@",vez,URL);
        
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
            vez++;
        }
        
        
    }
    
    [httpClient enqueueBatchOfHTTPRequestOperations:operationsArray
                                      progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                                         
                                      } completionBlock:^(NSArray *operations) {
                                         
                                          if(Error){
                                              NSLog(@"ERROR");
                                              //[self changeSorting];
                                          }
                                          else{
                                              NSLog(@"Imagenes Descargadas: %lu", (unsigned long)[imagenesCargadas count]);
                                              
                                              NSArray* arrayObjects= [[NSArray alloc]initWithObjects:grupo,imagenesCargadas, nil];
                                              NSArray* arrayClaves= [[NSArray alloc]initWithObjects:@"grupo",@"Imagenes", nil];
                                              
                                              NSDictionary *diccionarioPasarDatos =[[NSDictionary alloc]initWithObjects:arrayObjects forKeys:arrayClaves];
                                              
                                              
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"Fotos"
                                                                                object:nil
                                                                              userInfo:diccionarioPasarDatos];
                                              
                                          
                                          }
                                          
                                       //     dispatch_group_leave(group);
                                      }];
   
    

}

-(void) descargarImagenPerfil:(NSMutableArray*)array grupo:(NSString*)grupo {
    
    
    
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
       // NSString * vezU = [NSString stringWithFormat:@"&vez=%@",vez];
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
       // hostStr=[hostStr stringByAppendingString:vezU];
        
        hostStr = [hostStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSURL * URL = [[NSURL alloc]initWithString:hostStr];
        NSLog(@"URL : %@",URL);
        
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
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"ImagenesPerfilCargadas"
                                                                                                      object:nil
                                                                                                    userInfo:diccionarioPasarDatos];
                                              }
                                              
                                          }
                                          
                                          //     dispatch_group_leave(group);
                                      }];
    
    
    
}



-(void)subirImagen:(UIImage*)imagen perfil:(int)perfil{
    
    
    
    
    
    NSLog(@"Enviando");
    __block NSData * returnData = [[NSData alloc]init];
    NSString *_key = @"alvarol2611995";
    
    NSDate *myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    NSDateFormatter *dma = [NSDateFormatter new];
    NSDateFormatter *hms = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    [dma setDateFormat:@"dd-MM-yyyy"];
    [hms setDateFormat:@"hh:mm:ss"];
    
    
    
    
    _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
    NSLog(@" %@ date",[hms stringFromDate:myDate]);
    StringEncryption *crypto = [[StringEncryption alloc] init] ;
    
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ID_usuario"];
    NSData *imageData = UIImageJPEGRepresentation(imagen, 0.5);
    
    
	CCOptions padding = kCCOptionECBMode;
	NSData *encryptedData = [crypto encrypt:imageData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
    
    NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
	/*NSData *decryptedData = [crypto decrypt:encryptedData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
     
     NSLog(@"decrypted data in dex: %@", decryptedData);
     NSString *str = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
     
     NSLog(@"decrypted data string for export: %@",str);
     */
    
    
    
    NSData* imagenD=[[encryptedData base64EncodingWithLineLength:0] dataUsingEncoding:[NSString defaultCStringEncoding] ] ;
    
    
    NSString *post =[NSString stringWithFormat:@"id=%@",usuarioID];
    NSString *post2 =[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
    NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
    NSString *post4=[NSString stringWithFormat:@"&hora=%@",[hms stringFromDate:myDate]];
    NSString *post5=[NSString stringWithFormat:@"&token=%@",tokenID];
    NSString *post6=[NSString stringWithFormat:@"&perfil=%d",perfil];
    NSString *post7=[NSString stringWithFormat:@"&altura=320"];
    NSString *urlString= @"http://lanchosoftware.com:8080/PHC/subirImagen.php?";
    // NSString *urlString= @"http://lanchosoftware.es/app/imagenperfil.php?";
    urlString = [urlString stringByAppendingString:post];
    urlString = [urlString stringByAppendingString:post2];
    urlString = [urlString stringByAppendingString:post3];
    urlString = [urlString stringByAppendingString:post4];
    urlString = [urlString stringByAppendingString:post5];
    urlString = [urlString stringByAppendingString:post6];
    urlString = [urlString stringByAppendingString:post7];
    
     NSLog(@"URL de envio: %@", urlString);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"imagename.jpg\"\r\n",index] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imagenD]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSOperationQueue *cola = [NSOperationQueue new];
    // now lets make the connection to the web
    
  
    
    [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             if ( [returnString isEqualToString:@"Yes"]) {
                 UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"OK" message:@"Foto Subida"
                                                                       delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                 [alertsuccess show];
             }
             else{
                 
                 UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"OK" message:@"Error"
                                                                       delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                 [alertsuccess show];
             }
             returnData=[[NSData alloc]initWithData:data];
             
             NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
             NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             NSString* string = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
             
             
             NSString* Path = [string stringByAppendingPathComponent:@"Perfil"];
             
             NSString* dataPath2 = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"idF=%@.vez=0.perfil=1",usuarioID]];
             
             
             [[NSFileManager defaultManager] removeItemAtPath:dataPath2 error:nil];
             
             
             
         }); }];
    NSLog(@"%u",[returnData length]);
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@ Resultado",returnString);
    


    
    
    
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
