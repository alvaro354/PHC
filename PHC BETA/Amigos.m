//
//  Amigos.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 09/02/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "Amigos.h"
#import "SBJson.h"
#import "Imagenes.h"
#import "PrivadosViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPClient.h"
#import "AFImageRequestOperation.h"

#define ITEM_SPACING 110

@interface Amigos ()
@property (nonatomic, retain)  NSMutableArray *items;

@property (nonatomic, assign) BOOL wrap;
@end

@implementation Amigos
@synthesize Amigo,Name,Estado,Imagen,Img,timer,timer2,imageURLs,ID,UrlPasada;
@synthesize carousel;
@synthesize items, wrap, flOperation,flUploadEngine,Etiquetas;

-(IBAction)mensaje:(id)sender{
   //  [self performSegueWithIdentifier:@"PrivadoS" sender:self];
    
    UIViewController* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Privado"];
    [secondViewController willMoveToParentViewController:self];
    [self.parentViewController addChildViewController:secondViewController];
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.type = kCATransitionFade;//choose your animation
    [secondViewController.view.layer addAnimation:transition forKey:nil];
   // secondViewController.view.center=self.parentViewController.view.center;
    // [secondViewController.view setFrame:CGRectMake(0, 0, self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.height)];
    [self.parentViewController.view addSubview:secondViewController.view];
    
    
    [secondViewController didMoveToParentViewController:self];
}

-(IBAction)volver:(id)sender{
    /*
    UIView *icon =self.view;
    
    //move along the path
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:icon.center];
    [movePath addQuadCurveToPoint:pointCell
                     controlPoint:CGPointMake(pointCell.x, icon.center.y)];
    
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    moveAnim.removedOnCompletion = YES;
    
    
    //Scale Animation
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1,0.1, 1.0)];
    scaleAnim.removedOnCompletion = YES;
    
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, nil];
    animGroup.duration = 0.3;
    animGroup.removedOnCompletion=NO;
    animGroup.fillMode=kCAFillModeForwards;
    [icon.layer addAnimation:animGroup forKey:nil];
    [NSTimer scheduledTimerWithTimeInterval: animGroup.duration
                                     target: self
                                   selector: @selector(cerrar)
                                   userInfo: nil
                                    repeats: NO];
     */
    [self cerrar];
    
    
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
-(void)refrescar:(id)sender{
    
  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* string = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
    
    NSString* dataPath = [string stringByAppendingPathComponent:[NSString stringWithFormat:@"idF=%@",ID]];
    
    NSString* Path = [string stringByAppendingPathComponent:@"Perfil"];
    
    NSString* dataPath2 = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"idF=%@.vez=0.perfil=1",ID]];
    
    [[NSFileManager defaultManager] removeItemAtPath:dataPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:dataPath2 error:nil];
    
    /*
    for (int i =0; i<[imageURLs count]; i++) {
        [carousel removeItemAtIndex:i animated:NO];
    }
     */
    vez=0;
    imageURLs = nil;
   
    [UrlDatos removeAllObjects];
    Img.image= nil;
     completado=NO;
    [imagenesCargadas removeAllObjects];
    [carousel reloadData];
    
   // timer2= [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(act) userInfo:nil repeats: NO];
    [self viewDidLoad];
}



- (void)viewDidLoad
{
    
    UIBarButtonItem *RefrescarButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                        target:self
                                        action:@selector(refrescar:)];
    
    
  
    self.navigationItem.rightBarButtonItem=RefrescarButton;
    
    [RefrescarButton release];
   

    
 self.carousel.centerItemWhenSelected = NO;
    self.view.backgroundColor = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];
    carousel.backgroundColor   = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];
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
    Img.layer.borderWidth=1.5;
    Img.layer.borderColor=[UIColor blackColor].CGColor;
    
    
    Img.clipsToBounds=YES;
    Img.layer.cornerRadius = 8.0;
    
    NSURL *urlT;
    
    //set image URL. AsyncImageView class will then dynamically load the image
     
    if (UrlPasada!=Nil) {
    
    NSString *string = [[NSString alloc] initWithString:(NSString*)UrlPasada];
   
    urlT =[[NSURL alloc]initWithString:string];
        
        
    }
   else {
       
        NSLog(@"URL vacia Generando...");
        NSDate* myDate = [NSDate date];
        NSDateFormatter *df = [NSDateFormatter new];
        NSDateFormatter *dma = [NSDateFormatter new];
        [df setDateFormat:@"dd"];
        [dma setDateFormat:@"dd-mm-yyyy"];
        
        NSString* _key = @"alvarol2611995";
        
        
        _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
        
        NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
        
        NSString *post2=[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
        NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
        NSString *post4=[NSString stringWithFormat:@"&token=%@",tokenID];
        NSString *post5 =[NSString stringWithFormat:@"&id=%@",usuarioID];
        NSString *post6 =[NSString stringWithFormat:@"&perfil=1"];
        NSString *post7 =[NSString stringWithFormat:@"&vez=0"];
        
        NSString *post =[NSString stringWithFormat:@"idF=%@",ID];
        
        NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
        hostStr = [hostStr stringByAppendingString:post];
        hostStr = [hostStr stringByAppendingString:post2];
        hostStr = [hostStr stringByAppendingString:post3];
        hostStr = [hostStr stringByAppendingString:post4];
        hostStr = [hostStr stringByAppendingString:post5];
        hostStr = [hostStr stringByAppendingString:post6];
        hostStr = [hostStr stringByAppendingString:post7];
urlT = [[NSURL alloc]initWithString:hostStr];
        
    }
    

   
    // now lets make the connection to the web
    
   
    
    __block Amigos * SelfB = self;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlT];
    
    [self.Img setImageWithURLRequest:urlRequest
                    placeholderImage:nil
                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                 SelfB.Img.image = image;
                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                 NSLog(@"Failed to download image: %@", error);
                             }];

    
    
    

    self.title=Amigo;
 

    
    [self.view addSubview:Img];
    
    Name.text=Amigo;


 
 
   
    [self.view reloadInputViews];
    carousel.type = iCarouselTypeLinear;
    //timer= [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(imagenes) userInfo:nil repeats:YES];
    [self imagenes];
 // [NSTimer scheduledTimerWithTimeInterval:35 target:self selector:@selector(getData) userInfo:nil repeats:YES];
    if (Etiquetas == YES) {
        self.navigationController.navigationBar.barTintColor= [UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
        self.navigationController.navigationBar.tintColor= [UIColor whiteColor];
       
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIBarButtonItem * bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cerrarV)];
        
        
         self.navigationItem.leftBarButtonItem=bar;
        NSLog(@"Etiquetas Amigos");
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)cerrarV{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.view removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated{
     [self.view reloadInputViews];
     self.navigationController.navigationBar.backItem.title = @"Amigos";
    self.navigationController.navigationBar.topItem.title=Amigo;
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
    NSString *post5 =[NSString stringWithFormat:@"&idF=%@",ID];
    NSString *post6 =[NSString stringWithFormat:@"&perfil=3"];
    
    
    
    NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
    hostStr = [hostStr stringByAppendingString:post1];
   
    hostStr = [hostStr stringByAppendingString:post3];
    hostStr = [hostStr stringByAppendingString:post4];
    hostStr = [hostStr stringByAppendingString:post5];
     hostStr = [hostStr stringByAppendingString:post2];
    hostStr = [hostStr stringByAppendingString:post6];
    NSLog(@"%@ URL",hostStr);
    
    
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
    
    NSMutableArray *URLs = [NSMutableArray array];
    UrlDatos=[NSMutableArray array];
    [URLs removeAllObjects];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:hostStr]];
    
    NSOperationQueue *cola = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *datas, NSError *error)
     {
         NSString *  serverOutput = [[NSString alloc] initWithData:datas encoding: NSASCIIStringEncoding];
         int fotos = serverOutput.intValue;
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
             
             NSString *post =[NSString stringWithFormat:@"&idF=%@",ID];
             
             NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
             
             hostStr = [hostStr stringByAppendingString:post2];
             hostStr = [hostStr stringByAppendingString:post3];
             hostStr = [hostStr stringByAppendingString:post4];
             hostStr = [hostStr stringByAppendingString:post5];
             hostStr = [hostStr stringByAppendingString:post];
             hostStr = [hostStr stringByAppendingString:post7];
             hostStr = [hostStr stringByAppendingString:post6];
          
            // NSLog(@"URL ANTES: %@",hostStr);
             
             [UrlDatos addObject:hostStr];
             
             //hostStr = [hostStr stringByAppendingString:post6];
             // NSLog(@"URL despues: %@",hostStr);
             [URLs addObject:[NSURL URLWithString:hostStr]];
             
             vez ++;
         }
         
         NSLog(@"Terminado");
         if (URLs != nil ) {
         self.imageURLs =URLs;
            /*  dispatch_async(dispatch_get_main_queue(), ^{
         [carousel reloadData];
              });*/
             [self CargarImagenes];
         }
         else{
             NSLog(@"No tiene Fotos");
         }
     }];
    
    
}
-(void)CargarImagenes{
    __block BOOL Error =NO;
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
                                                              if (image!=nil) {
                                                                  [imagenesCargadas addObject:image];
                                                              }else{
                                                                  NSLog(@"Image request Cache error!");
                                                                  Error=YES;
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
                                          //
                                          // Handle process indicator
                                          //
                                          //   NSLog(@"Imagenes: %@", imagenesCargadas);
                                          //  NSLog(@"Completado");
                                      } completionBlock:^(NSArray *operations) {
                                          //
                                          // Remove blocking dialog, do next tasks
                                          //+
                                          if (Error) {
                                              [self refrescar:nil];

                                          }
                                          else{
                                          NSLog(@"Imagenes: %lu", (unsigned long)[imagenesCargadas count]);
                                          
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                               completado=YES;
                                              [carousel reloadData];
                                             
                                              /* for (int i =0; i< [imagenesCargadas count]; i++) {
                                               //  UIImageView *Img = [[UIImageView alloc]initWithImage:[imagenesCargadas objectAtIndex:i]];
                                               UIImage * image = [imagenesCargadas objectAtIndex:i];
                                               [carousel reloadInputViews];
                                               [carousel reloadItemAtIndex:i animated:NO];
                                               }*/
                                          });}
                                          
                                          
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
   // [carousel reloadData];
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
-(void)act{
    
    [Img reloadInputViews];
    [carousel reloadInputViews];
    [self reloadInputViews];
    [self.view reloadInputViews];
    [Img setNeedsDisplay];
    [self.view setNeedsDisplay];
   
    //[self viewDidLoad];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"imagen2"]) {
        /*    UINavigationController *navigationController = segue.destinationViewController;
         Imagenes *SecondViewController =[[navigationController viewControllers]objectAtIndex:0];
         
         UIImage *image = [items objectAtIndex:indexTocado];
         [SecondViewController setImageFondo:image];
         */
        
        [segue.destinationViewController setUrl:Url];
        
        
    }
    if ([segue.identifier isEqualToString:@"PrivadoS"]) {
        
        [segue.destinationViewController setID:ID];
     
        
    }
    
}

- (void)buttonTapped:(UIButton *)sender
{
	//get item index for button
indexTocado = [carousel indexOfItemViewOrSubview:sender];

    if (indexTocado <= [UrlDatos count]) {
        
        Url = [UrlDatos objectAtIndex:indexTocado];
        
        
        width=sender.frame.size.width;
        height=sender.frame.size.height;
        
        UIViewController* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Imagenes"];
        
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



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end