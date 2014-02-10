//
//  Cache.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 30/08/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "Cache.h"
#import "Imagen.h"
#import "SBJsonParser.h"
#import "Usuario.h"
#import "NSData+Base64.h"
#import "StringEncryption.h"

@implementation Cache
@synthesize dataPath,filePath,vez,idf,perfil;

-(NSData*)comprobarCache:(NSURL *)URL{
    NSData * datos= [[NSData alloc]init];
    
    [self obtenerRutaCache:URL];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        NSLog(@"Cache");
        NSLog(@"Datos length: %d",[datos length]);
            
        datos = [[NSData alloc] initWithContentsOfFile:self.filePath];
      // image= [self procesarDatos:data];
    }
    else{
        NSLog(@"No Cache");
        datos=nil;
    }
    
    return datos;
}

-(UIImage *)procesarDatos: (NSData *)datas{
    
    __block NSData * data = [[NSData alloc]initWithData: datas] ;
    __block UIImage * imagen = [[UIImage alloc]init];
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        NSData *datos = [[NSUserDefaults standardUserDefaults] objectForKey:@"DatosGuardados"];
        NSMutableArray* arrayGuardado = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
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
        
        // NSLog(@" %@ Response Cache",responseString);
        // NSMutableArray *mmutable = [NSMutableArray array];
        for (NSDictionary *dict in returned){
            
            //   NSLog(@"Cache Processing");
            
            Imagen* imagen2 = [[Imagen alloc] init];
            //NSData*imagenD = [NSData dataWithBase64EncodedString:[dict objectForKey:@"imagen"]];
            
            NSData *_secretData = [NSData dataWithBase64EncodedString:[dict objectForKey:@"imagen"]];
            
            NSData *encryptedData = [crypto decrypt:_secretData  key:[keys dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
            //NSLog(@"Data: %d", [encryptedData length]);
            if ([UIImage imageWithData:encryptedData].size.width >0 && [encryptedData length] > 500) {
                
                //  NSLog(@"Imagen Valida");
                
                [imagen2 setID:[dict objectForKey:@"ID"]];
                [imagen2 setIDusuario:[dict objectForKey:@"IDusuario"]];
                [imagen2 setImagen:[UIImage imageWithData:encryptedData]];
                [imagen2 setEtiquetas:[dict objectForKey:@"Etiquetas"]];
                [imagen2 setFecha:[dict objectForKey:@"Fecha"]];
                [imagen2 setNombre:[dict objectForKey:@"Nombre"]];
                [imagen2 setPerfil:[dict objectForKey:@"Perfil"]];
                 imagen=imagen2.imagen;
                
                //   NSLog(@"FRAME IMAGEN %f",[UIImage imageWithData:encryptedData].size.width);
                // NSLog(@"FRAME IMAGEN ID %@",[dict objectForKey:@"IDusuario"]);
                
                
                
                for (int w =0; w<[arrayGuardado count];w++) {
                    
                    NSData *datos = [[NSUserDefaults standardUserDefaults] objectForKey:@"DatosGuardados"];
                    arrayGuardado = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
                    
                    
                    Usuario * us = [arrayGuardado objectAtIndex:w];
                    
                    
                    // NSLog(@"%@ %@", us.ID,imagen2.IDusuario);
                    
                    if([us.ID isEqualToString:imagen2.IDusuario] && [imagen2.perfil isEqualToString:@"1"]){
                        
                        Usuario * TempUser =[[Usuario alloc]init];
                        TempUser=us;
                        
                        TempUser.imagen = imagen2.imagen;
                        
                        
                        
                        NSLog(@"%@ Usuario Imagen",TempUser.usuario);
                        //  NSLog(@"Imagen Perfil Cache");
                        [arrayGuardado replaceObjectAtIndex:w withObject:TempUser];
                        
                        NSData *datos = [NSKeyedArchiver archivedDataWithRootObject:arrayGuardado];
                        [[NSUserDefaults standardUserDefaults] setObject:datos forKey:@"DatosGuardados"];
                        
                    }
                }
                
            }
            else{
                // NSLog(@"Imagen Invalida");
                
            }
            
            NSLog(@"Put Imagen");
            
            
            if ([self.perfil isEqualToString:@"perfil=0"]) {
                //UIImage * img = imagen2.imagen;
                imagen= [self addBorderToImage:imagen];
            }
            else{
                imagen= imagen2.imagen;
            }
            
            
            
            
            
            //   NSLog(@"%@ String",[dict objectForKey:@"ID"]);
            //  [mmutable addObject:item];
        }
        
        
        
    });
    
    return imagen;
    
    
}

-(void)obtenerRutaCache: (NSURL *) URL{
    NSString *fileName = [URL absoluteString];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"?" withString:@"&"];
    
    
    
    
    NSArray *array = [fileName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]];
    for (NSString * st in array) {
          // NSLog(@"%@",st);
        if ([st rangeOfString:@"idF"].location != NSNotFound) {
            self.idf= [NSString stringWithString:st];
           // NSLog(@"idF: %@",self.idf);
        }
        if ([st rangeOfString:@"vez"].location != NSNotFound) {
            self.vez= [NSString stringWithString:st];
        }
        if ([st rangeOfString:@"perfil"].location != NSNotFound) {
            self.perfil= [NSString stringWithString:st];
        }
    }
    
    [self initCache];
    
    //  NSLog(@" Nombre: %@.%@.%@",idf,vez,perfil);
    fileName = [NSString stringWithFormat:@"%@.%@.%@",self.idf,self.vez,self.perfil];
	self.filePath = [self.dataPath stringByAppendingPathComponent:fileName];
    
}
- (void) initCache
{
	/* create path to cache directory inside the application's Documents directory */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *string =[[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
    if ([self.perfil isEqualToString:@"perfil=1"]) {
        self.dataPath = [string stringByAppendingPathComponent:@"Perfil"];
    }else{
        
        self.dataPath = [string stringByAppendingPathComponent:self.idf];
        //NSLog(@"Ruta cache G: %@ ",self.dataPath);

    }
    
	/* check for existence of cache directory */
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.dataPath]) {
     //   NSLog(@"Directorio Existe Path : %@",dataPath);
		return;
	}
    
	else{
        [[NSFileManager defaultManager] createDirectoryAtPath:self.dataPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
     //   NSLog(@"Directorio Creado Path : %@",dataPath);
		
		return;
	}
}


- (UIImage *)addBorderToImage:(UIImage *)image {
	CGImageRef bgimage = [image CGImage];
	float widt = CGImageGetWidth(bgimage);
	float heigh = CGImageGetHeight(bgimage);
	
    // Create a temporary texture data buffer
	void *data = malloc(widt * heigh * 4);
	
	// Draw image to buffer
	CGContextRef ctx = CGBitmapContextCreate(data,
                                             widt,
                                             heigh,
                                             8,
                                             widt * 4,
                                             CGImageGetColorSpace(image.CGImage),
                                             kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(ctx, CGRectMake(0, 0, (CGFloat)widt, (CGFloat)heigh), bgimage);
	
	//Set the stroke (pen) color
	CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    
	//Set the width of the pen mark
	CGFloat borderWidth = (float)widt*0.05;
	CGContextSetLineWidth(ctx, borderWidth);
    
	//Start at 0,0 and draw a square
	CGContextMoveToPoint(ctx, 0.0, 0.0);
	CGContextAddLineToPoint(ctx, 0.0, heigh);
	CGContextAddLineToPoint(ctx, widt, heigh);
	CGContextAddLineToPoint(ctx, widt, 0.0);
	CGContextAddLineToPoint(ctx, 0.0, 0.0);
	
	//Draw it
	CGContextStrokePath(ctx);
    
    // write it to a new image
	CGImageRef cgimage = CGBitmapContextCreateImage(ctx);
	UIImage *newImage = [UIImage imageWithCGImage:cgimage];
	CFRelease(cgimage);
	CGContextRelease(ctx);
	
    // auto-released
	return newImage;
}



@end
