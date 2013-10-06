//
//  Amigos.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 09/02/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "Perfil.h"
#import "SBJson.h"
#import "Imagenes.h"
#import "DescargaImagenes.h"
#import "Imagen.h"
#import "AsyncImageView.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPClient.h"
#import "Cache.h"


#define ITEM_SPACING 110

@interface Perfil ()
@property (nonatomic, retain)  NSMutableArray *items;

@property (nonatomic, assign) BOOL wrap;
@end

@implementation Perfil
@synthesize Amigo,Name,Estado,Imagen,Img,timer,timer2, imageURLs;
@synthesize carousel;
@synthesize items, wrap, flOperation,flUploadEngine;

-(IBAction)cambiarImagen:(id)sender{
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing=YES;
    imagePicker.view.clipsToBounds=YES;
    imagePicker.view.layer.cornerRadius = 8.0;
    [self presentViewController:imagePicker animated:YES completion:nil];
    // prueba 3
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [self dismissViewControllerAnimated:imagePicker completion:nil];
    sleep(3);
    [self uploadImage:image];
    [self actualizarFoto];
}
-(void)actualizarFoto{
  
    NSLog(@"Actualizar");
}

-(void) uploadImage:(UIImage *)image
{
    
    
    
    
    NSLog(@"Enviando");
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
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    
	CCOptions padding = kCCOptionECBMode;
	NSData *encryptedData = [crypto encrypt:imageData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
    
    NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.labelText = NSLocalizedString(@"Cargando", @"");
    
	
	/*NSData *decryptedData = [crypto decrypt:encryptedData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
     
     NSLog(@"decrypted data in dex: %@", decryptedData);
     NSString *str = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
     
     NSLog(@"decrypted data string for export: %@",str);
     */
    
    
    
    NSData* imagen=[[encryptedData base64EncodingWithLineLength:0] dataUsingEncoding:[NSString defaultCStringEncoding] ] ;
    
    
    NSString *post =[NSString stringWithFormat:@"id=%@",usuarioID];
    NSString *post2 =[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
    NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
    NSString *post4=[NSString stringWithFormat:@"&hora=%@",[hms stringFromDate:myDate]];
    NSString *post5=[NSString stringWithFormat:@"&token=%@",tokenID];
        NSString *post6=[NSString stringWithFormat:@"&perfil=1"];
     NSString *post7=[NSString stringWithFormat:@"&altura=320"];
    NSString *urlString= @"http://lanchosoftware.es/phc/imageupload.php?";
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
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"imagename.jpg\"\r\n",index] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imagen]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSOperationQueue *cola = [NSOperationQueue new];
    // now lets make the connection to the web
    
    __block Perfil* SelfB = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         if ( [returnString isEqualToString:@"Yes"]) {
             UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"OK" message:@"Foto Subida"
                                                                   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
             [alertsuccess show];
         }
         else{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"OK" message:@"Error"
                                                                   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
             [alertsuccess show];
         }
         self->returnData=[[NSData alloc]initWithData:data];
             
             [SelfB imagenPerfil];
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

-(void)desconectar{
    
     NSLog(@"Desconectar");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DatosGuardados"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ID_usuario"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"usuario"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    keychain =
    [UICKeyChainStore keyChainStoreWithService:@"com.LoginData"];
    [keychain removeItemForKey:@"Usuario"];
    [keychain removeItemForKey:@"Contrasena"];
    [keychain synchronize];
    
   
    
    
    [self performSegueWithIdentifier:@"LoginS" sender:self];
    
    
}


-(void)cerrar
{
    [imagenes removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)memoryWarning:(NSNotification*)note {
    NSLog(@"MEMORIA");
    [items removeAllObjects];
}
-(void)viewDidAppear:(BOOL)animated{
   // [self viewDidLoad];
    self.navigationController.navigationBar.topItem.title=@"Perfil";
}

-(void)recargar{
    NSLog(@"Recargar");
    
  // NSArray *array = [carousel indexesForVisibleItems];
    completado=NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [carousel reloadData];
    });
    
}

-(void)actualizar{
    NSArray * aV = [carousel indexesForVisibleItems];
    for (int i =0; i < [aV count]; i++) {
        NSLog(@"%@ Index",aV);
        [carousel reloadItemAtIndex:[aV objectAtIndex:i] animated:NO];
    }
    
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carouse{
    NSLog(@"LLamado a Actualizar");
 
    if ([carousel currentItemIndex ] ==0) {
        [carousel reloadItemAtIndex:[carousel currentItemIndex] animated:NO];
        [carousel reloadItemAtIndex:[carousel currentItemIndex]+1 animated:NO];
    }
    if ([carousel currentItemIndex ] ==[imageURLs count]) {
           [carousel reloadItemAtIndex:[carousel currentItemIndex]-1 animated:NO];
        [carousel reloadItemAtIndex:[carousel currentItemIndex] animated:NO];
        [carousel reloadItemAtIndex:[carousel currentItemIndex]+1 animated:NO];
    }
    else{
        [carousel reloadItemAtIndex:[carousel currentItemIndex]-1 animated:NO];
        [carousel reloadItemAtIndex:[carousel currentItemIndex] animated:NO];
       
    }
    
    
    
    
    //[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(actualizar) userInfo:nil repeats: YES];
   
}
-(void)imagenPerfil{
    

    NSDate* myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    NSDateFormatter *dma = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    [dma setDateFormat:@"dd-mm-yyyy"];
    
    NSString* _key = @"alvarol2611995";
    
    
    _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
    
    NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
    
    NSString *post2=[NSString stringWithFormat:@"date=%@",[df stringFromDate:myDate]];
    NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
    NSString *post4=[NSString stringWithFormat:@"&token=%@",tokenID];
    NSString *post5 =[NSString stringWithFormat:@"&id=%@",usuarioID];
    NSString *post6 =[NSString stringWithFormat:@"&perfil=1"];
    NSString *post7 =[NSString stringWithFormat:@"&vez=0"];
    
    NSString *post =[NSString stringWithFormat:@"&idF=%@",usuarioID];
    
    NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
    hostStr = [hostStr stringByAppendingString:post2];
    hostStr = [hostStr stringByAppendingString:post3];
    hostStr = [hostStr stringByAppendingString:post4];
    hostStr = [hostStr stringByAppendingString:post5];
    hostStr = [hostStr stringByAppendingString:post];
    hostStr = [hostStr stringByAppendingString:post7];
    hostStr = [hostStr stringByAppendingString:post6];

    
    
    
    //set image URL. AsyncImageView class will then dynamically load the image
    
    
    NSString *string = [[NSString alloc] initWithFormat:@"%@",hostStr];
    
    
    NSURL *urlT = [[NSURL alloc]initWithString:string];
     NSLog(@"%@ URl Pasada",urlT);

        NSLog(@"Reload Imagen Perfil");
    
        Img.layer.borderWidth=1.5;
        Img.layer.borderColor=[UIColor blackColor].CGColor;
  
        
       Img.clipsToBounds=YES;
        Img.layer.cornerRadius = 8.0;
        
    
      
        // now lets make the connection to the web


    __block Perfil * SelfB = self;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlT];
    
    [self.Img setImageWithURLRequest:urlRequest
                      placeholderImage:nil
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                   SelfB.Img.image = image;
                               } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                   NSLog(@"Failed to download image: %@", error);
                               }];
    
    
 
    
}
-(void)refrescar:(id)sender{
    /*vez=0;
      NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* string = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
    
    NSString* dataPath = [string stringByAppendingPathComponent:[NSString stringWithFormat:@"idF=%@",usuarioID]];
    
    NSString* Path = [string stringByAppendingPathComponent:@"Perfil"];
    
    NSString* dataPath2 = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"idF=%@.vez=0.perfil=1",usuarioID]];
    
    [[NSFileManager defaultManager] removeItemAtPath:dataPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:dataPath2 error:nil];
    
    
    for (int i =0; i<[imageURLs count]; i++) {
         [carousel removeItemAtIndex:i animated:NO];
    }
    imageURLs=nil;
       [imagenes removeAllObjects];
    Img.image= nil;
   
    [carousel reloadData];
    
      timer2= [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(act) userInfo:nil repeats: NO];
    [self viewDidLoad];
     */
    [imagenesCargadas removeAllObjects];
    completado=NO;
    vez=0;
    [carousel reloadData];
    [self imagenes];
}
-(void)act{
    
    [Img reloadInputViews];
    [carousel reloadInputViews];
    [self reloadInputViews];
        [self.view reloadInputViews];
    [Img setNeedsDisplay];
    [self.view setNeedsDisplay];
    act=YES;
    [self viewDidLoad];
   
}
- (void)viewDidLoad
{
    
     [NSTimer scheduledTimerWithTimeInterval:4 target:carousel selector:@selector(reloadData) userInfo:nil repeats: NO];
    
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
      self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

     self.carousel.centerItemWhenSelected = NO;
       
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Salir"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(desconectar)];
    UIBarButtonItem *RefrescarButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                        target:self
                                        action:@selector(refrescar:)];
    
    
    self.navigationItem.leftBarButtonItem = flipButton;
    self.navigationItem.rightBarButtonItem=RefrescarButton;
 
    [RefrescarButton release];
    [flipButton release];
    
  
    
      self.view.backgroundColor = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];
    carousel.backgroundColor   = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];
     self.navigationController.navigationBar.topItem.title=@"Perfil";
   /* UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:  self.navigationController.navigationBar.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(8.0, 8.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.navigationController.navigationBar.layer.mask = maskLayer;
      //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.17 green:0.522 blue:0.725 alpha:1];
    */
 
        //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    if(act == NO){
        [self imagenPerfil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrescar:) name:@"ActualizarPerfil" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    // self.view.backgroundColor=[UIColor grayColor];
    items=[[NSMutableArray alloc]init];
    Img.clipsToBounds=YES;
    

    /*
     self.view.clipsToBounds=YES;
     self.view.layer.cornerRadius=15.0;
     self.view.frame=CGRectMake(20, 10, 280, 350);
     self.view.layer.borderWidth=3.0;
     self.view.layer.borderColor=[UIColor blackColor].CGColor;
     
     carousel.layer.borderWidth=1.5;
     carousel.layer.borderColor=[UIColor blackColor].CGColor;
     carousel.clipsToBounds=YES;
     carousel.layer.cornerRadius = 8.0;
     */

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *datos = [defaults objectForKey:@"DatosAmigo"];
    usuario = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
    Name.text=[defaults objectForKey:@"usuario"];
    Img.image=usuario.imagen;
    Amigo=usuario.usuario;
    ID=usuario.ID;
    
    
    
    [self.view reloadInputViews];
    carousel.type = iCarouselTypeLinear;
    //timer= [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(imagenes) userInfo:nil repeats:YES];
    [self imagenes];
    // [NSTimer scheduledTimerWithTimeInterval:35 target:self selector:@selector(getData) userInfo:nil repeats:YES];
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)imagenes{
    
    NSLog(@"Obteniendo datos");
    NSDate *myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    
    NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
    
    NSString *post1 =[NSString stringWithFormat:@"id=%@",usuarioID];
    NSString *post2 =[NSString stringWithFormat:@"&vez=%d",vez];
    NSString *post3=[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
    NSString *post4=[NSString stringWithFormat:@"&token=%@",tokenID];
    NSString *post5 =[NSString stringWithFormat:@"&idF=%@",usuarioID];
    NSString *post6 =[NSString stringWithFormat:@"&perfil=3"];
    
    
    
    NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
    hostStr = [hostStr stringByAppendingString:post1];

    hostStr = [hostStr stringByAppendingString:post3];
    hostStr = [hostStr stringByAppendingString:post4];
    hostStr = [hostStr stringByAppendingString:post5];
        hostStr = [hostStr stringByAppendingString:post2];
    hostStr = [hostStr stringByAppendingString:post6];
    
    NSLog(@"%@ URL Imagenes",hostStr);
    
    
    /*
     
     self.flUploadEngine = [[fileUploadEngine alloc] initWithHostName:@"lanchosoftware.es" customHeaderFields:nil];
     [self.flUploadEngine cacheMemoryCost];
     
     
     __weak typeof(self) weakSelf = self;
     self.flOperation = [self.flUploadEngine postDataToServer:nil path:hostStr post:NO];
     [self.flOperation addCompletionHandler:^(MKNetworkOperation* operation) {
     
     
     if([operation isCachedResponse]) {
     NSLog(@"Data from cache");
     }
     else {
     NSLog(@"Data from server");
     }
     
     NSData *datas = [operation responseData];
     NSString *_key = @"alvarol2611995";
     
     
     _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
     CCOptions padding = kCCOptionECBMode;
     NSString *string = [[NSString alloc] initWithData:datas encoding:NSASCIIStringEncoding];
     NSData *_secretData = [NSData dataWithBase64EncodedString:string];
     
     NSData *encryptedData = [crypto decrypt:_secretData  key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
     
     NSString *returnString = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
     
     if ([returnString isEqualToString:@"No"]) {
     [ weakSelf.flUploadEngine cancelAllOperations];
     if ([ weakSelf.items count]==0) {
     [ weakSelf.carousel removeFromSuperview];
     }
     else{
     NSLog(@"Array: %@",  weakSelf.items);
     NSLog(@"Terminado numero: %lu", (unsigned long)[ weakSelf.items count]);
     // [timer invalidate];
     //   Imagen= [items objectAtIndex:3];
     //  Img.image=Imagen;
     vez=0;
     [ weakSelf.carousel reloadData];
     }
     
     
     }
     else{
     if (![self isJPEGValid:encryptedData]) {
     NSLog(@"Invalido");
     }
     UIImage *imagen =[[UIImage alloc]initWithData:encryptedData];
     if (imagen != nil) {
     [items addObject:imagen];
     NSLog(@"Imagen data: %lu , Vez: %d", (unsigned long)[encryptedData length], vez);
     }
     
     else{
     NSLog(@"Invalido NIL");
     }
     vez++;
     [self imagenes];
     
     }}
     
     errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
     NSLog(@"%@", error);
     UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Error"
     message:[error localizedDescription]
     delegate:nil
     cancelButtonTitle:@"Dismiss"
     otherButtonTitles:nil];
     [alert2 show];
     }];
     
     [self.flUploadEngine useCache];
     [self.flUploadEngine enqueueOperation:self.flOperation ];
     
     */
    UIImageView * imgL= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"placeholder.png"]];
    imgL.frame= CGRectMake(0, 0, 100, 100);
    
    imagenesCargadas = [[NSMutableArray alloc]init];

    
    NSMutableArray *URLs = [[NSMutableArray alloc]init];
    UrlDatos=[[NSMutableArray alloc]init];
    [URLs removeAllObjects];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:hostStr]];
    
    NSOperationQueue *cola = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *datas, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
         NSString *  serverOutput = [[NSString alloc] initWithData:datas encoding: NSASCIIStringEncoding];
         int fotos = serverOutput.intValue;
             NSLog(@"Fotos Int : %d",fotos);
         while (vez<fotos) {
             
             NSString *vezS = [NSString stringWithFormat:@"%d", vez];
             NSDate* myDate = [NSDate date];
             NSDateFormatter *df = [NSDateFormatter new];
             NSDateFormatter *dma = [NSDateFormatter new];
             [df setDateFormat:@"dd"];
             [dma setDateFormat:@"dd-mm-yyyy"];
             
             NSString* _key = @"alvarol2611995";
             
             
             _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
             
             NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
             NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
             
             NSString *post2=[NSString stringWithFormat:@"date=%@",[df stringFromDate:myDate]];
             NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
             NSString *post4=[NSString stringWithFormat:@"&token=%@",tokenID];
             NSString *post5 =[NSString stringWithFormat:@"&id=%@",usuarioID];
             NSString *post6 =[NSString stringWithFormat:@"&perfil=0"];
             NSString *post7 =[NSString stringWithFormat:@"&vez=%@",vezS];
             NSString *post8 =[NSString stringWithFormat:@"&borde=1"];
             
             NSString *post =[NSString stringWithFormat:@"&idF=%@",usuarioID];
             
             NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
            
             hostStr = [hostStr stringByAppendingString:post2];
             hostStr = [hostStr stringByAppendingString:post3];
             hostStr = [hostStr stringByAppendingString:post4];
             hostStr = [hostStr stringByAppendingString:post5];
              hostStr = [hostStr stringByAppendingString:post];
              hostStr = [hostStr stringByAppendingString:post7];
             hostStr = [hostStr stringByAppendingString:post6];
             
             
             
            //  hostStr = [hostStr stringByAppendingString:post6];
             [imagenesCargadas addObject:imgL];
             [URLs addObject:[NSURL URLWithString:hostStr]];
         
             vez ++;
         }
 
         NSLog(@"Terminado");
             if (URLs != nil ) {
                 NSMutableArray * URLSInvertida = [[NSMutableArray alloc]init];
                 int UrlI = [URLs count] -1;
                 for (int i = UrlI ; i >= 0; i--) {
                     NSString *hostStr  = [URLs objectAtIndex:i];
                     [URLSInvertida addObject:hostStr];
                 }
                 UrlDatos = [NSMutableArray arrayWithArray:URLSInvertida];
                 self.imageURLs =[NSMutableArray arrayWithArray:URLSInvertida];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [carousel reloadData];
                     [self CargarImagenes];
                     
                     sleep(3);
                     
                     NSInteger iC = [carousel numberOfItems];
                     NSLog(@" %d Numero Carrusel", iC);
                      NSLog(@" %d Numero Array", [UrlDatos count]);
                      NSLog(@" %d Numero Array Recibida", [URLs count]);
                     
                     
                 });
              
                         //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(recargar) userInfo:nil repeats:NO];
                 
             }
             else{
                 NSLog(@"No tiene Fotos");
             }
         
   
         }); }];
    
    
}
-(void)CargarImagenes{
    imagenesCargadas = [[NSMutableArray alloc]init];
    AFHTTPClient *httpClient  = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
      [httpClient.operationQueue setMaxConcurrentOperationCount:1] ;
    NSMutableArray *operationsArray = [NSMutableArray array];
    for (NSURL *imageURL in self.imageURLs) {
        

    
          
        
        AFImageRequestOperation *getImageOperation =
        [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:imageURL]
                                             imageProcessingBlock:nil
                                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                              //
                                                              // Save image
                                                              //
                                                              
                                                              [imagenesCargadas addObject:image];
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
                                          
                                          NSLog(@"Imagenes: %lu", (unsigned long)[imagenesCargadas count]);
                                    
                                          
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [carousel reloadData];
                                               completado=YES;
                                             /* for (int i =0; i< [imagenesCargadas count]; i++) {
                                                //  UIImageView *Img = [[UIImageView alloc]initWithImage:[imagenesCargadas objectAtIndex:i]];
                                                  UIImage * image = [imagenesCargadas objectAtIndex:i];
                                                  [carousel reloadInputViews];
                                                  [carousel reloadItemAtIndex:i animated:NO];
                                              }*/
                                           });
                                          
                                          
                                      }];
}





- (BOOL)isJPEGValid:(NSData *)jpeg {
    if ([jpeg length] < 4) return NO;
    const unsigned char * bytes = (const unsigned char *)[jpeg bytes];
    if (bytes[0] != 0xFF || bytes[1] != 0xD8) return NO;
    if (bytes[[jpeg length] - 2] != 0xFF ||
        bytes[[jpeg length] - 1] != 0xD9) return NO;
    return YES;
}

-(void)terminado{
    NSLog(@"Terminado2");
    dispatch_async(dispatch_get_main_queue(), ^{
        [carousel reloadData];
    });
}

-(void)Carrusel{
    
    NSLog(@"Carrosuel LLamado3");
    
    
    carousel.type = iCarouselTypeCoverFlow2;
    
    carousel.dataSource = self;
    carousel.delegate =self;
    
    
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if ([imageURLs count] == 0) {
         NSLog(@"0 URLS");
        return 0;
    }
    else{
        return [imageURLs count];
    }
}


- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //UIButton *button = (UIButton *)view;
    /*
     UIImage *image =[[UIImage alloc] init];
     //no button available to recycle, so create new one
     if ([items count] != 0) {
     NSLog(@"Index: %d", index);
     image = [items objectAtIndex:index];
     }
     */


    
    //cancel any previously loading images for this view
   	if (view == nil)
	{
        
		//no button available to recycle, so create new one
       
            
            
   view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 106, 160)] autorelease];
      
    /*
        __block UIView * SelfB = view;
        //__block UIView * viewB = imgv;
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL: [imageURLs objectAtIndex:index]];
        urlRequest.timeoutInterval=120;
        
        [(UIImageView*)view setImageWithURLRequest:urlRequest
                                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             //  ((UIImageView*)SelfB).image=image;
                                               
                                               
                                           } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                               NSLog(@"Failed to download image: %@", error);
                                          
                                           }];
     
*/
   
     
            view.contentMode = UIViewContentModeScaleAspectFit;
        
        
         [view setUserInteractionEnabled:YES];
        
           UIButton *  button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height);
        button.tag=index;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            button.titleLabel.font = [button.titleLabel.font fontWithSize:50];
            [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
       
        
        [view addSubview:button];
        
     

            
//[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
    
    if (completado == YES) {
        NSLog(@"Cargando imagen : %lu",(unsigned long)index);
      //  UIImageView * Img = [[UIImageView alloc]initWithImage:[imagenesCargadas objectAtIndex:index]];
        if([imagenesCargadas objectAtIndex:index] != nil){
        ((UIImageView *)view).image= [imagenesCargadas objectAtIndex:index];
        }
      //  view.backgroundColor =[UIColor blueColor];
    //    view.layer.borderWidth= 2.0;
       // view.layer.borderColor= [UIColor blackColor].CGColor;
    }
 

  //  UIImageView *imgv = (UIImageView *)view;

    

    return view;
    
    
}


- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
      
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"imagen2"]) {
        /*    UINavigationController *navigationController = segue.destinationViewController;
         Imagenes *SecondViewController =[[navigationController viewControllers]objectAtIndex:0];
         
         UIImage *image = [items objectAtIndex:indexTocado];
         [SecondViewController setImageFondo:image];
         */
        
  [segue.destinationViewController setHeight:height];
        [segue.destinationViewController setUrl:Url];
        
        
    }
    
}

- (void)buttonTapped:(UIButton *)sender
{
	//get item index for button
    
    indexTocado = [carousel indexOfItemViewOrSubview:sender];

   
      NSLog(@"%d index",indexTocado);
    if (indexTocado <= [UrlDatos count]) {
        
Url = [[UrlDatos objectAtIndex:indexTocado] absoluteString];
    NSLog(@"%@ URL index",Url);
    
    width=sender.frame.size.width;
    height=sender.frame.size.height*3;
    
    Imagenes* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Imagenes"];
            NSLog(@"%f Altura", height);
    
    [self performSegueWithIdentifier:@"imagen2" sender:self];
    /* [secondViewController willMoveToParentViewController:self];
     [self.parentViewController addChildViewController:secondViewController];
     CATransition *transition = [CATransition animation];
     transition.duration = 0.5;
     transition.type = kCATransitionReveal ;//choose your animation
     [secondViewController.view.layer addAnimation:transition forKey:nil];
     
     [self.parentViewController.view addSubview:secondViewController.view];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"Ocultar" object:nil];
     
     [self.parentViewController.view bringSubviewToFront:secondViewController.view];
     [secondViewController didMoveToParentViewController:self];
     */
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"Ocultar" object:nil];
    [self.parentViewController presentViewController:secondViewController animated:YES completion:nil];
    
    
    
    }}


- (void)viewDidUnload
{
    
    label = nil;
    volver = nil;
    Img = nil;
    Name = nil;
    Estado = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)viewWillAppear:(BOOL)animated{

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end