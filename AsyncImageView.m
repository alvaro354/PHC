//
//  AsyncImageView.m
//
//  Version 1.4
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright (c) 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from either of these locations:
//
//  http://charcoaldesign.co.uk/source/cocoa#asyncimageview
//  https://github.com/nicklockwood/AsyncImageView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "AsyncImageView.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import <objc/message.h>
#import "Imagen.h"
#import "SBJsonParser.h"
#import "Usuario.h"


NSString *const AsyncImageLoadDidFinish = @"AsyncImageLoadDidFinish";
NSString *const AsyncImageLoadDidFail = @"AsyncImageLoadDidFail";
NSString *const AsyncImageTargetReleased = @"AsyncImageTargetReleased";

NSString *const AsyncImageImageKey = @"image";
NSString *const AsyncImageURLKey = @"URL";
NSString *const AsyncImageCacheKey = @"cache";
NSString *const AsyncImageErrorKey = @"error";


@interface AsyncImageConnection : NSObject
@property (nonatomic, strong)Imagen* imagen2;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL success;
@property (nonatomic, assign) SEL failure;
@property (nonatomic, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, readonly) BOOL cancelled;
@property (nonatomic, strong) NSString *dataPath;

- (AsyncImageConnection *)initWithURL:(NSURL *)URL
                                cache:(NSCache *)cache
							   target:(id)target
							  success:(SEL)success
							  failure:(SEL)failure ;

- (void)start;
- (void)cancel;
- (BOOL)isInCache;

@end


@implementation AsyncImageConnection

@synthesize connection = _connection;
@synthesize data = _data;
@synthesize URL = _URL;
@synthesize cache = _cache;
@synthesize target = _target;
@synthesize success = _success;
@synthesize failure = _failure;
@synthesize loading = _loading;
@synthesize cancelled = _cancelled;
@synthesize dataPath;

- (AsyncImageConnection *)initWithURL:(NSURL *)URL
                                cache:(NSCache *)cache
							   target:(id)target
							  success:(SEL)success
							  failure:(SEL)failure
{
    if ((self = [self init]))
    {
        //NSLog(@"URL: %@",URL);
        self.URL = URL;
        self.cache = cache;
        self.target = target;
        self.success = success;
        self.failure = failure;
      
    }
    return self;
}

- (UIImage *)cachedImage
{
    
    if ([_URL isFileURL])
	{
        
		NSString *path = [[_URL absoluteURL] path];
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
		if ([path hasPrefix:resourcePath])
		{
           
			return [UIImage imageNamed:[path substringFromIndex:[resourcePath length]]];
		}
	}
    return [_cache objectForKey:_URL];
}

- (BOOL)isInCache
{
    return [self cachedImage] != nil;
}

- (void)loadFailedWithError:(NSError *)error
{
	_loading = NO;
	_cancelled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:AsyncImageLoadDidFail
                                                        object:_target
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                _URL, AsyncImageURLKey,
                                                                error, AsyncImageErrorKey,
                                                                nil]];
}

- (void)cacheImage:(UIImage *)image
{
	if (!_cancelled)
	{
        if (image && _URL)
        {
            BOOL storeInCache = YES;
            if ([_URL isFileURL])
            {
                if ([[[_URL absoluteURL] path] hasPrefix:[[NSBundle mainBundle] resourcePath]])
                {
                    //do not store in cache
                    storeInCache = NO;
                }
            }
            if (storeInCache)
            {
                [_cache setObject:image forKey:_URL];
            }
        }
        
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										 image, AsyncImageImageKey,
										 _URL, AsyncImageURLKey,
										 nil];
		if (_cache)
		{
			[userInfo setObject:_cache forKey:AsyncImageCacheKey];
		}
		
		_loading = NO;
		[[NSNotificationCenter defaultCenter] postNotificationName:AsyncImageLoadDidFinish
															object:_target
														  userInfo:[[userInfo copy] autorelease]];
	}
	else
	{
		_loading = NO;
		_cancelled = NO;
	}
}

- (void)processDataInBackground:(NSData *)data
{
    
   
	@synchronized ([self class])
	{	
		if (!_cancelled)
		{
            __block UIImage *image;
            dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
            dispatch_async(myQueue, ^{
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
            NSLog(@"Procesando no cache");
         
            
            
            // NSLog(@"%@",error);
            
            //NSLog(@"Response");
            // NSMutableArray *mmutable = [NSMutableArray array];
            for (NSDictionary *dict in returned){
                
                Imagen* imagen2 = [[Imagen alloc] init];
                //NSData*imagenD = [NSData dataWithBase64EncodedString:[dict objectForKey:@"imagen"]];
                
                NSData *_secretData = [NSData dataWithBase64EncodedString:[dict objectForKey:@"imagen"]];
                
                NSData *encryptedData = [crypto decrypt:_secretData  key:[keys dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
                //NSLog(@"Data: %d", [encryptedData length]);
                if ([UIImage imageWithData:encryptedData].size.width >0 && [encryptedData length] > 500) {
                  //  NSLog(@"Procesando");
                   
                    [imagen2 setID:[dict objectForKey:@"ID"]];
                    [imagen2 setIDusuario:[dict objectForKey:@"IDusuario"]];
                    [imagen2 setImagen:[UIImage imageWithData:encryptedData]];
                    [imagen2 setEtiquetas:[dict objectForKey:@"Etiquetas"]];
                    [imagen2 setFecha:[dict objectForKey:@"Fecha"]];
                    [imagen2 setNombre:[dict objectForKey:@"Nombre"]];
                      [imagen2 setPerfil:[dict objectForKey:@"Perfil"]];
                   // image=imagen2.imagen;
                    image =imagen2.imagen;
                    
                    [[AsyncImageView alloc] setImage:image];
              //      NSLog(@"idF=%@.vez=%@.perfil=%@",[dict objectForKey:@"IDusuario"],[dict objectForKey:@"Vez"],[dict objectForKey:@"Perfil"]);
                    NSString * filePath= [NSString  stringWithFormat: @"idF=%@.vez=%@.perfil=%@",[dict objectForKey:@"IDusuario"],[dict objectForKey:@"Vez"],[dict objectForKey:@"Perfil"] ];
                   // NSLog(@"Data Path: %@",[dataPath stringByAppendingPathComponent:filePath]);
                    NSString *string =[[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
                    
                    
                    if ([imagen2.perfil isEqualToString:@"1"]) {
                        dataPath = [string stringByAppendingPathComponent:@"Perfil"];
                    }else{
                       dataPath = [string stringByAppendingPathComponent:[NSString stringWithFormat:@"idF=%@",imagen2.IDusuario]];
                    }
                    
                    
                    [[NSFileManager defaultManager] createFileAtPath:[dataPath stringByAppendingPathComponent:filePath]
                                                            contents:data
                                                          attributes:nil];
                  //  NSLog(@"Path: %@",dataPath);
                 //  NSLog(@"Contenido: %@",[[NSFileManager defaultManager]contentsAtPath:dataPath]);
                 //   NSLog(@"FRAME IMAGEN %f",[UIImage imageWithData:encryptedData].size.width);
                   // NSLog(@"FRAME IMAGEN ID %@",[dict objectForKey:@"IDusuario"]);
                    
                    for (int w =0; w<[arrayGuardado count];w++) {
                        // NSLog(@"%@ %@", us.ID,user.ID);
                        NSData *datos = [[NSUserDefaults standardUserDefaults] objectForKey:@"DatosGuardados"];
                        arrayGuardado = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
                        
                        
                        Usuario * us = [arrayGuardado objectAtIndex:w];
                        if([us.ID isEqualToString:imagen2.IDusuario] && [imagen2.perfil isEqualToString:@"1"]){
                            
                            Usuario * TempUser =[[Usuario alloc]init];
                            TempUser=us;
                           
                            TempUser.imagen = imagen2.imagen;
                            
                            
                            
                            //NSLog(@"%@ Usuario",TempUser.usuario);
                          // NSLog(@"Imagen Perfil");
                            [arrayGuardado replaceObjectAtIndex:w withObject:TempUser];
                            
                            NSData *datos = [NSKeyedArchiver archivedDataWithRootObject:arrayGuardado];
                            [[NSUserDefaults standardUserDefaults] setObject:datos forKey:@"DatosGuardados"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                        }
                    }

                }
          
               
                
                //   NSLog(@"%@ String",[dict objectForKey:@"ID"]);
                //  [mmutable addObject:item];
            }
       
            
        });
            
            
     
			if (image)
			{
               // NSLog(@"Imagen Descargada");
				//add to cache (may be cached already but it doesn't matter)
                [self performSelectorOnMainThread:@selector(cacheImage:)
                                       withObject:image
                                    waitUntilDone:YES];
                [image release];
			}
			else
			{
               // NSLog(@"Cancelado");
                @autoreleasepool
                {
                    NSError *error = [NSError errorWithDomain:@"AsyncImageLoader" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Invalid image data" forKey:NSLocalizedDescriptionKey]];
                    [self performSelectorOnMainThread:@selector(loadFailedWithError:) withObject:error waitUntilDone:YES];
				}
			}
		}
		else
		{
            // NSLog(@"Cancelado2");
			//clean up
			[self performSelectorOnMainThread:@selector(cacheImage:)
								   withObject:nil
								waitUntilDone:YES];
		}
	}
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
 
    self.data = [NSMutableData data];
}
/*
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSLog(@"Cache Almacenado");
    return cachedResponse;
}
 */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//  NSLog(@"Datos Recibidos Tamaño : %u", [data length]);
  
    //NSLog(@"DataPath: %@ Datos: %@ ",self.dataPath, [[NSFileManager defaultManager]contentsAtPath:dataPath]);
    
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Datos Recibidos Tamaño : %u", [_data length]);
    [self performSelectorInBackground:@selector(processDataInBackground:) withObject:_data];
    
   
    self.connection = nil;
    self.data = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.connection = nil;
    self.data = nil;
    [self loadFailedWithError:error];
}



- (void)start
{
    
    /* prepare to use our own on-disk cache */
	
    
    
    if (_loading && !_cancelled)
    {
        return;
    }
	
	//begin loading
	_loading = YES;
	_cancelled = NO;
    
    //check for nil URL
    if (_URL == nil)
    {
        [self cacheImage:nil];
        return;
    }
    
    //check for cached image
	UIImage *image = [self cachedImage];
    if (image)
    {
        //add to cache (cached already but it doesn't matter)
        [self performSelectorOnMainThread:@selector(cacheImage:)
                               withObject:image
                            waitUntilDone:NO];
        return;
    }
    
    //begin load
    NSURLRequest *request = [NSURLRequest requestWithURL:_URL
                                             cachePolicy:NSURLCacheStorageAllowed
                                         timeoutInterval:[AsyncImageLoader sharedLoader].loadingTimeout];
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_connection start];
}

- (void)cancel
{
	_cancelled = YES;
    [_connection cancel];
    self.connection = nil;
    self.data = nil;
}

- (void)dealloc
{
    [_connection release];
    [_data release];
    [_URL release];
    [_target release];
    [super ah_dealloc];
}

@end


@interface AsyncImageLoader ()

@property (nonatomic, strong) NSMutableArray *connections;
@property (nonatomic, strong) NSString *dataPath;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong)    NSString *idf;
 @property (nonatomic, strong)  NSString * perfil;

@end


@implementation AsyncImageLoader

@synthesize cache = _cache;
@synthesize connections = _connections;
@synthesize concurrentLoads = _concurrentLoads;
@synthesize loadingTimeout = _loadingTimeout;
@synthesize filePath;
@synthesize dataPath;
@synthesize perfil;
@synthesize idf;


+ (AsyncImageLoader *)sharedLoader
{
	static AsyncImageLoader *sharedInstance = nil;
	if (sharedInstance == nil)
	{
		sharedInstance = [[self alloc] init];
	}
	return sharedInstance;
}

+ (NSCache *)defaultCache
{
    static NSCache *sharedInstance = nil;
	if (sharedInstance == nil)
	{
		sharedInstance = [[NSCache alloc] init];
	}
	return sharedInstance;
}

- (AsyncImageLoader *)init
{
	if ((self = [super init]))
	{
        self.cache = [[self class] defaultCache];
        _concurrentLoads = 2;
        _loadingTimeout = 60.0;
		_connections = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(imageLoaded:)
													 name:AsyncImageLoadDidFinish
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(imageFailed:)
													 name:AsyncImageLoadDidFail
												   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(targetReleased:)
													 name:AsyncImageTargetReleased
												   object:nil];
	}
	return self;
}

- (void)updateQueue
{
    //start connections
    NSInteger count = 0;
    for (AsyncImageConnection *connection in _connections)
    {
        if (![connection isLoading])
        {
            if ([connection isInCache])
            {
                [connection start];
            }
            else if (count < _concurrentLoads)
            {
                count ++;
                [connection start];
            }
        }
    }
}

- (void)imageLoaded:(NSNotification *)notification
{  
    //complete connections for URL
    NSURL *URL = [notification.userInfo objectForKey:AsyncImageURLKey];
 
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if (connection.URL == URL || [connection.URL isEqual:URL])
        {
            //cancel earlier connections for same target/action
            for (int j = i - 1; j >= 0; j--)
            {
                AsyncImageConnection *earlier = [_connections objectAtIndex:j];
                if (earlier.target == connection.target &&
                    earlier.success == connection.success)
                {
                    [earlier cancel];
                    [_connections removeObjectAtIndex:j];
                    i--;
                }
            }
            
            //cancel connection (in case it's a duplicate)
            [connection cancel];
            
            //perform action
			UIImage *image = [notification.userInfo objectForKey:AsyncImageImageKey];
            objc_msgSend(connection.target, connection.success, image, connection.URL);

            //remove from queue
            [_connections removeObjectAtIndex:i];
        }
    }
    
    //update the queue
    [self updateQueue];
}

- (void)imageFailed:(NSNotification *)notification
{
    //remove connections for URL
    NSURL *URL = [notification.userInfo objectForKey:AsyncImageURLKey];
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if ([connection.URL isEqual:URL])
        {
            //cancel connection (in case it's a duplicate)
            [connection cancel];
            
            //perform failure action
            if (connection.failure)
            {
                NSError *error = [notification.userInfo objectForKey:AsyncImageErrorKey];
                objc_msgSend(connection.target, connection.failure, error, URL);
            }
            
            //remove from queue
            [_connections removeObjectAtIndex:i];
        }
    }
    
    //update the queue
    [self updateQueue];
}

- (void)targetReleased:(NSNotification *)notification
{
    //remove connections for URL
    id target = [notification object];
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if (connection.target == target)
        {
            //cancel connection
            [connection cancel];
            [_connections removeObjectAtIndex:i];
        }
    }
    
    //update the queue
    [self updateQueue];
}
- (void) initCache
{
	/* create path to cache directory inside the application's Documents directory */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *string =[[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
    if ([perfil isEqualToString:@"perfil=1"]) {
         dataPath = [string stringByAppendingPathComponent:@"Perfil"];
    }else{
    dataPath = [string stringByAppendingPathComponent:idf];
    }
    
	/* check for existence of cache directory */
	if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
      //  NSLog(@"Directorio Existe Path : %@",dataPath);
		return;
	}
    
	else{
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath
								   withIntermediateDirectories:YES
													attributes:nil
                                                        error:nil];
        //NSLog(@"Directorio Creado Path : %@",dataPath);
		
		return;
	}
}

- (void)loadImageWithURL:(NSURL *)URL target:(id)target success:(SEL)success failure:(SEL)failure
{
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
    //check cache
 
    [filePath release]; /* release previous instance */
	NSString *fileName = [URL absoluteString];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"."];
           fileName = [fileName stringByReplacingOccurrencesOfString:@"?" withString:@"&"];
        
         NSString *vez;
        
         
    NSArray *array = [fileName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]];
         for (NSString * st in array) {
          //   NSLog(@"%@",st);
             if ([st rangeOfString:@"idF"].location != NSNotFound) {
                 idf= [NSString stringWithString:st];
             }
             if ([st rangeOfString:@"vez"].location != NSNotFound) {
                 vez= [NSString stringWithString:st];
             }
             if ([st rangeOfString:@"perfil"].location != NSNotFound) {
                perfil= [NSString stringWithString:st];
             }
         }
        
       [self initCache];
         
  //  NSLog(@" Nombre: %@.%@.%@",idf,vez,perfil);
    fileName = [NSString stringWithFormat:@"%@.%@.%@",idf,vez,perfil];
	filePath = [dataPath stringByAppendingPathComponent:fileName];
    //NSLog(@"FilePath: %@",filePath);

    	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSLog(@"Cache");
            NSData* data = [[NSData alloc] initWithContentsOfFile:filePath];
            [self processDataInBackground:data target:target success:success];
            return;
   
        }
    NSLog(@" NO Cache");
    //create new connection
    AsyncImageConnection *connection = [[AsyncImageConnection alloc] initWithURL:URL
                                                                           cache:_cache
                                                                          target:target
                                                                         success:success
                                                                         failure:failure];
    BOOL added = NO;
    for (int i = 0; i < [_connections count]; i++)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        [connection setDataPath:filePath];
        
        if (!connection.loading)
        {
            [_connections insertObject:connection atIndex:i];
            added = YES;
            break;
        }
    }
    if (!added)
    {
        [_connections addObject:connection];
    }
    
    [connection release];
    [self updateQueue];
     });
}

- (void)processDataInBackground:(NSData *)data target:(id)target success:(SEL)success
{
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
            UIImage *image;
            
            
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
                    image =imagen2.imagen;
                   
                    [[AsyncImageView alloc] setImage:image];
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
                if (image)
                {
                    //NSLog(@"Put Imagen");
                    [self cancelLoadingImagesForTarget:self action:success];
                    if (success) [target performSelectorOnMainThread:success withObject:image waitUntilDone:NO];
                    [[AsyncImageView alloc] setImage:image];
                    return;
                }
                
              
                
                //   NSLog(@"%@ String",[dict objectForKey:@"ID"]);
                //  [mmutable addObject:item];
            }
            
            
            
    });
    
    dispatch_release(myQueue);
      
	}






- (void)loadImageWithURL:(NSURL *)URL target:(id)target action:(SEL)action
{
    [self loadImageWithURL:URL target:target success:action failure:NULL];
}

- (void)loadImageWithURL:(NSURL *)URL
{
    [self loadImageWithURL:URL target:nil success:NULL failure:NULL];
}

- (void)cancelLoadingURL:(NSURL *)URL target:(id)target action:(SEL)action
{
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if ([connection.URL isEqual:URL] && connection.target == target && connection.success == action)
        {
            [connection cancel];
            [_connections removeObjectAtIndex:i];
        }
    }
}

- (void)cancelLoadingURL:(NSURL *)URL target:(id)target
{
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if ([connection.URL isEqual:URL] && connection.target == target)
        {
            [connection cancel];
            [_connections removeObjectAtIndex:i];
        }
    }
}

- (void)cancelLoadingURL:(NSURL *)URL
{
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if ([connection.URL isEqual:URL])
        {
            [connection cancel];
            [_connections removeObjectAtIndex:i];
        }
    }
}

- (void)cancelLoadingImagesForTarget:(id)target action:(SEL)action
{
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        NSLog(@"Cancelado ");
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if (connection.target == target && connection.success == action)
        {
             NSLog(@"Cancelado ");
            [connection cancel];
        }
    }
}

- (void)cancelLoadingImagesForTarget:(id)target
{
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if (connection.target == target)
        {
             NSLog(@"Cancelado ");
            [connection cancel];
        }
    }
}

- (NSURL *)URLForTarget:(id)target action:(SEL)action
{
    //return the most recent image URL assigned to the target for the given action
    //this is not neccesarily the next image that will be assigned
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if (connection.target == target && connection.success == action)
        {
            return [[connection.URL ah_retain] autorelease];
        }
    }
    return nil;
}

- (NSURL *)URLForTarget:(id)target
{
    //return the most recent image URL assigned to the target
    //this is not neccesarily the next image that will be assigned
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if (connection.target == target)
        {
            return [[connection.URL ah_retain] autorelease];
        }
    }
    return nil;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [_cache release];
    [_connections release];
    [super ah_dealloc];
}

@end


@implementation UIImageView(AsyncImageView)

- (void)setImageURL:(NSURL *)imageURL
{
	[[AsyncImageLoader sharedLoader] loadImageWithURL:imageURL target:self action:@selector(setImage:)];
}

- (NSURL *)imageURL
{
	return [[AsyncImageLoader sharedLoader] URLForTarget:self action:@selector(setImage:)];
}

@end


@interface AsyncImageView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end


@implementation AsyncImageView

@synthesize showActivityIndicator = _showActivityIndicator;
@synthesize activityIndicatorStyle = _activityIndicatorStyle;
@synthesize crossfadeImages = _crossfadeImages;
@synthesize crossfadeDuration = _crossfadeDuration;
@synthesize activityView = _activityView;
@synthesize imagen = _imagen;
@synthesize imgView = _imgView;

- (void)setUp
{
	_showActivityIndicator = (self.image == nil);
	_activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    _crossfadeImages =NO;
	_crossfadeDuration = 0.2;
}

- (id)initWithFrame:(CGRect)frame
{
   
    if ((self = [super initWithFrame:frame]))
    {
        [self setUp];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL
{
    super.imageURL = imageURL;
    if (_showActivityIndicator && !self.image)
    {
        if (_activityView == nil)
        {
            _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_activityIndicatorStyle];
            _activityView.hidesWhenStopped = YES;
            _activityView.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
            _activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            [self addSubview:_activityView];
        }
        [_activityView startAnimating];
    }
}

- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
	_activityIndicatorStyle = style;
	[_activityView removeFromSuperview];
	self.activityView = nil;
}

- (void)setImage:(UIImage *)image
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if (_crossfadeImages)
    {
        //implement crossfade transition without needing to import QuartzCore
        id animation = objc_msgSend(NSClassFromString(@"CATransition"), @selector(animation));
        objc_msgSend(animation, @selector(setType:), @"kCATransitionFade");
        objc_msgSend(animation, @selector(setDuration:), _crossfadeDuration);
        objc_msgSend(self.layer, @selector(addAnimation:forKey:), animation, nil);
    }
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
        [self setNeedsDisplay];
        [super setNeedsDisplay];
        //super.image=image;
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"Imagen" object:self userInfo:nil];
  
        
    }
    [_activityView stopAnimating];
  });
}

- (void)dealloc
{
    [[AsyncImageLoader sharedLoader] cancelLoadingURL:self.imageURL target:self];
	[_activityView release];
    [super ah_dealloc];
}

@end
