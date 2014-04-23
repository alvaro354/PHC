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
@synthesize vistaOpciones,vistaPerfil;

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
     NSLog(@"Subir");
    [[Descargar alloc] subirImagen:image perfil:1];
    sleep(2);
    [self actualizarFoto];
}
-(void)actualizarFoto{
  
    NSLog(@"Actualizar");
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
    

    usuario= [[Usuario alloc]init];
    usuario.ID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
    NSMutableArray * usuarioA = [[NSMutableArray alloc]init];
    [usuarioA addObject:usuario];
    
    [[Descargar alloc]descargarImagenPerfil:usuarioA grupo:@"Perfil" completationBlock:^(NSMutableArray *imagenesDescargadas) {
        
        if (usuario==nil) {
            usuario=[[Usuario alloc]init];
            
        }
        
        for (UIImage * imagen in imagenesDescargadas) {
            usuario.imagen=imagen;
            NSLog(@"Imagen Perfil Obtenida");
        }
        
        //  Img=[[UIImageView alloc]init];
        Img.layer.borderWidth=1.5;
        Img.layer.borderColor=[UIColor blackColor].CGColor;
        
        
        Img.clipsToBounds=YES;
        Img.layer.cornerRadius = 8.0;
        Img.image=usuario.imagen;
        
        [Img reloadInputViews];
        [self.view reloadInputViews];
        
        NSData *datos = [NSKeyedArchiver archivedDataWithRootObject:usuario];
        [[NSUserDefaults standardUserDefaults] setObject:datos forKey:@"Usuario"];
        
    }];
   
    
    [usuarioA removeAllObjects];
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* string = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
    NSString * tempS = [[NSString alloc]initWithFormat:@"idF=%@",usuarioID];
    NSString* dataPath = [string stringByAppendingPathComponent:tempS];
    
 //   NSLog(@"Ruta cache: %@ ",dataPath);
    [[NSFileManager defaultManager] removeItemAtPath:dataPath error:nil];

    
    [imagenesCargadas removeAllObjects];
    [UrlDatos removeAllObjects];
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
-(void)viewWillAppear:(BOOL)animated{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSData *datos = [defaults objectForKey:@"DatosAmigo"];
     usuario = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
     Name.text=[defaults objectForKey:@"usuario"];
     // Img.image=usuario.imagen;
     Amigo=usuario.usuario;
     ID=usuario.ID;
     
     
     
     [self.view reloadInputViews];
     carousel.type = iCarouselTypeLinear;
     //timer= [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(imagenes) userInfo:nil repeats:YES];
    [self imagenPerfil];
    [self imagenes];
}
- (void)viewDidLoad
{
    
    NSLog(@"Perfil");
    
    vistaPerfil.layer.borderColor= [UIColor grayColor].CGColor;
    vistaPerfil.layer.borderWidth=1;
    vistaOpciones.layer.borderColor= [UIColor grayColor].CGColor;
    vistaOpciones.layer.borderWidth=1;
    
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0.47 green:0.4 blue:0.78 alpha:1];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
      self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

     self.carousel.centerItemWhenSelected = NO;
    self.carousel.clipsToBounds=YES;
       
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
    //carousel.backgroundColor   = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];
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
      
        //Cargar imagen perfil
        
        //[self imagenPerfil];
        
        
    
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

    
    // [NSTimer scheduledTimerWithTimeInterval:35 target:self selector:@selector(getData) userInfo:nil repeats:YES];
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}





- (void) imagenes{
    
    NSLog(@"Obteniendo datos");
    NSDate *myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    
    NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
    
    NSString *post1 =[NSString stringWithFormat:@"userID=%@",usuarioID];
    NSString *post2 =[NSString stringWithFormat:@"&vez=%d",vez];
    NSString *post3=[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
    NSString *post4=[NSString stringWithFormat:@"&token=%@",tokenID];
    NSString *post5 =[NSString stringWithFormat:@"&idF=%@",usuarioID];
    NSString *post6 =[NSString stringWithFormat:@"&perfil=3"];
    
    
    
    NSString *hostStr = @"http://lanchosoftware.com:8080/PHC/descargarImagenes.php?";
    hostStr = [hostStr stringByAppendingString:post1];

    hostStr = [hostStr stringByAppendingString:post3];
    hostStr = [hostStr stringByAppendingString:post4];
    hostStr = [hostStr stringByAppendingString:post5];
        hostStr = [hostStr stringByAppendingString:post2];
    hostStr = [hostStr stringByAppendingString:post6];
    
    NSLog(@"%@ URL Imagenes",hostStr);
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
             usuario= [[Usuario alloc]init];
             usuario.ID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
             NSMutableArray * usuarioA = [[NSMutableArray alloc]init];
             [usuarioA addObject:usuario];
             
           //  [[Descargar alloc]descargarImagenes:usuarioA grupo:@"Fotos" fotos:fotos];
             [[Descargar alloc]descargarImagenes:usuarioA grupo:@"Fotos" fotos:fotos completationBlock:^(NSMutableArray *imagenesDescargadas) {
                 imagenesCargadas= [[NSMutableArray alloc]initWithArray:imagenesDescargadas];
                 completado=YES;
                 [carousel reloadData];
             }];
              
    
         }); }];
    
    
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
    if ([imagenesCargadas count] == 0) {
         NSLog(@"0 URLS");
        return 0;
    }
    else{
        NSLog(@"Imagenes en el carrousel: %d", [imagenesCargadas count]);
        return [imagenesCargadas count];
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
            
        ((UIImageView *)view).image= ((Imagen*)[imagenesCargadas objectAtIndex:index]).imagen;
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
        [segue.destinationViewController setImagenPasar:imagenPasar];
        
        
    }
    
}

- (void)buttonTapped:(UIButton *)sender
{
	//get item index for button
    
    indexTocado = [carousel indexOfItemViewOrSubview:sender];

   
      NSLog(@"%d index",indexTocado);
    if (indexTocado <= [imagenesCargadas count]) {
        
    Url = ((Imagen*)[imagenesCargadas objectAtIndex:indexTocado]).URL;
    NSLog(@"%@ URL index",Url);
    
    width=sender.frame.size.width;
    height=sender.frame.size.height*3;
        
        imagenPasar=[[Imagen alloc]init];
        imagenPasar=[imagenesCargadas objectAtIndex:indexTocado];
    
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


- (void) viewDidUnload
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