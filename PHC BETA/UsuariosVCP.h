//
//  UsuariosVCP.h
//  Location
//
//  Created by Alvaro Lancho on 22/07/12.
//  Copyright (c) 2012 Burgo Ventanas I S.L.U. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Usuario.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "Imagen.h"
#import "Descargar.h"


@class DescargaImagenes;


@interface UsuariosVCP : UIViewController<CLLocationManagerDelegate,UISearchBarDelegate, UIActivityItemSource ,UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>{
    NSMutableArray *array;
    NSMutableArray *arrayMostrar;
    NSMutableArray *arrayBuscar;
    NSMutableArray *arrayGuardado;
    NSDictionary *data;
    NSString *serverOutput;
    NSString *userString;
    MBProgressHUD *hud;
    int usuarioInt;
    UIView * usuarioView;
    __block IBOutlet UICollectionView  * collection;
    Usuario *item;
    NSString *amigo;
    NSString *Name;
    NSString *Estado;
     NSString *IDa;
     NSString *UrlA;
    UIImage *img;
    UIColor * color ;
  
    BOOL timer;
    __block BOOL terminado;
     __block BOOL terminadoImagenes;
    __block BOOL recargando;
    UISearchBar *barraBuscar;
    UINavigationController *navigationController;
    UIRefreshControl *refreshControl ;
    BOOL guardado;
    BOOL Barra;
  
    NSMutableArray *  imagenesCargadas;
    
}
@property (nonatomic, retain) UIActivityIndicatorView *indicador;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL ascending;
@property (strong, nonatomic) MKNetworkOperation *uploadOperation;
@property (strong, nonatomic) DescargaImagenes *descargar;
@property (nonatomic, retain) NSArray *imageURLs;
-(void)getData;
-(IBAction)update:(id)sender;
-(IBAction)anadir:(id)sender;
-(void) uploadImage: (UIImage *)image;
-(IBAction)AparecerBarra:(id)sender;
-(void)Cargar;
-(void)terminar;
-(void)fin;
@end