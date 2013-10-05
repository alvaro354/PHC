// UIImageView+AFNetworking.m
//
// Copyright (c) 2011 Gowalla (http://gowalla.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Imagen.h"
#import "SBJsonParser.h"
#import "Usuario.h"
#import "NSData+Base64.h"
#import "StringEncryption.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import "UIImageView+AFNetworking.h"

@interface AFImageCache : NSCache
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;
@end

#pragma mark -

static char kAFImageRequestOperationObjectKey;

@interface UIImageView (_AFNetworking)
@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) AFHTTPRequestOperation *af_imageRequestOperation;

@end
NSString * const kNewPropertyKey = @"kNewPropertyKey";
NSString * const kNewPropertyKeyd = @"kNewPropertyKeyd";
NSString * const kNewPropertyKeyf = @"kNewPropertyKeyf";
NSString * const kNewPropertyKeyi = @"kNewPropertyKeyi";
NSString * const kNewPropertyKeyv = @"kNewPropertyKeyv";
@implementation UIImageView (_AFNetworking)
@dynamic af_imageRequestOperation;


@end

#pragma mark -

@implementation UIImageView (AFNetworking)
//@dynamic    dataPath,filePath,idf,perfil,vez;


- (AFHTTPRequestOperation *)af_imageRequestOperation {
    return (AFHTTPRequestOperation *)objc_getAssociatedObject(self, &kAFImageRequestOperationObjectKey);
}

- (void)af_setImageRequestOperation:(AFHTTPRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, &kAFImageRequestOperationObjectKey, imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_imageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_af_imageRequestOperationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });

    return _af_imageRequestOperationQueue;
}

+ (AFImageCache *)af_sharedImageCache {
    static AFImageCache *_af_imageCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _af_imageCache = [[AFImageCache alloc] init];
    });

    return _af_imageCache;
}

#pragma mark -

- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    [self cancelImageRequestOperation];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = self.center;
    [indicator startAnimating];
    [self addSubview:indicator];

   /* UIImage *cachedImage = [[[self class] af_sharedImageCache] cachedImageForRequest:urlRequest];
    if (cachedImage) {
        self.af_imageRequestOperation = nil;

        if (success) {
            success(nil, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }
    } else {
        if (placeholderImage) {
            self.image = placeholderImage;
        }*/
    [self obtenerRutaCache:[urlRequest URL]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        NSLog(@"Cache");
         self.af_imageRequestOperation = nil;
        NSData* data = [[NSData alloc] initWithContentsOfFile:self.filePath];
       UIImage * imagen= [self procesarDatos:data];
        if (imagen != nil) {
           
        success(nil,nil,imagen);
        }
        if ([self.perfil isEqualToString:@"perfil=0"]) {
            [self crearMarco:imagen];
        }
        self.image=imagen;
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        return;
        
    }else{
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
       
#ifdef _AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_
		requestOperation.allowsInvalidSSLCertificate = YES;
#endif
		
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([urlRequest isEqual:[self.af_imageRequestOperation request]]) {
                if (self.af_imageRequestOperation == operation) {
                    self.af_imageRequestOperation = nil;
                }
/*
                if (success) {
                    //success(operation.request, operation.response, responseObject);
                } else if (responseObject) {
                    */
                    __block NSData * data = responseObject ;
                NSData *dataG= [[NSData alloc]initWithData:data];
                
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

                        
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
                                // image=imagen2.imagen;
                              
                                //   NSLog(@"FRAME IMAGEN %f",[UIImage imageWithData:encryptedData].size.width);
                                // NSLog(@"FRAME IMAGEN ID %@",[dict objectForKey:@"IDusuario"]);
                                
                                
                                NSString * filePath= [NSString  stringWithFormat: @"idF=%@.vez=%@.perfil=%@",[dict objectForKey:@"IDusuario"],[dict objectForKey:@"Vez"],[dict objectForKey:@"Perfil"] ];
                                // NSLog(@"Data Path: %@",[dataPath stringByAppendingPathComponent:filePath]);
                                NSString *string =[[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
                                
                                
                                if ([imagen2.perfil isEqualToString:@"1"]) {
                                    self.dataPath = [string stringByAppendingPathComponent:@"Perfil"];
                                }else{
                                    self.dataPath = [string stringByAppendingPathComponent:[NSString stringWithFormat:@"idF=%@",imagen2.IDusuario]];
                                }
                                
                                
                                [[NSFileManager defaultManager] createFileAtPath:[self.dataPath stringByAppendingPathComponent:filePath]
                                                                        contents:dataG
                                                                      attributes:nil];
                                
                                
                                
                                
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
                            
                                
                                
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      
                                success(operation.request, operation.response,imagen2.imagen);
                            
                            
                                self.image = imagen2.imagen;
                                      
                                      [indicator stopAnimating];
                                      [indicator removeFromSuperview];
                            
                                  });
                            
                            
                            
                            //   NSLog(@"%@ String",[dict objectForKey:@"ID"]);
                            //  [mmutable addObject:item];
                        }
                        
                        
                        
                    
                   
                
            }

            
        }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([urlRequest isEqual:[self.af_imageRequestOperation request]]) {
                if (self.af_imageRequestOperation == operation) {
                    self.af_imageRequestOperation = nil;
                }

                if (failure) {
                    failure(operation.request, operation.response, error);
                }
            }
        }];

        self.af_imageRequestOperation = requestOperation;

        [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
    }
}
-(UIImage *)procesarDatos: (NSData *)datas{
    
    __block NSData * data = datas ;
    __block UIImage * imagen  ;
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
                // image=imagen2.imagen;
                
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
            
          
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                imagen=imagen2.imagen;
                self.image = imagen2.imagen;
                
                
            });
          
            
            
            
            
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
        //   NSLog(@"%@",st);
        if ([st rangeOfString:@"idF"].location != NSNotFound) {
            self.idf= [NSString stringWithString:st];
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
    }
    
	/* check for existence of cache directory */
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.dataPath]) {
        //  NSLog(@"Directorio Existe Path : %@",dataPath);
		return;
	}
    
	else{
        [[NSFileManager defaultManager] createDirectoryAtPath:self.dataPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
        //NSLog(@"Directorio Creado Path : %@",dataPath);
		
		return;
	}
}


-(UIImageView *)crearMarco:(UIImage*)image{
    UIImageView* _imgView = [[UIImageView alloc]init];
    if (image!= nil) {
        
        
        
        if (image.size.width>320 && image.size.height > 480) {
            [_imgView removeFromSuperview];
            _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320/3, 320/3)];
            _imgView.center = self.center;
            _imgView.image=image;
            _imgView.layer.borderWidth=1.5;
            _imgView.layer.borderColor=[UIColor blackColor].CGColor;
            [super addSubview:_imgView];
            //[super setImage:image];
            //  NSLog(@"Imagen 1");
            [super reloadInputViews];
            
        }
        if (image.size.width>325) {
            [_imgView removeFromSuperview];
            _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320/3, 320/3)];
            _imgView.center = self.center;
            _imgView.image=image;
            _imgView.layer.borderWidth=1.5;
            _imgView.layer.borderColor=[UIColor blackColor].CGColor;
            [super addSubview:_imgView];
            //   [super setImage:image];
            //  NSLog(@"Imagen 2");
            [super reloadInputViews];
            
        }
        else{
            [_imgView removeFromSuperview];
            _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width/3, image.size.height/3)];
            _imgView.image=image;
            _imgView.layer.borderWidth=1.5;
            _imgView.layer.borderColor=[UIColor blackColor].CGColor;
            [super addSubview:_imgView];
            // [super setImage:image];
            //  NSLog(@"Imagen 3");
            [super reloadInputViews];
            
        }
        //  NSLog(@"CORRECTO");
   //     [self setNeedsDisplay];
   //     [super setNeedsDisplay];
        //super.image=image;
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"Imagen" object:self userInfo:nil];
        
        
    }
    return _imgView;
}

- (void)setPerfil:(NSString *)perfil
{
    objc_setAssociatedObject(self, (__bridge const void *)(kNewPropertyKey), perfil, OBJC_ASSOCIATION_ASSIGN);
}
- (NSString*) perfil
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kNewPropertyKey));
}
- (void)setDataPath:(NSString *)dataPath
{
    objc_setAssociatedObject(self, (__bridge const void *)(kNewPropertyKeyd), dataPath, OBJC_ASSOCIATION_ASSIGN);
}
- (NSString*) dataPath
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kNewPropertyKeyd));
}
- (void)setIdf:(NSString *)idf
{
    objc_setAssociatedObject(self, (__bridge const void *)(kNewPropertyKeyi), idf, OBJC_ASSOCIATION_ASSIGN);
}
- (NSString*) idf
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kNewPropertyKeyi));
}
- (void)setVez:(NSString *)vez
{
    objc_setAssociatedObject(self, (__bridge const void *)(kNewPropertyKeyv), vez, OBJC_ASSOCIATION_ASSIGN);
}
- (NSString*)vez
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kNewPropertyKeyv));
}
- (void)setFilePath:(NSString *)filePath
{
    objc_setAssociatedObject(self, (__bridge const void *)(kNewPropertyKeyf), filePath, OBJC_ASSOCIATION_ASSIGN);
}
- (NSString*) filePath
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kNewPropertyKeyf));
}

- (void)cancelImageRequestOperation {
    [self.af_imageRequestOperation cancel];
    self.af_imageRequestOperation = nil;
}

@end

#pragma mark -

static inline NSString * AFImageCacheKeyFromURLRequest(NSURLRequest *request) {
    return [[request URL] absoluteString];
}

@implementation AFImageCache

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request {
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }

	return [self objectForKey:AFImageCacheKeyFromURLRequest(request)];
}

- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request
{
    if (image && request) {
        [self setObject:image forKey:AFImageCacheKeyFromURLRequest(request)];
    }
}

@end

#endif
