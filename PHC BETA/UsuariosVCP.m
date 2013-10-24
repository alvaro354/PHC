//
//  UsuariosVCP.m
//  Location
//
//  Created by Alvaro Lancho on 22/07/12.
//  Copyright (c) 2012 Burgo Ventanas I S.L.U. All rights reserved.
//

#import "UsuariosVCP.h"
#import "SBJson.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "Cell.h"
#import "NSStringAdditions.h"
#import "DescargaImagenes.h"
#import "AsyncImageView.h"
#import "Amigos.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPClient.h"
#import "AFImageRequestOperation.h"


@interface UsuariosVCP ()

@end

@implementation UsuariosVCP
@synthesize locationManager,uploadOperation,imageURLs,flOperation,flUploadEngine,indicador, ascending,descargar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(IBAction)AparecerBarra:(id)sender{
    if (Barra ==NO) {
        barraBuscar=[[UISearchBar alloc] initWithFrame:CGRectMake(collection.frame.origin.x, collection.frame.origin.y, collection.frame.size.width, 40)];
        barraBuscar.barTintColor = [UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
        barraBuscar.tintColor= [UIColor whiteColor];
        barraBuscar.delegate=self;
        collection.clipsToBounds = YES;
        //  [self.view addSubview:barraBuscar];
        collection.autoresizingMask = UIViewAutoresizingNone;
        
        
        NSLog(@"Animacion Barra");
        
        [collection setTranslatesAutoresizingMaskIntoConstraints:YES];
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             [collection setFrame:CGRectMake(collection.frame.origin.x, collection.frame.origin.y+40, collection.frame.size.width, collection.frame.size.height+40)];
                             
                             
                             [self.view layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished){
                             
                             CATransition *transition = [CATransition animation];
                             transition.duration = 1.0;
                             transition.type = kCATransitionReveal; //choose your animation
                             [barraBuscar.layer addAnimation:transition forKey:nil];
                             [self.view addSubview:barraBuscar];
                             Barra=YES;
                         }];
    }
    else{
        [collection setTranslatesAutoresizingMaskIntoConstraints:YES];
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             barraBuscar.alpha=0;
                             [collection setFrame:CGRectMake(collection.frame.origin.x, collection.frame.origin.y-40, collection.frame.size.width, collection.frame.size.height-40)];
                             
                             
                             [self.view layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished){
                             [barraBuscar removeFromSuperview];
                             Barra=NO;
                             [arrayBuscar removeAllObjects];
                             [arrayBuscar addObjectsFromArray:arrayMostrar];
                             //  NSLog(@"Buscando0: %u", [arrayMostrar count]);
                             [collection reloadData];
                         }];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [arrayBuscar removeAllObjects];
    
    if(![searchText isEqualToString:@""]){
        
        
        for(Usuario *usuario in arrayMostrar){
            // NSLog(@"Buscando");
            
            
            NSRange nombreRange = [[usuario.usuario lowercaseString] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            
            if(nombreRange.location != NSNotFound)
                [arrayBuscar addObject:usuario];
            // NSLog(@"Buscando2");
        }
        
        
    }
    
    [collection reloadData];
}
-(void)recargar{
    NSLog(@"Recargar");
    [collection reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.topItem.title=@"Amigos";
    
   
    
   // self.navigationController.navigationBar.topItem.title.
}
-(void)viewWillAppear:(BOOL)animated{

}
- (void)viewDidLoad
{
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

  

 
    
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(recargar) userInfo:nil repeats:NO];
   
    // self.parentViewController.view.clipsToBounds=YES;
    // self.parentViewController.view.layer.cornerRadius = 8.0;
    /*UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:  self.navigationController.navigationBar.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(8.0, 8.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.navigationController.navigationBar.layer.mask = maskLayer;
     */
    
    
    [UIApplication sharedApplication].statusBarHidden=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recargar) name:@"recargar" object:nil];
    
    
    [self edgesForExtendedLayout];
    // self.navigationController.navigationBar.clipsToBounds=YES;
    // self.navigationController.navigationBar.layer.cornerRadius = 8.0;
    terminado=NO;
    recargando=NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
   // //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.17 green:0.522 blue:0.725 alpha:1];
    // self.navigationController.title
    collection.alwaysBounceVertical = YES;
   // self.tabBarController.view.clipsToBounds=YES;
   // self.tabBarController.view.layer.cornerRadius = 8.0;
    
    refreshControl = [[UIRefreshControl alloc]
                      init];
    refreshControl.tintColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];;
    [refreshControl addTarget:self action:@selector(changeSorting) forControlEvents:UIControlEventValueChanged];
    // self.refreshControl = refreshControl;
    [collection addSubview:refreshControl];
    
    
    collection.backgroundColor = [UIColor whiteColor];
    collection.delegate=self;
    collection.dataSource =self;
    
    [self Cargar];
    arrayMostrar = [[NSMutableArray alloc]init];
    
    NSData *datos = [[NSUserDefaults standardUserDefaults] objectForKey:@"DatosGuardados"];
    arrayGuardado = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
    
    NSLog(@"%u Amigos",[arrayGuardado count]);
    
    if ([arrayGuardado count]==0)  {
        NSLog(@" %lu Array Guardado",(unsigned long)[arrayGuardado count]);
        recargando=YES;
    }
    [collection registerClass:[Cell class] forCellWithReuseIdentifier:@"CELL_ID"];
    [self getData];
    [self.view reloadInputViews];
    timer2= [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(act) userInfo:nil repeats: NO];
    [super viewDidLoad];
    
}
-(void)act{
    NSLog(@"Act");
    [collection reloadInputViews];
    [collection reloadData];
    [collection setNeedsLayout];
}
- (void)changeSorting
{
    recargando =YES;
    // NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Self" ascending:self.ascending];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* string = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];

          NSString* dataPath = [string stringByAppendingPathComponent:@"Perfil"];
    
    
    [[NSFileManager defaultManager] removeItemAtPath:dataPath error:nil];
    
    terminado=NO;
    terminado2=NO;
 //   [flUploadEngine emptyCache];
    ascending = !ascending;
    [array removeAllObjects];
    [arrayMostrar removeAllObjects];
    [arrayGuardado removeAllObjects];
     [arrayBuscar removeAllObjects];
   // [collection reloadData];
  
    [AsyncImageLoader sharedLoader].cache = nil;
    [imagenesCargadas removeAllObjects];
    
    
    [self performSelector:@selector(getData) withObject:nil
               afterDelay:1];
    NSLog(@"CARGAR2");
}



-(void)Cargar{
    NSLog(@"CARGAR");
    BOOL sesion = [[NSUserDefaults standardUserDefaults] boolForKey:@"Longeado"];
    if (sesion==YES) {
        /*
         [autoTimer invalidate];
         autoTimer = nil;
         locationManager = [[CLLocationManager alloc] init];
         locationManager.delegate = self;
         locationManager.distanceFilter = kCLDistanceFilterNone;
         locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
         [locationManager startMonitoringSignificantLocationChanges];
         [collection registerClass:[Cell class] forCellWithReuseIdentifier:@"CELL_ID"];
         [self getData];
         */
    }
    else{
        if (timer==NO) {
            timer=YES;
            NSLog(@"NSTimer");
            autoTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Cargar) userInfo:nil repeats:YES];
        }
    }
}
-(void)eliminarHub{
    NSLog(@"HUB ELIMINAR");
    dispatch_async(dispatch_get_main_queue(), ^{
/*
        [hud hide:YES];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [hud removeFromSuperview];
   */
        [refreshControl endRefreshing];
        [collection reloadData];
    });
}

-(void)getData{
    
    if (recargando) {
        //hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
      //  hud.labelText = NSLocalizedString(@"Cargando", @"");
      //  hud.delegate=self;
         [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(eliminarHub) userInfo:nil repeats:NO];
    }
    
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
    StringEncryption *crypto = [[StringEncryption alloc] init] ;
    
    NSLog(@"%@ UsuarioID",usuarioID);
    NSLog(@"Obteniendo datos");
    NSDate *myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSLog(@"%@ tokenID",tokenID);
    NSString *post5=[NSString stringWithFormat:@"&token=%@",tokenID];
    
    NSString *post =[NSString stringWithFormat:@"id=%@",usuarioID];
    NSString *post2=[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
    
    NSString *hostStr = @"http://lanchosoftware.es/app/amigos.php?";
    hostStr = [hostStr stringByAppendingString:post];
    hostStr = [hostStr stringByAppendingString:post2];
    hostStr = [hostStr stringByAppendingString:post5];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSString *_key = @"alvarol2611995";
    
    
    _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:hostStr]];
    
    NSOperationQueue *cola = [NSOperationQueue new];
    // now lets make the connection to the web
    
    [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *datas, NSError *error)
     {
         dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
         dispatch_async(myQueue, ^{
         CCOptions padding = kCCOptionECBMode;
         NSString *string = [[NSString alloc] initWithData:datas encoding:NSASCIIStringEncoding];
         NSData *_secretData = [NSData dataWithBase64EncodedString:string];
         
         NSData *encryptedData = [crypto decrypt:_secretData  key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
         NSString* newStr = [[NSString alloc]initWithData:encryptedData encoding:NSASCIIStringEncoding];
         const char *convert = [newStr UTF8String];
         NSString *responseString = [NSString stringWithUTF8String:convert];
         
         
         NSArray *returned = [parser objectWithString:responseString error:nil];
         
         NSLog(@"%@",error);
         NSMutableArray *mmutable = [NSMutableArray array];
         for (NSDictionary *dict in returned){
             
             NSLog(@"loo %@ %@", [dict objectForKey:@"usuario"], dict);
             item = [[Usuario alloc] init];
             [item setUsuario:[dict objectForKey:@"usuario"]];
             [item setID:[dict objectForKey:@"id_Usuario"]];
             
             [mmutable addObject:item];
         }
         
         // parsing the first level
         
         
         
         NSLog(@"%@",returned );
         NSLog( @"%d",[returned count] );
         array = mmutable;
         NSMutableArray * nombres = [[NSMutableArray alloc]init];
         arrayMostrar = [[NSMutableArray alloc] init];
         arrayBuscar = [[NSMutableArray alloc]init];
         
         for (Usuario *usuario in array) {
             [nombres addObject:usuario.usuario];
         }
         
         NSSortDescriptor *orden = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
         NSArray *arrayOrdenado = [nombres sortedArrayUsingDescriptors:[NSArray arrayWithObject:orden]];
         
         for (NSString *nombre in arrayOrdenado) {
             for (Usuario* usuario in array) {
                 if ([usuario.usuario isEqualToString:nombre]) {
                     [arrayMostrar addObject:usuario];
                 }
             }
             
         }
         arrayBuscar=[[NSMutableArray alloc]initWithArray:arrayMostrar];
         
         NSLog(@"%lu Numero Array Mostrar",(unsigned long)[ arrayMostrar count]);
         
         
         [array removeAllObjects];
         
         terminado =YES;
         [self descargar:nil];
         
         // Each element in statuses is a single status
         // represented as a NSDictionary
         
             dispatch_async(dispatch_get_main_queue(), ^{
                 [collection reloadData];
             });
         
         
         });  }];
    
    
}


-(IBAction)anadir:(id)sender{
    UIViewController* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Anadir"];
    // [self presentViewController:secondViewController animated:YES completion:nil];
    
    [secondViewController willMoveToParentViewController:self];
    [self.parentViewController addChildViewController:secondViewController];
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.type = kCATransitionFade;//choose your animation
    [secondViewController.view.layer addAnimation:transition forKey:nil];
    
    [self.parentViewController.view addSubview:secondViewController.view];
    [secondViewController didMoveToParentViewController:self];
    
}

-(IBAction)descargar:(id)sender{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fin) name:@"Fin" object:nil];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"Descargando" );
    
    __block NSString* IDFinal;
    descargar =[[DescargaImagenes alloc]init];
     NSMutableArray *URLs = [NSMutableArray array];
    [URLs removeAllObjects];
    
    if (terminado) {
        Usuario * u = [arrayBuscar lastObject];
        IDFinal = u.ID;
        
        
        for(Usuario *Usuarios in arrayBuscar){
            
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
            
            NSString *post =[NSString stringWithFormat:@"&idF=%@",Usuarios.ID];
            
            NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
            hostStr = [hostStr stringByAppendingString:post2];
            hostStr = [hostStr stringByAppendingString:post3];
            hostStr = [hostStr stringByAppendingString:post4];
            hostStr = [hostStr stringByAppendingString:post5];
            hostStr = [hostStr stringByAppendingString:post6];
            hostStr = [hostStr stringByAppendingString:post7];
               hostStr = [hostStr stringByAppendingString:post];
        
            
           
            [URLs addObject:[NSURL URLWithString:hostStr]];
            if ([IDFinal isEqualToString:Usuarios.ID]) {
         
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    recargando=NO;
                
                 self.imageURLs = URLs;
               // terminado =YES;
                guardado=YES;
                
                
                
                for (int w =0; w<[arrayBuscar count];w++) {
                    
                    
                    Usuario * us = [arrayBuscar objectAtIndex:w];
                    
                    NSURL *url = [URLs objectAtIndex:w];
                    // NSLog(@"%@ %@", us.ID,imagen2.IDusuario);
               
                        
                        Usuario * TempUser =[[Usuario alloc]init];
                        TempUser=us;
                        
                    TempUser.URLimagen= [url absoluteString];
                    
                    
                        //  NSLog(@"Imagen Perfil Cache");
                        [arrayBuscar replaceObjectAtIndex:w withObject:TempUser];
                    
                        
                    
                }
                
                
                /*
                dispatch_async(dispatch_get_main_queue(), ^{
                   // [collection reloadData];
                });
                 */
                [self CargarImagenes];
            }
                       

            
        }
    }
    else{
        Usuario * u = [arrayGuardado lastObject];
        IDFinal = u.ID;
        
        
        for(Usuario *Usuarios in arrayGuardado){
            
            
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
            
            NSString *post =[NSString stringWithFormat:@"idF=%@",Usuarios.ID];
            
            NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
            hostStr = [hostStr stringByAppendingString:post];
            hostStr = [hostStr stringByAppendingString:post2];
            hostStr = [hostStr stringByAppendingString:post3];
            hostStr = [hostStr stringByAppendingString:post4];
            hostStr = [hostStr stringByAppendingString:post5];
            hostStr = [hostStr stringByAppendingString:post6];
            hostStr = [hostStr stringByAppendingString:post7];
            
            
         
            [URLs addObject:[NSURL URLWithString:hostStr]];
            if ([IDFinal isEqualToString:Usuarios.ID]) {

                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    recargando=NO;
                
                self.imageURLs = URLs;
                
                
                
                for (int w =0; w<[arrayGuardado count];w++) {
                    
                    
                    Usuario * us = [arrayGuardado objectAtIndex:w];
                    
                    NSURL *url = [URLs objectAtIndex:w];
                    // NSLog(@"%@ %@", us.ID,imagen2.IDusuario);
                    
                    
                    Usuario * TempUser =[[Usuario alloc]init];
                    TempUser=us;
                    
                    TempUser.URLimagen= [url absoluteString];
                    
                    
                    //  NSLog(@"Imagen Perfil Cache");
                    [arrayGuardado replaceObjectAtIndex:w withObject:TempUser];
                    
                    
                    
                }
                //terminado =YES;
                guardado=YES;
               /* dispatch_async(dispatch_get_main_queue(), ^{
                    [collection reloadData];
                });*/
                
                    [self CargarImagenes];
                
             
            }
            
            
        }
    }
    
    
    
}

-(void)CargarImagenes{
    NSLog(@"Cargando Imagenes");
   __block BOOL Error=NO;
    imagenesCargadas = [[NSMutableArray alloc]init];
    AFHTTPClient *httpClient  = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [httpClient.operationQueue setMaxConcurrentOperationCount:1] ;
    NSMutableArray *operationsArray = [NSMutableArray array];
    for (Usuario *us in arrayBuscar) {
        
     //   NSLog(@"URL: %@", us.URLimagen);
        
        NSURL * URL = [[NSURL alloc]initWithString:us.URLimagen];
        
        AFImageRequestOperation *getImageOperation =
        [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:URL]
                                             imageProcessingBlock:nil
                                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                              //
                                                              // Save image
                                                              //
                                                                    if(image != nil){
                                                              [imagenesCargadas addObject:image];
                                                                    }
                                                                    else{
                                                                        Error=YES;
                                                                        NSLog(@"Image request CACHE error!");
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
                                          if(Error){
                                              [self changeSorting];
                                          }
                                          else{
                                          NSLog(@"Imagenes: %lu", (unsigned long)[imagenesCargadas count]);
                                          
                                          terminado2 = YES;
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [collection reloadData];
                                              
                                              /* for (int i =0; i< [imagenesCargadas count]; i++) {
                                               //  UIImageView *Img = [[UIImageView alloc]initWithImage:[imagenesCargadas objectAtIndex:i]];
                                               UIImage * image = [imagenesCargadas objectAtIndex:i];
                                               [carousel reloadInputViews];
                                               [carousel reloadItemAtIndex:i animated:NO];
                                               }*/
                                          
                                          });}
                                          
                                          
                                      }];
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%d Count ", [arrayBuscar count]);
    NSLog(@"%d Count Guardado ", [arrayGuardado count]);
    if (terminado) {
        return [arrayBuscar count];
    }
    else{
        return [arrayGuardado count];
    }
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Usuario *items;
    
    
    #define IMAGE_VIEW_TAG 99
    
    Cell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ID"forIndexPath:indexPath];
    if (terminado) {
       //  NSLog(@"Terminado Cell");
        items = [arrayBuscar objectAtIndex:indexPath.item];
        //if (guardado == YES) {
           // NSLog(@"Guardado");
            NSData *datos = [NSKeyedArchiver archivedDataWithRootObject:arrayMostrar];
            [[NSUserDefaults standardUserDefaults] setObject:datos forKey:@"DatosGuardados"];
            guardado=NO;
       // }
    }
    else{
       // NSLog(@" No Terminado");
        items = [arrayGuardado objectAtIndex:indexPath.item];
    }

    
    cell.name.text = items.usuario;
    
    if (cell == nil)
    {
        //create new cell
       
		
		//add AsyncImageView to cell
		UIImageView*imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cell.image.frame.size.width,  cell.image.frame.size.height)];
		imageView.contentMode = UIViewContentModeScaleAspectFill;
		imageView.clipsToBounds = YES;
		imageView.tag = IMAGE_VIEW_TAG;
		[cell.image addSubview:imageView];
        if (imageView.image == nil) {
            NSLog(@"Nil");
            imageView.backgroundColor = [UIColor blueColor];
            cell.backgroundColor = [UIColor blueColor];
            [cell reloadInputViews];
        }
	//	[imageView release];
		
		//common settings
       
    }
       if (terminado2) {
           
           
        //   NSLog(@"Terminado2");
	//get image view
           
	//UIImageView *imageView =  ((UIImageView *)cell.image);
	//[AsyncImageLoader defaultCache];
    //cancel loading previous image for cell
    
          // imageView.image = items.imagen;
    //load the image
           /*
           NSURL *URL = [NSURL URLWithString:items.URLimagen];
           NSURLRequest *urlRequest = [NSURLRequest requestWithURL:URL];
        __block Cell * cellB = cell;
           [cell.image setImageWithURLRequest:urlRequest
                                      placeholderImage:nil
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   cellB.image.image = image;
                                               } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                   NSLog(@"Failed to download image: %@", error);
                                               }];
     */
           if([imagenesCargadas objectAtIndex:indexPath.item] != nil){
            
               UIImageView*imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cell.image.frame.size.width,  cell.image.frame.size.height)];
               imageView.contentMode = UIViewContentModeScaleAspectFill;
               imageView.clipsToBounds = YES;
               imageView.tag = IMAGE_VIEW_TAG;
               imageView.image= [imagenesCargadas objectAtIndex:indexPath.item];

           [cell.image addSubview:imageView];
           }
           [cell reloadInputViews];
           
           
   
    }
    
  [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (recargando) {
        NSLog(@"Quitar");
       
        recargando=NO;
    }
    return cell;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
     if ([segue.identifier isEqualToString:@"amigos"]) {

     [segue.destinationViewController setAmigo:amigo ];
         [segue.destinationViewController setEstado:Estado];
            [segue.destinationViewController setID:IDa];
         [segue.destinationViewController setUrlP:UrlA];

     }
     
     
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    UrlA= [imageURLs objectAtIndex:indexPath.item];
     NSLog(@"%@ URL PASAR", UrlA);
    item = [arrayBuscar objectAtIndex:indexPath.item];
    amigo = item.usuario;
    IDa =item.ID;
    Estado =item.Estado;
    NSLog(@"%@",amigo);
    NSData *datos = [NSKeyedArchiver archivedDataWithRootObject:item];
    [[NSUserDefaults standardUserDefaults] setObject:datos forKey:@"DatosAmigo"];
   // Cell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ID"forIndexPath:indexPath];
    
    
  //  NSLog(@"%d CELDA %f x %f y", indexPath.item,cell.center.x, cell.center.y);

    [self performSegueWithIdentifier:@"amigos" sender:self];
//UIViewController* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Amigos"];
   // [self.navigationController pushViewController:secondViewController animated:YES];
    /*
     [secondViewController willMoveToParentViewController:self];
     [self addChildViewController:secondViewController];
     CATransition *transition = [CATransition animation];
     transition.duration = 0.5;
     transition.type = kCATransitionPush ;//choose your animation
     [secondViewController.view.layer addAnimation:transition forKey:nil];
     
     [self.view addSubview:secondViewController.view];
     [secondViewController didMoveToParentViewController:self];
     */
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
