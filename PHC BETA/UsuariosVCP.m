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
@synthesize locationManager,uploadOperation,imageURLs,indicador, ascending,descargar;

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


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"ImagenesPerfilCargadas"
                                                  object:nil];
}
- (void)viewDidLoad
{
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};


   
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(obtenerImagenes:)
                                                 name:@"ImagenesPerfilCargadas"
                                               object:nil];

   
 
    
    
    [super viewDidLoad];
    
}
- (void)obtenerImagenes:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    
    imagenesCargadas=[dict objectForKey:@"Imagenes"];
    
    for (int i =0; i<[arrayBuscar count]; i++) {
        Usuario *usuario = [arrayBuscar objectAtIndex:i];
        usuario.imagen=[[UIImage alloc]init];
        usuario.imagen=[imagenesCargadas objectAtIndex:i];
        NSLog(@"Imagen heigth: %f", usuario.imagen.size.height);
        [arrayBuscar replaceObjectAtIndex:i withObject:usuario];
    }
    NSData *datos = [NSKeyedArchiver archivedDataWithRootObject:arrayBuscar];
    [[NSUserDefaults standardUserDefaults] setObject:datos forKey:@"DatosGuardados"];
    arrayMostrar = [[NSMutableArray alloc]initWithArray:arrayBuscar];
   
 
    terminado=YES;
    terminadoImagenes=YES;
   [collection reloadData];
    
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
    terminadoImagenes=NO;
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
 
    
    
        [[Descargar alloc]descargarDeAmigos:usuarioID completationBlock:^(NSMutableArray *amigos) {
            
            
            arrayBuscar=[[NSMutableArray alloc]initWithArray:amigos];
            
            terminado =YES;
            
            
            dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
            dispatch_async(myQueue, ^{
                
                
                NSLog(@"Empezando a Descargar: ");
                [[Descargar alloc]descargarImagenPerfil:arrayBuscar grupo:@"Amigos" completationBlock:^(NSMutableArray *imagenesDescargadas) {
                    
                    for (int i =0; i<[arrayBuscar count]; i++) {
                        Usuario *usuario = [arrayBuscar objectAtIndex:i];
                        usuario.imagen=[[UIImage alloc]init];
                        usuario.imagen=[imagenesDescargadas objectAtIndex:i];
                        NSLog(@"Imagen heigth: %f", usuario.imagen.size.height);
                        [arrayBuscar replaceObjectAtIndex:i withObject:usuario];
                    }
                    NSData *datos = [NSKeyedArchiver archivedDataWithRootObject:arrayBuscar];
                    [[NSUserDefaults standardUserDefaults] setObject:datos forKey:@"DatosGuardados"];
                    arrayMostrar = [[NSMutableArray alloc]initWithArray:arrayBuscar];
                    
                    
                    terminado=YES;
                    terminadoImagenes=YES;
                    [collection reloadData];
                }];
                
                
            });
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [collection reloadData];
            });
        }];
    
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
    
     #define IMAGE_VIEW_TAG 99
    
    Cell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ID"forIndexPath:indexPath];
    
    Usuario *items;
    UIImageView*imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cell.image.frame.size.width,  cell.image.frame.size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.tag = IMAGE_VIEW_TAG;

    
    
    if (terminado) {

        items = [arrayBuscar objectAtIndex:indexPath.item];

    }
    else{
       // NSLog(@" No Terminado");
        items = [arrayGuardado objectAtIndex:indexPath.item];
        imageView.image= items.imagen;
        [cell.image addSubview:imageView];
    }

    if (items.imagen != nil) {
        imageView.image= items.imagen;
        [cell.image addSubview:imageView];
    }
    cell.name.text = items.usuario;
    
    if (cell == nil)
    {

		[cell.image addSubview:imageView];
        if (imageView.image == nil) {
            NSLog(@"Nil");
            imageView.backgroundColor = [UIColor blueColor];
            cell.backgroundColor = [UIColor blueColor];
            [cell reloadInputViews];
        }
	
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
         [segue.destinationViewController setUrlPasada:UrlA];
      [segue.destinationViewController setImagen:item.imagen];
     }
     
     
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    UrlA=[[NSString alloc]initWithFormat:@"%@",[imageURLs objectAtIndex:indexPath.item]];
   
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
