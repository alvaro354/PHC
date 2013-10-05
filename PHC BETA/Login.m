//
//  Login.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 09/02/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "Login.h"
#import "PhcAppDelegate.h"

@interface Login ()

@end


@implementation Login
@synthesize viewS, campoActivo;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) alertView:(UIAlertView*)alert3 didDismissWithButtonIndex:(NSInteger)buttonIndex

{
    
	if (buttonIndex == 0 && exito == YES)
	{
        usuarioText.layer.borderWidth=0;
   
        
        contrasenaText.layer.borderWidth=0;
       
        
        correoText.layer.borderWidth=0;
     
		[self registrar:nil];
        
	}}


-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}
-(void)viewDidAppear:(BOOL)animated{
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];

  
    // self.navigationController.navigationBar.topItem.title.
}


-(IBAction)sendData:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
     
        [[PhcAppDelegate alloc]internet];
        return;
        
    }

    
    
    
    if (registrar==YES) {
        
        if ([usuarioText.text isEqualToString:@""] || [usuarioText.text isEqualToString:@" "] ) {
            NSLog(@"Blanco");
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Usuario en Blanco"
                                                                  delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alertsuccess show];
            
            
        }
        if ([contrasenaText.text isEqualToString:@""] || [contrasenaText.text isEqualToString:@" "] ) {
            NSLog(@"Blanco");
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Contraseña en Blanco"
                                                                  delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alertsuccess show];
            
            
        }
        if ([correoText.text isEqualToString:@""] || [correoText.text isEqualToString:@" "] ) {
            NSLog(@"Blanco");
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Correo en Blanco"
                                                                  delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alertsuccess show];
            
            
        }
        else{
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        hud.labelText = NSLocalizedString(@"Connecting", @"");
        
        //NSString *post =[NSString stringWithFormat:@"username=%@&password=%@",userText.text, ContraText.text];
        
        NSString *hostStr = @"http://lanchosoftware.es/app/registrar.php";
        // hostStr = [hostStr stringByAppendingString:post];
        
        NSLog(@"%@",hostStr);
        
        
        
        NSString *_key = @"alvarol2611995";
        
        NSDate *myDate = [NSDate date];
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"dd"];
        
        _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
        NSLog(@" %@ key",_key);
        StringEncryption *crypto = [[StringEncryption alloc] init] ;
        
        
        
        
        NSData *_secretData = [usuarioText.text dataUsingEncoding:NSUTF8StringEncoding];
        NSData *_secretDataCon = [contrasenaText.text dataUsingEncoding:NSUTF8StringEncoding];
         NSData *_secretDataCorreo = [correoText.text dataUsingEncoding:NSUTF8StringEncoding];
            
        CCOptions padding = kCCOptionPKCS7Padding;
        NSData *encryptedData = [crypto encrypt:_secretData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
        NSData *encryptedDataCon = [crypto encrypt:_secretDataCon key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
             NSData *encryptedDataCorreo = [crypto encrypt:_secretDataCorreo key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
        NSLog(@"encrypted data in hex: %@", encryptedData);
        
        /*NSData *decryptedData = [crypto decrypt:encryptedData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
         
         NSLog(@"decrypted data in dex: %@", decryptedData);
         NSString *str = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
         
         NSLog(@"decrypted data string for export: %@",str);
         */
        NSString * encodedStringUsu = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                            NULL,
                                                                                                            (CFStringRef)[encryptedData base64EncodingWithLineLength:0],
                                                                                                            NULL,
                                                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                            kCFStringEncodingUTF8 ));
        NSString * encodedStringCon = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                            NULL,
                                                                                                            (CFStringRef)[encryptedDataCon base64EncodingWithLineLength:0],
                                                                                                            NULL,
                                                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                            kCFStringEncodingUTF8 ));
            NSString * encodedStringCorreo = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                                NULL,
                                                                                                                (CFStringRef)[encryptedDataCorreo base64EncodingWithLineLength:0],
                                                                                                                NULL,
                                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                                kCFStringEncodingUTF8 ));
        
        NSLog(@"encrypted data string for export: %@",[encryptedDataCon base64EncodingWithLineLength:0]);
        NSString * usuario = [NSString stringWithFormat:@"?username=%@",encodedStringUsu];
        NSString * contrasena = [NSString stringWithFormat:@"&password=%@",encodedStringCon ];
             NSString * correo = [NSString stringWithFormat:@"&email=%@",encodedStringCorreo ];
        NSString * date = [NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
        NSLog(@"Usuario: %@",usuario);
        NSLog(@"Contrasena: %@",contrasena);
        
        hostStr= [hostStr stringByAppendingString:usuario];
        hostStr=[hostStr stringByAppendingString:contrasena];
                  hostStr=[hostStr stringByAppendingString:correo];
        hostStr=[hostStr stringByAppendingString:date];
        
        NSLog(@"URL: %@",hostStr);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:hostStr]];
        
        NSOperationQueue *cola = [NSOperationQueue new];
        // now lets make the connection to the web
        
        [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *datas, NSError *error)
         {
                 dispatch_async(dispatch_get_main_queue(), ^{ 
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             serverOutput = [[NSString alloc] initWithData:datas encoding: NSASCIIStringEncoding];
             NSString *trimmedString = [serverOutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
             NSLog(@"%@ String",serverOutput);
             
             if([trimmedString isEqualToString:@"1"]){
                 
                 NSLog(@"Registro Exitoso");
                 
                 usuarioText.layer.borderWidth=2;
                 usuarioText.layer.borderColor= [UIColor colorWithRed:0 green:1 blue:0 alpha:1].CGColor;
                 
                 contrasenaText.layer.borderWidth=2;
                 contrasenaText.layer.borderColor= [UIColor colorWithRed:0 green:1 blue:0 alpha:1].CGColor;
                 
                 correoText.layer.borderWidth=2;
                 correoText.layer.borderColor= [UIColor colorWithRed:0 green:1 blue:0 alpha:1].CGColor;
                 exito=YES;
             
                 UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Registrado" message:@"Registro con exito"
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alertsuccess show];
                 
                 
                 
             }
             if([trimmedString isEqualToString:@"2"]){
                 NSLog(@"Usuario Existe");
                 usuarioText.layer.borderWidth=2;
                 usuarioText.layer.borderColor= [UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor;
         
                 UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Usuario" message:@"Ya existe este usuario"
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alertsuccess show];
                
                 
                 
             }
             if([trimmedString isEqualToString:@"3"]){
                 correoText.layer.borderWidth=2;
                correoText.layer.borderColor= [UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor;
                 
                 NSLog(@"Correo Existe");
           
                 UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Ya esta siendo usado este email"
                                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [alertsuccess show];
             
                 
                 
             }
             
             
         });}];

        
        
    }
    
    }
    if (registrar==NO) {
        if (registrando==YES) {
            registrando=NO;
        }
    // CUIDADO CON EL USUARIO EN BLANCO DEJA PASAR
    if ([usuarioText.text isEqualToString:@""] || [usuarioText.text isEqualToString:@" "] ) {
        NSLog(@"Blanco");
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Usuario en Blanco"
                                                              delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertsuccess show];
        

    }
        if ([contrasenaText.text isEqualToString:@""] || [contrasenaText.text isEqualToString:@" "] ) {
            NSLog(@"Blanco");
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Contraseña en Blanco"
                                                                  delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alertsuccess show];
            
            
        }
        else{
    
    // Show an activity spinner that blocks the whole screen
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.labelText = NSLocalizedString(@"Connecting", @"");
    
    //NSString *post =[NSString stringWithFormat:@"username=%@&password=%@",userText.text, ContraText.text];
    
    NSString *hostStr = @"http://lanchosoftware.es/app/api2.php";
    // hostStr = [hostStr stringByAppendingString:post];
    
    NSLog(@"%@",hostStr);
    

    
    NSString *_key = @"alvarol2611995";
    
        NSDate *myDate = [NSDate date];
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"dd"];
        
        _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
     NSLog(@" %@ key",_key);
        StringEncryption *crypto = [[StringEncryption alloc] init] ;

    
            NSString *tokenPush = [[NSUserDefaults standardUserDefaults] stringForKey:@"PushToken"];
            if ([tokenPush isEqualToString:@""]) {
                sleep(2);
                tokenPush = [[NSUserDefaults standardUserDefaults] stringForKey:@"PushToken"];
            }
  
	NSData *_secretData = [usuarioText.text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *_secretDataCon = [contrasenaText.text dataUsingEncoding:NSUTF8StringEncoding];

	CCOptions padding = kCCOptionPKCS7Padding;
	NSData *encryptedData = [crypto encrypt:_secretData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
	NSData *encryptedDataCon = [crypto encrypt:_secretDataCon key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
	NSLog(@"encrypted data in hex: %@", encryptedData);
	
	/*NSData *decryptedData = [crypto decrypt:encryptedData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
	
	NSLog(@"decrypted data in dex: %@", decryptedData);
	NSString *str = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"decrypted data string for export: %@",str);
     */
    NSString * encodedStringUsu = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL,
                                                                                   (CFStringRef)[encryptedData base64EncodingWithLineLength:0],
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                   kCFStringEncodingUTF8 ));
    NSString * encodedStringCon = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                     NULL,
                                                                                                     (CFStringRef)[encryptedDataCon base64EncodingWithLineLength:0],
                                                                                                     NULL,
                                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                     kCFStringEncodingUTF8 ));

	NSLog(@"encrypted data string for export: %@",[encryptedDataCon base64EncodingWithLineLength:0]);
    NSString * usuario = [NSString stringWithFormat:@"?username=%@",encodedStringUsu];
       NSString * contrasena = [NSString stringWithFormat:@"&password=%@",encodedStringCon ];
     NSString * date = [NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
                NSString * pushToken = [NSString stringWithFormat:@"&Ptoken=%@",tokenPush];
    NSLog(@"Usuario: %@",usuario);
    NSLog(@"Contrasena: %@",contrasena);
 
    hostStr= [hostStr stringByAppendingString:usuario];
    hostStr=[hostStr stringByAppendingString:contrasena];
    hostStr=[hostStr stringByAppendingString:date];
             hostStr=[hostStr stringByAppendingString:pushToken];
    
      NSLog(@"URL: %@",hostStr);
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:hostStr]];
            
            NSOperationQueue *cola = [NSOperationQueue new];
            // now lets make the connection to the web
            
            [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *datas, NSError *error)
             {
                  dispatch_async(dispatch_get_main_queue(), ^{
               
                 serverOutput = [[NSString alloc] initWithData:datas encoding: NSASCIIStringEncoding];
                 NSString *trimmedString = [serverOutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                 NSLog(@"%@ String",serverOutput);
                 
                 if([trimmedString isEqualToString:@"0"]){
                     usuarioText.layer.borderWidth=2;
                     usuarioText.layer.borderColor= [UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor;
                     
                     contrasenaText.layer.borderWidth=2;
                     contrasenaText.layer.borderColor= [UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor;
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Invalid Access"
                                                                           delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                     [alertsuccess show];
                     
                     
                 }
                 else {
                     
                     SBJsonParser *parser = [[SBJsonParser alloc] init];
                     CCOptions padding = kCCOptionECBMode;
                     NSString *_key = @"alvarol2611995";
                     
                     NSDate *myDate = [NSDate date];
                     NSDateFormatter *df = [NSDateFormatter new];
                     [df setDateFormat:@"dd"];
                     
                     _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
                     NSData *_secretData = [NSData dataWithBase64EncodedString:serverOutput];
                     
                     NSData *encryptedData = [crypto decrypt:_secretData  key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
                     NSString* newStr = [[NSString alloc]initWithData:encryptedData encoding:NSASCIIStringEncoding];
                     const char *convert = [newStr UTF8String];
                     NSString *responseString = [NSString stringWithUTF8String:convert];
                     
                     NSError *error =nil;
                     NSArray *returned = [parser objectWithString:responseString error:&error];
                     NSLog(@"%@",error);
                     
                     NSLog(@"%@ Data",encryptedData );
                     NSLog(@"%@ Array",newStr );
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     
                     for (NSDictionary *dict in returned){
                         
                         [defaults setObject:[dict objectForKey:@"id_Usuario"] forKey:@"ID_usuario"];
                         [defaults synchronize];
                         [defaults setObject:usuarioText.text forKey:@"usuario"];
                         [defaults setObject:[dict objectForKey:@"token"] forKey:@"token"];
                         [defaults setBool:YES forKey:@"Longeado"];
                         [defaults synchronize];
                         
                         
                         
                     }
                     
                     [autoTimer invalidate];
                     /*  UIViewController* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Principal"];
                      [self presentViewController:secondViewController animated:YES completion:nil];
                      [self.view removeFromSuperview];
                      */
                     [self Cambiar];
                     
                 }

                  });
             }];
            
            
            
         }
    NSLog(@"%@",serverOutput);
    }
    });
}

-(void)Comprobar{
    NSLog(@"Comprobar");
    if([serverOutput isEqualToString:@"Yes"]){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        usuarioText.layer.borderWidth=2;
        usuarioText.layer.borderColor= [UIColor colorWithRed:0 green:1 blue:0 alpha:1].CGColor;
        
        contrasenaText.layer.borderWidth=2;
        contrasenaText.layer.borderColor= [UIColor colorWithRed:0 green:1 blue:0 alpha:1].CGColor;
        NSLog(@"Longeado");
        [self Cambiar];
    }
    if([serverOutput isEqualToString:@"No"]){
        usuarioText.layer.borderWidth=2;
        usuarioText.layer.borderColor= [UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor;
        
        contrasenaText.layer.borderWidth=2;
        contrasenaText.layer.borderColor= [UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Invalid Access"
                                                              delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertsuccess show];
        
        
    }}
-(void)Cambiar{
    
    [keychain setString:usuarioText.text forKey:@"Usuario"];
    [keychain setString:contrasenaText.text forKey:@"Contrasena"];
    
    [keychain synchronize];
    
    
    COUNT =0;
     [autoTimer invalidate];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    CABasicAnimation *animY = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
    animY.duration = 0.6;
    animY.repeatCount = 1;
    animY.delegate=self;
    animY.removedOnCompletion = NO;
    animY.fillMode = kCAFillModeForwards;
    animY.toValue=[NSNumber numberWithFloat:-550];
    [phc.layer addAnimation:animY forKey:nil];
    animY.toValue=[NSNumber numberWithFloat:550];
    [aceptarB.layer addAnimation:animY forKey:nil];
       [registrarB.layer addAnimation:animY forKey:nil];
    
    CABasicAnimation *animx = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    
    animx.duration = 0.6;
    animx.repeatCount = 1;
    animx.delegate=self;
    animx.removedOnCompletion = NO;
    animx.fillMode = kCAFillModeForwards;
    animx.toValue=[NSNumber numberWithFloat:-550];
    [usuarioText.layer addAnimation:animx forKey:nil];
    animx.toValue=[NSNumber numberWithFloat:550];
    
    [contrasenaText.layer addAnimation:animx forKey:nil];
    
 
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
   
    
 /*   [aceptarB.layer removeAllAnimations];
      [registrarB.layer removeAllAnimations];
      [usuarioText.layer removeAllAnimations];
      [contrasenaText.layer removeAllAnimations];
      [phc.layer removeAllAnimations];
  */
    if (registrando ==NO) {
     
 
    if (COUNT == 4) {
 
    //UIViewController* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Principal"];
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 crear = NO;
                                 [autoTimer invalidate];
                                  [Imagenes removeAllObjects];
                                  [ImagesViewArray removeAllObjects];
                                 [viewS removeFromSuperview];
                                 [vistaFondo removeFromSuperview];
                                 
                             }];
    
    if (![self isBeingDismissed]){
      [self performSegueWithIdentifier:@"PrincipalS" sender:self];
    }
    }
    
    else {
        COUNT ++;
    }
    
    }
 
}

-(void)GetPhotos2{
    
    xz =[[NSMutableArray alloc]init];

    // collect the photos
       NSLog(@"Cargando XZ");
    ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];
    
    [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                      usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if ([xz count]> contador) {
            autoTimer= [NSTimer scheduledTimerWithTimeInterval:3.13
                                              target:self
                                            selector:@selector(cambiarFotos)
                                            userInfo:nil
                                             repeats:YES];
             *stop=YES;
         }
         [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
          {
              if ([xz count]>contador) {
                  *stop=YES;
              }
              if (asset) {
                  
                  UIImage *images = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                  CGSize size = CGSizeMake(64, 96);
                  [xz addObject:[self imageWithImage:images scaledToSizeWithSameAspectRatio:size]];
                
               
              }
          }];
         

         NSLog(@"Numero XZ : %d" ,[xz count]);

         
     }
                    failureBlock:^(NSError *error) { NSLog(@"Boom!!!");}
     ];
    
    
    
}

- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, [self radians:90]);
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, [self radians:-90]);
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, [self radians:-180]);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage; 
}
-(CGFloat) radians:(CGFloat) degrees
{
    CGFloat angle = degrees * M_PI / 180.0;
    return angle;
}
- (UIView *)collage:(NSMutableArray *)fotos
{
    ImagesViewArray=[[NSMutableArray alloc]init];
    UIView * vistaFotos = [[UIView alloc] initWithFrame:CGRectMake(0, 0,([[UIScreen mainScreen] applicationFrame].size.width) ,[[UIScreen mainScreen] applicationFrame].size.height)];
        vistaFotos.backgroundColor =[UIColor lightGrayColor];
    
    UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    interpolationHorizontal.minimumRelativeValue = @-10.0;
    interpolationHorizontal.maximumRelativeValue = @10.0;
    
    UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    interpolationVertical.minimumRelativeValue = @-10.0;
    interpolationVertical.maximumRelativeValue = @10.0;
    
    [viewS addMotionEffect:interpolationHorizontal];
    [viewS addMotionEffect:interpolationVertical];
    
    
    int numeroObjetos = 0;

    for (UIImage *image in fotos) {
        CGFloat X = 0.0;
        CGFloat Y = 0.0 ;
         if (numeroObjetos < 6) {
              X = image.size.width *numeroObjetos;
              Y = 0.0 ;
         } 
        if (numeroObjetos >= 6 && numeroObjetos < 11) {
            X = image.size.width *(numeroObjetos - 6);
            Y = 64;
        }
        if (numeroObjetos >= 11 && numeroObjetos < 16) {
            X = image.size.width *(numeroObjetos - 11);
            Y = 128;
        }
        if (numeroObjetos >= 16 && numeroObjetos < 21) {
            X = image.size.width *(numeroObjetos - 16);
            Y = 192;
        }
        if (numeroObjetos >= 21 && numeroObjetos < 26) {
            X = image.size.width *(numeroObjetos - 21);
            Y = 256;
        }
        if (numeroObjetos >= 26 && numeroObjetos < 31) {
            X = image.size.width *(numeroObjetos - 26);
            Y = 320;
        }
        if (numeroObjetos >= 31 && numeroObjetos < 36) {
            X = image.size.width *(numeroObjetos - 31);
            Y = 384;
        }
        
        if (numeroObjetos >= 36 && numeroObjetos < 41) {
            X = image.size.width *(numeroObjetos - 36);
            Y = 448;
        }
        if (numeroObjetos >= 41 && numeroObjetos < 46) {
            X = image.size.width *(numeroObjetos - 41);
            Y = 512;
        }
        
         numeroObjetos ++;
        
        CGFloat W = image.size.width ;
        CGFloat H = image.size.height;
      //  NSLog(@"X:%f Y:%f W:%f H:%f" ,X,Y,W,H);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, W, W)];
        imageView.layer.borderWidth=2.0;
        imageView.layer.borderColor=[UIColor whiteColor].CGColor;
        imageView.clipsToBounds=YES;
        imageView.layer.cornerRadius = 6.0;

        imageView.image=image;
        imageView.alpha=0;
        [ImagesViewArray addObject:imageView];
        [vistaFotos addSubview:imageView];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelay:0.1];
        imageView.alpha=10;
        [UIView commitAnimations];
        
       // NSLog(@"Numero Orden : %d" ,numeroObjetos);
    
    }
    if (numeroObjetos == 30){
        [Imagenes removeAllObjects];
        
    }
    contador=80;
     [self GetPhotos2];
    return vistaFotos;
}
-(void)cambiarFotos{
    dispatch_async(dispatch_get_main_queue(), ^{
    if (crear) {
        if ([ImagesViewArray count] != 0 && [xz count] != 0) {
       
    int foto = arc4random() %[xz count];
   // NSLog(@"Numero Orden INT : %d" ,foto);
    UIImage *imagen = [xz objectAtIndex:foto];
    UIImageView *view = [ImagesViewArray objectAtIndex:arc4random() %[ImagesViewArray count]];
        [self fadeView:view fadeOut:YES];
        view.image=imagen;
        view.clipsToBounds=YES;
        view.layer.cornerRadius = 8.0;
        [self fadeView:view fadeOut:NO];
        

        
  /*
    
    CATransition *transition = [CATransition animation];
    transition.duration = 4.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [view.layer addAnimation:transition forKey:nil];
   
        [vistaFondo addSubview:view];
        [fondo addObject:vistaFondo];
        [[fondo objectAtIndex:0] removeFromSuperview];
        [fondo removeObjectAtIndex:0];
 
    [self.view insertSubview:vistaFondo belowSubview:viewS];
       */
        
    [self.view reloadInputViews];
  //  [self.view insertSubview:vistaFondo atIndex:1];
        } }
    });
  
}
-(void)fadeView:(UIView *)thisView fadeOut:(BOOL)fadeOut {
    //   self.ReviewViewController.view.alpha = 1;
    
    [UIView beginAnimations:@"fadeOut" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    if (fadeOut) {
        thisView.alpha = 0;
    } else {
        thisView.alpha = 1;
    }
    [UIView commitAnimations];
}



- (void)memoryWarning:(NSNotification*)note {
    NSLog(@"MEMORIA");
   // [autoTimer invalidate];
  //  [Imagenes removeAllObjects];
   // [ImagesViewArray removeAllObjects];
}


-(IBAction)registrar:(id)sender{
    registrando=YES;
    if (registrar ==YES) {
        NSLog(@"NO Registrar");
       
        registrar=NO;
        
        
        CABasicAnimation *animY = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        
        animY.duration = 0.6;
        animY.repeatCount = 1;
        animY.delegate=self;
        animY.removedOnCompletion = NO;
        animY.fillMode = kCAFillModeForwards;
        animY.toValue=[NSNumber numberWithFloat:-20];
        [usuarioText.layer addAnimation:animY forKey:nil];
        animY.toValue=[NSNumber numberWithFloat:-10];
        [contrasenaText.layer addAnimation:animY forKey:nil];
        
        [UIView beginAnimations:@"fadeOut" context:nil];
        [UIView setAnimationDuration:1];
        
        correoText.alpha =0;
        [aceptarB setTitle:@"Longear" forState:UIControlStateNormal];
        [registrarB setTitle:@"Registrar" forState:UIControlStateNormal];
        [usuarioText reloadInputViews];
        [contrasenaText reloadInputViews];
        [aceptarB reloadInputViews];
        [registrarB reloadInputViews];
        
        [UIView commitAnimations];
        return;
    }
    if (registrar ==NO) {
        
     NSLog(@"Registrar");
     correoText.hidden =NO;
     correoText.alpha =0;
    registrar=YES;
        
        
        CABasicAnimation *animY = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        
        animY.duration = 0.6;
        animY.repeatCount = 1;
        animY.delegate=self;
        animY.removedOnCompletion = NO;
        animY.fillMode = kCAFillModeForwards;
        animY.toValue=[NSNumber numberWithFloat:20];
        [usuarioText.layer addAnimation:animY forKey:nil];
        animY.toValue=[NSNumber numberWithFloat:10];
        [contrasenaText.layer addAnimation:animY forKey:nil];
        
        
    [UIView beginAnimations:@"fadeOut" context:nil];
    [UIView setAnimationDuration:1];
   
    correoText.alpha =1;
    [aceptarB setTitle:@"Aceptar" forState:UIControlStateNormal];
    [registrarB setTitle:@"Cancelar" forState:UIControlStateNormal];
    [aceptarB reloadInputViews];
    [registrarB reloadInputViews];
    
     [UIView commitAnimations];
    }
}

- (void)viewDidLoad
{
    
    
    
    keychain =
    [UICKeyChainStore keyChainStoreWithService:@"com.LoginData"];
    
   
    if ([keychain stringForKey:@"Usuario"] && [keychain stringForKey:@"Contrasena"] ) {
        NSLog(@"Autologin");
        
    [usuarioText setText:[keychain stringForKey:@"Usuario"]];
    [contrasenaText setText:[keychain stringForKey:@"Contrasena"]];
    
    [self sendData:nil];
    }
  
    
    [aceptarB setTitle:@"Longear" forState:UIControlStateNormal];
    [registrarB setTitle:@"Registrar" forState:UIControlStateNormal];
    correoText.hidden=YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    crear =YES;
    Imagenes = [[NSMutableArray alloc] init];
    for (int i = 0;  i < 46; i++) {
        int u = i +1;
        UIImage * imagen = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",u]];
        [Imagenes addObject:imagen];
       // NSLog(@"OK");
    }
    
    usuarioText.clipsToBounds=YES;
    usuarioText.layer.cornerRadius = 8.0;
    contrasenaText.clipsToBounds=YES;
    contrasenaText.layer.cornerRadius = 8.0;
    correoText.clipsToBounds=YES;
    correoText.layer.cornerRadius = 8.0;

    
    
    fondo= [[NSMutableArray alloc]init];
    
   /* UIView * vistaFotos = [[UIView alloc] initWithFrame:CGRectMake(0, 0,([[UIScreen mainScreen] applicationFrame].size.width) ,[[UIScreen mainScreen] applicationFrame].size.height)];
    vistaFotos.backgroundColor =[UIColor blackColor];
    vistaFotos.clipsToBounds=YES;
    vistaFotos.layer.cornerRadius = 8.0;
    */
   
    [self.view addSubview:vistaFondo];
    [self.view sendSubviewToBack:vistaFondo];
    [usuarioText setDelegate:self];
    [contrasenaText setDelegate:self];
       [correoText setDelegate:self];
 
    [self.view reloadInputViews];
    
    vistaFondo = [self collage:Imagenes];
    NSLog(@"%d Numero Fotos", [Imagenes count]);
    [self.view addSubview: vistaFondo];
    [self.view sendSubviewToBack:vistaFondo];
     [fondo addObject:vistaFondo];
    [self GetPhotos2];
    
    [viewS setContentSize:[[self view] frame].size];
    
    //Notificaciones del teclado
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apareceElTeclado:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(desapareceElTeclado:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //Detección de toques en el scroll view
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPulsado)];
    [tapRecognizer setCancelsTouchesInView:NO];
	// Do any additional setup after loading the view.
    
    
     [super viewDidLoad];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [usuarioText resignFirstResponder];
        [contrasenaText resignFirstResponder];
           [correoText setDelegate:self];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"TEXT");
    textField.layer.borderWidth=2;
    textField.layer.borderColor= [UIColor colorWithRed:0.17 green:0.522 blue:0.725 alpha:1].CGColor;
    [self setCampoActivo:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField

{
    usuarioText.layer.borderWidth=0;
    
    
    contrasenaText.layer.borderWidth=0;
    
    
    correoText.layer.borderWidth=0;
    


    [self setCampoActivo:nil];
}
- (void) apareceElTeclado:(NSNotification *)laNotificacion
{
    NSLog(@"Aparece");
    NSDictionary *infoNotificacion = [laNotificacion userInfo];
    CGSize tamanioTeclado = [[infoNotificacion objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height+30, 0);
    [viewS setContentInset:edgeInsets];
    [viewS setScrollIndicatorInsets:edgeInsets];
    
    [viewS scrollRectToVisible:[self campoActivo].frame animated:YES];
}

- (void) desapareceElTeclado:(NSNotification *)laNotificacion
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.15];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [viewS setContentInset:edgeInsets];
    [viewS setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}

#pragma mark - Métodos de acción adicionales
- (void) scrollViewPulsado
{
    [[self view] endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
