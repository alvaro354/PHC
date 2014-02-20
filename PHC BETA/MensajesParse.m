//
//  MensajesParse.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 20/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "MensajesParse.h"

@implementation MensajesParse


- (void)saveData:(NSData *)datos{
    
    GDataXMLDocument *document;
    
        NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
  NSString * usuaro= [[NSUserDefaults standardUserDefaults] stringForKey:@"usuario"];
    NSDate* myDate = [NSDate date];
    NSDateFormatter *dma = [NSDateFormatter new];
  
    [dma setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    GDataXMLElement *Mensajes = [GDataXMLNode elementWithName:@"Mensajes"];
    GDataXMLElement *Mensaje = [GDataXMLNode elementWithName:@"Mensaje"];
    
    GDataXMLElement *IDUsuario =
    [GDataXMLNode elementWithName:@"IDUsuario"
                      stringValue:usuarioID];
    
    GDataXMLElement *Texto =
    [GDataXMLNode elementWithName:@"Texto"
                      stringValue:textoS];
    
    GDataXMLElement * Fecha =
    [GDataXMLNode elementWithName:@"Fecha"
                      stringValue:[dma stringFromDate:myDate]];
    GDataXMLElement * Sender =
    [GDataXMLNode elementWithName:@"Sender"
                      stringValue:usuaro];
    


    
    [Mensaje addChild:IDUsuario];
       [Mensaje addChild:Texto];
       [Mensaje addChild:Fecha];
    [Mensaje addChild:Sender];
    [Mensajes addChild:Mensaje];
    if(datos == nil){
     document = [[GDataXMLDocument alloc]
                                      initWithRootElement:Mensajes];
    }
    
    if(datos != nil){
        document = [[GDataXMLDocument alloc]initWithData:datos options:0 error:nil];
        [document.rootElement addChild:Mensaje];
    }
 
        
  NSData * Data = document.XMLData;
 
    NSString* newStr = [[NSString alloc]initWithData:Data encoding:NSASCIIStringEncoding];
    
    
      NSLog(@"XML: %@ ",newStr);
    
    const char *convert = [newStr UTF8String];
    NSString *responseString = [NSString stringWithUTF8String:convert];
    
    xmlData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    [self uploadImage:xmlData];
    //NSString *filePath = [self dataFilePath:TRUE];
 //   NSLog(@"Saving data to %@...", filePath);
    //[xmlData writeToFile:filePath atomically:YES];
}
-(BOOL *)descargarMensajeIDM:(NSString *)IDM usuario:(NSString *)userE  privado:(NSString *)privado perfil:(NSString*)perfil{
    
    IDMS=IDM;
    enviar=NO;
    if (userE !=nil) {
    userS=userE;
    }
    privadoS=privado;
    xmlData=nil;
   
    parcial =0;
    enviar=NO;
    
    NSData *datos = [[NSUserDefaults standardUserDefaults] objectForKey:@"DatosGuardados"];
    arrayGuardado = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
    
    for (int w =0; w<[arrayGuardado count];w++) {
        // NSLog(@"%@ %@", us.ID,user.ID);
        Usuario * us = [arrayGuardado objectAtIndex:w];
   
        
            Usuario * TempUser =[[Usuario alloc]init];
            TempUser=us;
        [TempUser.mensajes removeAllObjects];

            [arrayGuardado replaceObjectAtIndex:w withObject:TempUser];
        
    }
    NSData *da = [NSKeyedArchiver archivedDataWithRootObject:arrayGuardado];
    [[NSUserDefaults standardUserDefaults] setObject:da forKey:@"DatosGuardados"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
        NSLog(@"%@ ID",IDM);
        NSDate* myDate = [NSDate date];
        NSDateFormatter *df = [NSDateFormatter new];
        NSDateFormatter *dma = [NSDateFormatter new];
        [df setDateFormat:@"dd"];
        [dma setDateFormat:@"dd-mm-yyyy"];
        
        _key = @"alvarol2611995";
        
        
        _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
        
        NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
        
        NSString *post2=[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
        NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
        NSString *post4=[NSString stringWithFormat:@"&token=%@",tokenID];
        NSString *post5 =[NSString stringWithFormat:@"&id=%@",usuarioID];
        NSString *post6 =[NSString stringWithFormat:@"&privado=%@",privado];
            NSString *post7 =[NSString stringWithFormat:@"&perfil=%@",perfil];
        NSString *post =[NSString stringWithFormat:@"idF=%@",IDM];
        
        NSString *hostStr = @"http://lanchosoftware.com:8080/PHC/descargarXML.php?";
        hostStr = [hostStr stringByAppendingString:post];
        hostStr = [hostStr stringByAppendingString:post2];
        hostStr = [hostStr stringByAppendingString:post3];
        hostStr = [hostStr stringByAppendingString:post4];
        hostStr = [hostStr stringByAppendingString:post5];
        hostStr = [hostStr stringByAppendingString:post6];
 hostStr = [hostStr stringByAppendingString:post7];
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:hostStr]];
        
        NSLog(@"%@ URL Mnesajes Engine",hostStr);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        
        [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [_connection start];
    });
    int i=0;
    while (i == 0) {
        if (total == parcial) {
            total++;
            i++;
            return YES;
        }
        else{
            i=0;
        }
     
        }
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    
    
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"%lu Data Leght",(unsigned long)[_data length]);
    
    [self performSelectorInBackground:@selector(procesar:) withObject:_data ];
    self.connection = nil;
    self.data = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.connection = nil;
    self.data = nil;
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

-(BOOL *)EnviarMensajeIDM:(NSString *)IDM usuario:(NSString *)userE privado:(NSString *)privado texto:(NSString *)texto{
    IDMS=IDM;
    privadoS=privado;
    textoS=texto;
        xmlData=nil;
    acabado = NO;
    if (userE !=nil) {
        userS=userE;
    }
    enviar =YES;
    NSLog(@"%@ ID",IDM);
    NSDate* myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    NSDateFormatter *dma = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    [dma setDateFormat:@"dd-mm-yyyy"];
    
    _key = @"alvarol2611995";
    
    
    _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
    
    NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
    
    NSString *post2=[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
    NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
    NSString *post4=[NSString stringWithFormat:@"&token=%@",tokenID];
    NSString *post5 =[NSString stringWithFormat:@"&id=%@",usuarioID];
    NSString *post6 =[NSString stringWithFormat:@"&privado=%@",privado];
    NSString *post7 =[NSString stringWithFormat:@"&perfil=0"];
    NSString *post =[NSString stringWithFormat:@"idF=%@",IDM];
    
    NSString *hostStr = @"http://lanchosoftware.com:8080/PHC/descargarXML.php?";
    hostStr = [hostStr stringByAppendingString:post];
    hostStr = [hostStr stringByAppendingString:post2];
    hostStr = [hostStr stringByAppendingString:post3];
    hostStr = [hostStr stringByAppendingString:post4];
    hostStr = [hostStr stringByAppendingString:post5];
    hostStr = [hostStr stringByAppendingString:post6];
    hostStr = [hostStr stringByAppendingString:post7];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:hostStr]];
    
    NSLog(@"%@ URL Mnesajes Engine",hostStr);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        
        [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [_connection start];
    });
    
    int i=0;
    while (i == 0) {
        if (acabado == YES) {
            if (existe == NO) {
                return NO;
                
            }
            else{
                
                return YES;
            }
          
            
        }
        else{
            i++;
        }
        
    }

    
    
}

- (void)procesar:(NSData *)data{


    // NSLog(@"%@ String",responseString);
    
     NSString* newStr = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    
    if ([newStr isEqualToString:@"No"]) {
        if ( enviar==NO) {
            existe=NO;
             Preprocesar=NO;
             [self Parsear:data];
        }
        else{
            NSLog(@"Nuevo XML");
         Preprocesar=NO;
        existe=NO;
        [self saveData:nil];
        }
        
    }
    else{
        if ( enviar==NO) {
            NSLog(@"Parsear");
                 existe=YES;
         Preprocesar=NO;
            [self Parsear:data];
            
        }
        else{
            
        existe=YES;
            Preprocesar=YES;
         [self Parsear:data];
        }
    
    }

    
    // NSLog(@"%@",error);
    


    
    
    
}

-(void) uploadImage:(NSData *)XML
{
    NSLog(@"Enviando");
   _key = @"alvarol2611995";
    
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
    
    CCOptions padding = kCCOptionECBMode;
    
    NSMutableData*datat = [[NSMutableData alloc] initWithData:XML];
    
     NSLog(@"%lu Lenght1",(unsigned long)[datat length]);

    while ([datat length]%128) {
 
        NSString *string = [[NSString alloc] initWithFormat:@" "];
NSData *newData = [string dataUsingEncoding:NSUTF8StringEncoding];
        [datat appendData:newData];
        
    }
 
 
    
    NSLog(@"%lu Lenght",(unsigned long)[datat length]);
    
	NSData *encryptedData = [crypto encrypt:datat key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
    
      NSData* xmlD=[[encryptedData base64EncodingWithLineLength:0] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
   // hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
   // hud.labelText = NSLocalizedString(@"Cargando", @"");
    
	
    NSString* newStr2 = [[NSString alloc]initWithData:xmlD encoding:NSASCIIStringEncoding];
    const char *convert2 = [newStr2 UTF8String];
    NSString *responseString2 = [NSString stringWithUTF8String:convert2];
  
            
            
            //NSData*imagenD = [NSData dataWithBase64EncodedString:[dict objectForKey:@"imagen"]];
            
            NSData *_secretData2= [NSData dataWithBase64EncodedString:responseString2];
            
            NSData *encryptedData2 = [crypto decrypt:_secretData2  key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
            //NSLog(@"Data: %d", [encryptedData length]);
            
            NSString *x = [[NSString alloc ] initWithData:encryptedData2 encoding:NSASCIIStringEncoding];
    //NSLog(@"%@ Mnesaje",x);
    
    
    
    
    
	/*NSData *decryptedData = [crypto decrypt:encryptedData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
     
     NSLog(@"decrypted data in dex: %@", decryptedData);
     NSString *str = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
     
     NSLog(@"decrypted data string for export: %@",str);
     */
  
    
    NSString *post =[NSString stringWithFormat:@"id=%@",usuarioID];
    NSString *post2 =[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
    NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
    NSString *post4=[NSString stringWithFormat:@"&hora=%@",[hms stringFromDate:myDate]];
    NSString *post5=[NSString stringWithFormat:@"&token=%@",tokenID];
     NSString *post6=[NSString stringWithFormat:@"&idf=%@",IDMS];
    NSString *post7=[NSString stringWithFormat:@"&privado=%@",privadoS];
    
    NSString *urlString= @"http://lanchosoftware.com:8080/PHC/subirXML.php?";
    // NSString *urlString= @"http://lanchosoftware.es/app/imagenperfil.php?";
    urlString = [urlString stringByAppendingString:post];
    urlString = [urlString stringByAppendingString:post2];
    urlString = [urlString stringByAppendingString:post3];
    urlString = [urlString stringByAppendingString:post4];
    urlString = [urlString stringByAppendingString:post5];
    urlString = [urlString stringByAppendingString:post6];
    urlString = [urlString stringByAppendingString:post7];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
 
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"mensajes\"; filename=\"mensajes.xml\"\r\n",index] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:xmlD];
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
       //  [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             
          
         if ( [returnString isEqualToString:@"OK"]) {
           
             
             NSLog(@"Recargando");
         
         }
         else{
             //[MBProgressHUD hideHUDForView:self.view animated:YES];
             UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error"
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 //Show alert here
                 [alertsuccess show];
             });
             
             
         }
        NSLog(@"Mensaje de la Subida:%@",returnString);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Mensajes" object:self userInfo:nil];
         self->returnData=[[NSMutableData alloc]initWithData:data];
         
         });   }];
    
   // NSLog(@"%u",[returnData length]);
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
   // NSLog(@"%@ Resultado",returnString);
    
    
    
}

-(void)Parsear:(NSData *)data{
    
    NSData *datos = [[NSUserDefaults standardUserDefaults] objectForKey:@"DatosGuardados"];
    arrayGuardado = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
    
    Users = [[NSMutableArray alloc]init];
    NSError *error;
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString* newStr = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    const char *convert = [newStr UTF8String];
    NSString *responseString = [NSString stringWithUTF8String:convert];
    
    
    NSArray *returned = [parser objectWithString:responseString  error:&error];
    StringEncryption *crypto = [[StringEncryption alloc] init] ;
    //add data
    NSDate *myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    NSString * keys = @"alvarol2611995";
    keys= [keys stringByAppendingString:[df stringFromDate:myDate]];
    CCOptions padding = kCCOptionECBMode;
    // NSLog(@"%@ String",responseString);
    
    
    
    // NSLog(@"%@",error);

  //  NSLog(@"%@ Response", returned);
    
    
    if (enviar==YES) {
        for (NSDictionary *dict in returned){
            
            
            //NSData*imagenD = [NSData dataWithBase64EncodedString:[dict objectForKey:@"imagen"]];
            
            NSData *_secretData = [NSData dataWithBase64EncodedString:[dict objectForKey:@"XML"]];
            
            NSData *encryptedData = [crypto decrypt:_secretData  key:[keys dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
            //NSLog(@"Data: %d", [encryptedData length]);
            
            NSString *x = [[NSString alloc ] initWithData:encryptedData encoding:NSASCIIStringEncoding];
            
            if ([x hasPrefix:@"<"] ) {
                
              NSLog(@"No Vacio");
                NSData *datos= [x dataUsingEncoding: [NSString defaultCStringEncoding] ];
                     [self saveData:datos];
              
      
            }
            else{
                  NSLog(@"Vacio");
                 [self saveData:nil];
            }
        }

        
    }
    
    
    // NSMutableArray *mmutable = [NSMutableArray array];
    if (enviar==NO) {
    for (NSDictionary *dict in returned){
        
        
        //NSData*imagenD = [NSData dataWithBase64EncodedString:[dict objectForKey:@"imagen"]];
        
        NSData *_secretData = [NSData dataWithBase64EncodedString:[dict objectForKey:@"XML"]];
        
        NSData *encryptedData = [crypto decrypt:_secretData  key:[keys dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
        //NSLog(@"Data: %d", [encryptedData length]);
        
        NSString *x = [[NSString alloc ] initWithData:encryptedData encoding:NSASCIIStringEncoding];

        if (![x isEqualToString:@""] ) {
      
             usuario= [[Usuario alloc] init];
            [usuario setID:[dict objectForKey:@"IDF"]];
            [usuario setXML:x];
                        
        
        
          NSLog(@"%@ String",x);
         [Users addObject:usuario];
        }
    }

    parcial=0;
    total= [Users count];
    
  for (int i=0; i<[Users count]; i++) {
      Usuario *user =[ Users objectAtIndex:i];
        NSData * datos = [user.XML dataUsingEncoding:NSASCIIStringEncoding];
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc]
                                  initWithData:datos options:0 error:nil];
        NSArray *partyMembers = [document nodesForXPath:@"//Mensajes/Mensaje" error:nil];
    
    total= [partyMembers count];
    for (GDataXMLElement *partyMember in partyMembers) {
        Mensajes *mensaj = [[Mensajes alloc]init];
        
        // Name
        NSArray *IDU = [partyMember elementsForName:@"IDUsuario"];
        if (IDU.count > 0) {
            GDataXMLElement *firstName = (GDataXMLElement *) [IDU objectAtIndex:0];
            mensaj.IDusuario = firstName.stringValue;
            
        } else continue;
        
        // Level
        NSArray *texto = [partyMember elementsForName:@"Texto"];
        if (texto.count > 0) {
            GDataXMLElement *firstLevel = (GDataXMLElement *) [texto objectAtIndex:0];
            mensaj.Texto = firstLevel.stringValue;
        } else continue;
        
        // Class
        NSArray *Fecha = [partyMember elementsForName:@"Fecha"];
        if (Fecha.count > 0) {
            GDataXMLElement *firstLevel = (GDataXMLElement *) [Fecha objectAtIndex:0];
            mensaj.Fecha = firstLevel.stringValue;
        }
        NSArray *sender = [partyMember elementsForName:@"Sender"];
        if (sender.count > 0) {
            GDataXMLElement *firstLevel = (GDataXMLElement *) [sender objectAtIndex:0];
            mensaj.sender = firstLevel.stringValue;
        }
        
        for (int w =0; w<[arrayGuardado count];w++) {
             // NSLog(@"%@ %@", us.ID,user.ID);
            Usuario * us = [arrayGuardado objectAtIndex:w];
            if([us.ID isEqualToString:user.ID]){
               //  NSLog(@"%@", mensaj.Texto);
                Usuario * TempUser =[[Usuario alloc]init];
                TempUser=us;
          
                if ( TempUser.mensajes == nil || [TempUser.mensajes count] ==0 ){
                       TempUser.mensajes = [[NSMutableArray alloc] init];
                   
                }
                [TempUser.mensajes addObject:mensaj];
                
                
               
                //NSLog(@"%@ Usuario",TempUser.usuario);
             //   NSLog(@"%@ Mensaje Temp",TempUser.mensajes);
                 [arrayGuardado replaceObjectAtIndex:w withObject:TempUser];
            }
        }
        
    }
    }
    
    int u=0;
    while (u==0) {
        if (Users==nil) {
            u=0;
        }
        else{
     
            NSLog(@"Mensajes Post");
            
            NSData *datos = [NSKeyedArchiver archivedDataWithRootObject:arrayGuardado];
            [[NSUserDefaults standardUserDefaults] setObject:datos forKey:@"DatosGuardados"];
            [[NSUserDefaults standardUserDefaults]  synchronize];
            
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"Mensajes" object:self userInfo:nil];
            u++;
        }
    }
  
    //NSLog(@" %@ Array Mensajes", Users);
     //NSLog(@" %lu Array Mensajes Count", (unsigned long)[Users count]);
    
    }
    
}


@end
