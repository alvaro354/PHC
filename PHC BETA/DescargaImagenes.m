//
//  DescargaImagenes.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 16/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "DescargaImagenes.h"





@implementation DescargaImagenes

-(id)init{
    self = [super init];
    return self;
}

-(void)descargarImagenIDF:(NSString *)IDF perfil:(NSString *)perfil vez:(NSString *)vez UID:(NSString *)UID{
   
    UIDS= UID;
    IDFCache=IDF;
    
    if (total ==nil) {
        NSLog(@"Array Iniciada");
        total=[[NSMutableArray alloc]init];
    }
    
    if ([vez isEqualToString:@""]) {
        vez = @"0";
    }
    
    
    nombreImagen= [NSString stringWithFormat:@"%@-%@-%@",IDF,vez,perfil];
    if (perfil.intValue == 1) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Perfil"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
        }//Create folder
        
        cacheDirectoryName = [dataPath stringByAppendingPathComponent:nombreImagen];
    }
    if (perfil.intValue == 0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Amigos"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
        }//Create folder
        
        cacheDirectoryName = [dataPath stringByAppendingPathComponent:nombreImagen];
    }
    
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath: cacheDirectoryName])
    {
        NSLog(@"Cache");
        NSData *codedData = [[NSData alloc] initWithContentsOfFile:cacheDirectoryName];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
        imagen = [unarchiver decodeObjectForKey:nombreImagen]; // this is the cached image
        if (imagen != nil) {
        [total addObject:imagen];
         vezd++;
        }
        else{
            NSLog(@"Error Cache Imagen");
        }
      if ( [UIDS intValue]== [total count]) {
            NSLog(@"UIDS %@",UIDS);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Fin" object:nil];
        }
        cache=YES;
    }
    else
    {
        cache=NO;
        
        NSLog(@"%@ ID",IDF);
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
        NSString *post6 =[NSString stringWithFormat:@"&perfil=%@",perfil];
        NSString *post7 =[NSString stringWithFormat:@"&vez=%@",vez];
        
        NSString *post =[NSString stringWithFormat:@"idF=%@",IDF];
        
        NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
        hostStr = [hostStr stringByAppendingString:post];
        hostStr = [hostStr stringByAppendingString:post2];
        hostStr = [hostStr stringByAppendingString:post3];
        hostStr = [hostStr stringByAppendingString:post4];
        hostStr = [hostStr stringByAppendingString:post5];
        hostStr = [hostStr stringByAppendingString:post6];
        hostStr = [hostStr stringByAppendingString:post7];
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:hostStr]];
        
       /* NSLog(@"%@ URL Engine",hostStr);
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        
        [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [_connection start];
        
      */
        
        NSOperationQueue *cola = [NSOperationQueue new];
        // now lets make the connection to the web
        
        [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *datas, NSError *error)
         {
             NSLog(@"%lu Data Leght",(unsigned long)[datas length]);
             if ([datas length] != 0) {
                 [self performSelectorInBackground:@selector(procesar:) withObject:datas ];
             
             }
             
         }];

        
        
        
        
        
    }
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    
    if ([data length] != 0) {

    [_data appendData:data];
    }
    else{
        NSLog(@"Datos Vacios");
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"%lu Data Leght",(unsigned long)[_data length]);
    if ([_data length] != 0) {
    [self performSelectorInBackground:@selector(procesar:) withObject:_data ];
    self.connection = nil;
    self.data = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.connection = nil;
    self.data = nil;
    //[self loadFailedWithError:error];
}

- (void)procesar:(NSData *)data{
    
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
     NSLog(@"%@ String",responseString);
    
    
    
    // NSLog(@"%@",error);
    
    NSLog(@"Response");
    // NSMutableArray *mmutable = [NSMutableArray array];
    for (NSDictionary *dict in returned){
        
        
        //NSData*imagenD = [NSData dataWithBase64EncodedString:[dict objectForKey:@"imagen"]];
        
        NSData *_secretData = [NSData dataWithBase64EncodedString:[dict objectForKey:@"imagen"]];
        
        NSData *encryptedData = [crypto decrypt:_secretData  key:[keys dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
        //NSLog(@"Data: %d", [encryptedData length]);
        if ([UIImage imageWithData:encryptedData].size.width >0) {
            
           Imagen* imagen2 = [[Imagen alloc] init];
            [imagen2 setID:[dict objectForKey:@"ID"]];
            [imagen2 setIDusuario:[dict objectForKey:@"IDusuario"]];
            [imagen2 setImagen:[UIImage imageWithData:encryptedData]];
            [imagen2 setEtiquetas:[dict objectForKey:@"Etiquetas"]];
            [imagen2 setFecha:[dict objectForKey:@"Fecha"]];
            [imagen2 setNombre:[dict objectForKey:@"Nombre"]];
            
             vezd++;
            [total addObject:imagen2];
            [self cache: imagen2];
            NSLog(@"FRAME IMAGEN %f",[UIImage imageWithData:encryptedData].size.width);
            NSLog(@"FRAME IMAGEN ID %@",[dict objectForKey:@"IDusuario"]);
            if ( [UIDS intValue]== [total count]) {
                NSLog(@"UIDS %@",UIDS);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Fin" object:nil];
            }
        }
        
        //   NSLog(@"%@ String",[dict objectForKey:@"ID"]);
        //  [mmutable addObject:item];
    }
    
    
    
}

-(void)cache:(Imagen*)img{
    /* NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
     NSString *documentsDirectory = paths[0];
     NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:nombreImagen];
     
     
     if(![[NSFileManager defaultManager] fileExistsAtPath: cacheDirectoryName])
     {
     // The file doesn't exist, we should get a copy of it
     
     // Fetch image
     NSData *data = [[NSData alloc] initWithContentsOfURL: ImageURL];
     UIImage *image = [[UIImage alloc] initWithData: data];
     
     // Do we want to round the corners?
     image = [self roundCorners: image];
     
     // Is it PNG or JPG/JPEG?
     // Running the image representation function writes the data from the image to a file
     if([ImageURLString rangeOfString: @\".png\" options: NSCaseInsensitiveSearch].location != NSNotFound)
     {
     [UIImagePNGRepresentation(image) writeToFile: uniquePath atomically: YES];
     }
     else if(
     [ImageURLString rangeOfString: @\".jpg\" options: NSCaseInsensitiveSearch].location != NSNotFound ||
     [ImageURLString rangeOfString: @\".jpeg\" options: NSCaseInsensitiveSearch].location != NSNotFound
     )
     {
     [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
     }
     }
     */
    NSLog(@"Guardando en Cache");
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:img forKey:nombreImagen];
    [archiver finishEncoding];
    [data writeToFile:cacheDirectoryName atomically:YES];
    
    
    
}

-(NSMutableArray *) devolverArray{
    NSLog(@"%u Elementos en Total (Fotos)",[total count]);
    return total;
    
}

-(void)eliminaObjetos{
    
    [total removeAllObjects];
}
@end

