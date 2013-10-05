// AFImageRequestOperation.m
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

#import "AFImageRequestOperation.h"
#import "Imagen.h"
#import "SBJsonParser.h"
#import "Usuario.h"
#import "NSData+Base64.h"
#import "StringEncryption.h"
#import "GZIP.h"




static dispatch_queue_t image_request_operation_processing_queue() {
    static dispatch_queue_t af_image_request_operation_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_image_request_operation_processing_queue = dispatch_queue_create("com.alamofire.networking.image-request.processing", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return af_image_request_operation_processing_queue;
}

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import <CoreGraphics/CoreGraphics.h>

static UIImage * AFImageWithDataAtScale(NSData *data, CGFloat scale) {
    if ([UIImage instancesRespondToSelector:@selector(initWithData:scale:)]) {
        return [[UIImage alloc] initWithData:data scale:scale];
    } else {
        UIImage *image = [[UIImage alloc] initWithData:data];
        return [[UIImage alloc] initWithCGImage:[image CGImage] scale:scale orientation:image.imageOrientation];
    }
}

static UIImage * AFInflatedImageFromResponseWithDataAtScale(NSHTTPURLResponse *response, NSData *data, CGFloat scale) {
    if (!data || [data length] == 0) {
        return nil;
    }
    
    UIImage *image = AFImageWithDataAtScale(data, scale);
    if (image.images) {
        return image;
    }
    
    CGImageRef imageRef = nil;
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    if ([response.MIMEType isEqualToString:@"image/png"]) {
        imageRef = CGImageCreateWithPNGDataProvider(dataProvider,  NULL, true, kCGRenderingIntentDefault);
    } else if ([response.MIMEType isEqualToString:@"image/jpeg"]) {
        imageRef = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, true, kCGRenderingIntentDefault);
    }
    
    if (!imageRef) {
        imageRef = CGImageCreateCopy([image CGImage]);
        
        if (!imageRef) {
            CGDataProviderRelease(dataProvider);
            return image;
        }
    }
    
    CGDataProviderRelease(dataProvider);
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bytesPerRow = 0; // CGImageGetBytesPerRow() calculates incorrectly in iOS 5.0, so defer to CGBitmapContextCreate()
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    if (CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        int alpha = (bitmapInfo & kCGBitmapAlphaInfoMask);
        if (alpha == kCGImageAlphaNone) {
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            bitmapInfo |= kCGImageAlphaNoneSkipFirst;
        } else if (!(alpha == kCGImageAlphaNoneSkipFirst || alpha == kCGImageAlphaNoneSkipLast)) {
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            bitmapInfo |= kCGImageAlphaPremultipliedFirst;
        }
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    
    CGColorSpaceRelease(colorSpace);
    
    if (!context) {
        CGImageRelease(imageRef);
        
        return image;
    }
    
    CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
    CGContextDrawImage(context, rect, imageRef);
    CGImageRef inflatedImageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *inflatedImage = [[UIImage alloc] initWithCGImage:inflatedImageRef scale:scale orientation:image.imageOrientation];
    CGImageRelease(inflatedImageRef);
    CGImageRelease(imageRef);
    
    return inflatedImage;
}
#endif

@interface AFImageRequestOperation ()
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
@property (readwrite, nonatomic, strong) UIImage *responseImage;
@property (readwrite,nonatomic, strong) NSString *dataPath;
@property (readwrite,nonatomic, strong) NSString *filePath;
@property (readwrite,nonatomic, strong) NSString *idf;
@property (readwrite,nonatomic, strong)  NSString *perfil;
@property (readwrite,nonatomic, strong)  NSString *vez;
@property (readwrite,nonatomic, strong)  NSString *borde;
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
@property (readwrite, nonatomic, strong) NSImage *responseImage;
#endif
@end

@implementation AFImageRequestOperation
@synthesize responseImage = _responseImage;
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
@synthesize imageScale = _imageScale;
@synthesize dataPath,filePath,vez,perfil,idf,borde;
#endif

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
+ (instancetype)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
										 success:(void (^)(UIImage *image))success
{
    return [self imageRequestOperationWithRequest:urlRequest imageProcessingBlock:nil success:^(NSURLRequest __unused *request, NSHTTPURLResponse __unused *response, UIImage *image) {
        if (success) {
            success(image);
        }
    } failure:nil];
}
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
+ (instancetype)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
										 success:(void (^)(NSImage *image))success
{
    return [self imageRequestOperationWithRequest:urlRequest imageProcessingBlock:nil success:^(NSURLRequest __unused *request, NSHTTPURLResponse __unused *response, NSImage *image) {
        if (success) {
            success(image);
        }
    } failure:nil];
}
#endif


#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
+ (instancetype)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
							imageProcessingBlock:(UIImage *(^)(UIImage *))imageProcessingBlock
										 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
										 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    // AFImageRequestOperation *requestOperation = [(AFImageRequestOperation *)[self alloc] initWithRequest:urlRequest];
    
    AFHTTPRequestOperation *requestOperation  = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    __block AFImageRequestOperation *requestB = [[AFImageRequestOperation alloc]init];
    [requestB obtenerRutaCache:[urlRequest URL]];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if (success) {
            
            UIImage *image= [[UIImage alloc]init] ;
            
            
               NSData * datas = responseObject ;
           
               __block  NSData * data = [datas gzippedData] ;
            
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
                     image=imagen2.imagen;
                    
                    //   NSLog(@"FRAME IMAGEN %f",[UIImage imageWithData:encryptedData].size.width);
                    // NSLog(@"FRAME IMAGEN ID %@",[dict objectForKey:@"IDusuario"]);
                    
                    
                    NSString * filePath= [NSString  stringWithFormat: @"idF=%@.vez=%@.perfil=%@",[dict objectForKey:@"IDusuario"],[dict objectForKey:@"Vez"],[dict objectForKey:@"Perfil"] ];
                    // NSLog(@"Data Path: %@",[dataPath stringByAppendingPathComponent:filePath]);
                    NSString *string =[[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
                    
                    
                    if ([imagen2.perfil isEqualToString:@"1"]) {
                        requestB.dataPath = [string stringByAppendingPathComponent:@"Perfil"];
                    }else{
                        requestB.dataPath = [string stringByAppendingPathComponent:[NSString stringWithFormat:@"idF=%@",imagen2.IDusuario]];
                    }
                    
                    
                    
                    [[NSFileManager defaultManager] createFileAtPath:[requestB.dataPath stringByAppendingPathComponent:filePath]
                                                            contents:data
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
                //UIImage * img = imagen2.imagen;
                if ([requestB.perfil isEqualToString:@"perfil=0"]) {
                    //UIImage * img = imagen2.imagen;
                    if ([requestB.borde isEqualToString:@"borde=1"]) {
                        NSLog(@"No borde");
                    }
                    else{
                    image= [requestB addBorderToImage:image];
                    }
                }
                else{
                    NSLog(@"Perfil no borde"); 
                }
                
                
                
                
                
            }
            
            
            
            
            
            if (imageProcessingBlock) {
                dispatch_async(image_request_operation_processing_queue(), ^(void) {
                    UIImage *processedImage = imageProcessingBlock(image);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
                    dispatch_async(operation.successCallbackQueue ?: dispatch_get_main_queue(), ^(void) {
                        success(operation.request, operation.response,image);
                    });
#pragma clang diagnostic pop
                });
            } else {
                success(operation.request, operation.response, image);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error);
        }
    }];
    
    
    return requestOperation;
    
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
        if ([st rangeOfString:@"borde"].location != NSNotFound) {
            self.borde= [NSString stringWithString:st];
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
        //  NSLog(@"Directorio Creado Path : %@",dataPath);
		
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


#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
+ (instancetype)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
							imageProcessingBlock:(NSImage *(^)(NSImage *))imageProcessingBlock
										 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSImage *image))success
										 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    AFImageRequestOperation *requestOperation = [(AFImageRequestOperation *)[self alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSImage *image = responseObject;
            
            
            if (imageProcessingBlock) {
                dispatch_async(image_request_operation_processing_queue(), ^(void) {
                    NSImage *processedImage = imageProcessingBlock(image);
                    
                    dispatch_async(operation.successCallbackQueue ?: dispatch_get_main_queue(), ^(void) {
                        success(operation.request, operation.response, processedImage);
                    });
                });
            } else {
                success(operation.request, operation.response, image);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error);
        }
    }];
    
    return requestOperation;
}
#endif





- (id)initWithRequest:(NSURLRequest *)urlRequest {
    self = [super initWithRequest:urlRequest];
    if (!self) {
        return nil;
    }
    
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    self.imageScale = [[UIScreen mainScreen] scale];
    self.automaticallyInflatesResponseImage = YES;
#endif
    
    return self;
}


#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
- (UIImage *)responseImage {
    if (!_responseImage && [self.responseData length] > 0 && [self isFinished]) {
        if (self.automaticallyInflatesResponseImage) {
            self.responseImage = AFInflatedImageFromResponseWithDataAtScale(self.response, self.responseData, self.imageScale);
        } else {
            self.responseImage = AFImageWithDataAtScale(self.responseData, self.imageScale);
        }
    }
    
    return _responseImage;
}

- (void)setImageScale:(CGFloat)imageScale {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wfloat-equal"
    if (imageScale == _imageScale) {
        return;
    }
#pragma clang diagnostic pop
    
    _imageScale = imageScale;
    
    self.responseImage = nil;
}
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
- (NSImage *)responseImage {
    if (!_responseImage && [self.responseData length] > 0 && [self isFinished]) {
        // Ensure that the image is set to it's correct pixel width and height
        NSBitmapImageRep *bitimage = [[NSBitmapImageRep alloc] initWithData:self.responseData];
        self.responseImage = [[NSImage alloc] initWithSize:NSMakeSize([bitimage pixelsWide], [bitimage pixelsHigh])];
        [self.responseImage addRepresentation:bitimage];
    }
    
    return _responseImage;
}
#endif

#pragma mark - AFHTTPRequestOperation

+ (NSSet *)acceptableContentTypes {
    return [NSSet setWithObjects:@"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico", @"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap", nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    static NSSet * _acceptablePathExtension = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _acceptablePathExtension = [[NSSet alloc] initWithObjects:@"tif", @"tiff", @"jpg", @"jpeg", @"gif", @"png", @"ico", @"bmp", @"cur", nil];
    });
    
    return [_acceptablePathExtension containsObject:[[request URL] pathExtension]] || [super canProcessRequest:request];
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    
    self.completionBlock = ^ {
        dispatch_async(image_request_operation_processing_queue(), ^(void) {
            if (self.error) {
                if (failure) {
                    dispatch_async(self.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
                        failure(self, self.error);
                    });
                }
            } else {
                if (success) {
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
                    UIImage *image = nil;
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
                    NSImage *image = nil;
#endif
                    
                    image = self.responseImage;
                    
                    dispatch_async(self.successCallbackQueue ?: dispatch_get_main_queue(), ^{
                        success(self, image);
                    });
                }
            }
        });
    };
#pragma clang diagnostic pop
}



@end
