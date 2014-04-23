//
//  Imagenes.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 11/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "Imagenes.h"
#import "SBJsonParser.h"
#import "EtiquetasViewController.h"
#import "ComentariosPase.h"
#import "VerComentarios.h"
#import "AFImageRequestOperation.h"
#import "AFHTTPClient.h"

@interface Imagenes ()

@end

@implementation Imagenes
@synthesize barraInferior,barraSuperior,imageFondo,ViewFondo, width,height,urlDatos,url,ImagenPasar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)volver:(id)sender{

        [self dismissViewControllerAnimated:YES completion:nil];
    /*
    CABasicAnimation *animx = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    animx.duration = 0.6;
    animx.repeatCount = 1;
    animx.delegate=self;
    animx.removedOnCompletion = NO;
    [animx setToValue:[NSNumber numberWithFloat:0.1]];
    [animx setDuration:0.3];
    [self.view.layer addAnimation:animx  forKey:@"opacity"];
     */
    
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
        [self dismissViewControllerAnimated:NO completion:nil];
    
    
    
}
-(IBAction)comentarios:(id)sender{
  /*  NSMutableArray *arrayMostrar = [[NSMutableArray alloc]init];
    [arrayMostrar addObject:imagen2];
    NSData *datos = [NSKeyedArchiver archivedDataWithRootObject:arrayMostrar];
    [[NSUserDefaults standardUserDefaults] setObject:datos forKey:@"DatosGuardados"];
    
    BOOL * bol = [[ComentariosPase alloc] EnviarComentarioIDM:imagen2.ID usuario:imagen2.IDusuario privado:@"1" texto:@"Texto Prueba"];
    */
    
    [self performSegueWithIdentifier:@"ComentariosS" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"ComentariosS"]) {
        UINavigationController *nav = [segue destinationViewController];
        VerComentarios *myVC = (VerComentarios *)nav.topViewController;
        imagen2;
        [myVC setUs:imagen2];
       
        
    }
    
    
}
-(IBAction)editar:(id)sender{
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ID_usuario"];
    //NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    if ([imagen2.IDusuario isEqualToString:usuarioID]) {
   UIActionSheet* popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") destructiveButtonTitle:nil otherButtonTitles:@"Editar Etiquetas",NSLocalizedString(@"Borrar Foto",@""),nil];
        popupQuery.tag=1;
	//popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    // popupQuery.backgroundColor = [UIColor colorWithRed:0.17 green:0.522 blue:0.725 alpha:1];
	[popupQuery showInView:self.view];
    }
    else{
           UIActionSheet* popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") destructiveButtonTitle:nil otherButtonTitles:@"Editar Etiquetas",nil];
        popupQuery.tag=2;
        	[popupQuery showInView:self.view];
    }
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
  
        
        
	}
    if (actionSheet.tag==1) {
     
        
	if (buttonIndex == 1) {
        NSString * usuarioID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ID_usuario"];
        //NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        
        if ([imagen2.IDusuario isEqualToString:usuarioID]) {
            NSLog(@"Foto Propia");
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Delete" message:@"¿Estas seguro que desea borrar la foto?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
            alert.tag=2;
            alert.delegate=self;
            [alert show];
        }
       else{
           NSLog(@"No propietario de la foto");
           UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Delete" message:@"¿Estas seguro que desea borrar la foto?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
           alert.tag=1;
           alert.delegate=self;
           [alert show];
             }
        
        
	}
    if (buttonIndex == 2) {
        
        
        
	}
    }
}
- (void) alertView:(UIAlertView*)alert3 didDismissWithButtonIndex:(NSInteger)buttonIndex

{
    
	if (buttonIndex == 0 && alert3.tag==3)
	{
        [self volver:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ActualizarPerfil" object:nil];
        
    }
	if (buttonIndex == 1 && alert3.tag==2)
	{
        NSLog(@"Borrar");
        
        NSString * usuarioID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ID_usuario"];
        NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        NSLog(@"%@ UsuarioID",usuarioID);
        NSLog(@"Obteniendo datos");
        NSDate *myDate = [NSDate date];
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"dd"];

        
        NSString *post5=[NSString stringWithFormat:@"&token=%@",tokenID];
        
        NSString *post =[NSString stringWithFormat:@"id=%@",usuarioID];
        NSString *post2=[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
         NSString *post3 =[NSString stringWithFormat:@"&idOb=%@",imagen2.ID];
         NSString *post4 =[NSString stringWithFormat:@"&funcion=1"];
        
        NSString *hostStr = @"http://lanchosoftware.com:8080/PHC/borrar.php?";
        hostStr = [hostStr stringByAppendingString:post];
        hostStr = [hostStr stringByAppendingString:post2];
        hostStr = [hostStr stringByAppendingString:post5];
           hostStr = [hostStr stringByAppendingString:post3];
      hostStr = [hostStr stringByAppendingString:post4];
    NSLog(@"%@ URL",hostStr);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:hostStr]];
        
        NSOperationQueue *cola = [NSOperationQueue new];
        // now lets make the connection to the web
        
        [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *datas, NSError *error)
         {
             [self borrarDeCache:url];
                      }];
    
    }
}

-(void)borrarDeCache: (NSString *) fileName{
   
    
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"?" withString:@"&"];
    
    NSString *idF = [[NSString alloc]init];
       NSString *vez = [[NSString alloc]init];
       NSString *perfil = [[NSString alloc]init];
    NSString *filePath= [[NSString alloc]init];
    NSString *dataPath= [[NSString alloc]init];
    
    
    NSArray *array = [fileName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]];
    for (NSString * st in array) {
        //   NSLog(@"%@",st);
        if ([st rangeOfString:@"idF"].location != NSNotFound) {
           idF= [NSString stringWithString:st];
        }
        if ([st rangeOfString:@"vez"].location != NSNotFound) {
            vez= [NSString stringWithString:st];
        }
        if ([st rangeOfString:@"perfil"].location != NSNotFound) {
            perfil= [NSString stringWithString:st];
        }
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *string =[[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
 
        dataPath = [string stringByAppendingPathComponent:idF];
    

    //  NSLog(@" Nombre: %@.%@.%@",idf,vez,perfil);
    fileName = [NSString stringWithFormat:@"%@.%@.%@",idF,vez,perfil];
	filePath = [dataPath stringByAppendingPathComponent:fileName];


   BOOL eliminar=  [[NSFileManager defaultManager] removeItemAtPath:filePath error:Nil];
   
    NSLog(@"Borrado: %hhd",eliminar);
    UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Delete" message:@"La foto ha sido borrada" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alert.tag=3;
    alert.delegate=self;
    [alert show];

}



-(IBAction)etiquetas:(id)sender{
     NSLog(@"Etiquetas: %@",imagen2.Etiquetas);
    if (![imagen2.Etiquetas isEqualToString:@" "]) {


      EtiquetasViewController* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Etiquetas"];
    [secondViewController willMoveToParentViewController:self];
  
    
    [self addChildViewController:secondViewController];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.type = kCATransitionFade;//choose your animation
    [secondViewController.view.layer addAnimation:transition forKey:nil];
    if(imagen2.Etiquetas != nil){
        [secondViewController setIDS:imagen2.Etiquetas];
    }
    
    [self.view addSubview:secondViewController.view];
    [secondViewController didMoveToParentViewController:self];
    }
    else{
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Etiquetas" message:@"Esta foto no tiene ninguna etiqueta."
                                                              delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertsuccess show];
    }
    
    
}
-(void)cerrar2
{
      //[[NSNotificationCenter defaultCenter] postNotificationName:@"Aparecer" object:nil];
/*
    UIViewController* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Amigos"];
    
    [secondViewController willMoveToParentViewController:self];
    [self.parentViewController addChildViewController:secondViewController];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionReveal ;//choose your animation
    [secondViewController.view.layer addAnimation:transition forKey:nil];
    
    
    [self.parentViewController.view addSubview:secondViewController.view];
  
    
    [self.parentViewController.view bringSubviewToFront:secondViewController.view];
    [secondViewController didMoveToParentViewController:self];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    */
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)Datos{
    

 
        NSString *post6 =[NSString stringWithFormat:@"%@&perfil=4",url];
        
        
        NSLog(@"%@ URL", post6);
    
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:post6]];
        
        NSOperationQueue *cola = [NSOperationQueue new];
        [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *datas, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{ 
             SBJsonParser *parser = [[SBJsonParser alloc] init];
             NSString* newStr = [[NSString alloc]initWithData:datas encoding:NSASCIIStringEncoding];
             const char *convert = [newStr UTF8String];
             NSString *responseString = [NSString stringWithUTF8String:convert];
             
             
             NSArray *returned = [parser objectWithString:responseString  error:nil];
             
             
                NSLog(@"%@ Response", responseString);
             // NSLog(@"%@",error);
             
          
             // NSMutableArray *mmutable = [NSMutableArray array];
             for (NSDictionary *dict in returned){
                 
                imagen2 = [[Imagen alloc] init];
                 
                 
                 
                 [imagen2 setID:[dict objectForKey:@"ID"]];
                 [imagen2 setIDusuario:[dict objectForKey:@"IDusuario"]];
                 [imagen2 setEtiquetas:[dict objectForKey:@"Etiquetas"]];
                 [imagen2 setFecha:[dict objectForKey:@"Fecha"]];
                 [imagen2 setNombre:[dict objectForKey:@"Titulo"]];
                  [imagen2 setPublico:[dict objectForKey:@"Publico"]];
                    [imagen2 setVez:[dict objectForKey:@"Vez"]];
                 [imagen2 setAltura:[dict objectForKey:@"Altura"]];
                 
             }
                //  [[UIApplication sharedApplication] setStatusBarHidden:YES];
                NSLog(@"%@ Titulo", imagen2.Nombre);
                 NSLog(@"%@ Etiquetas", imagen2.Etiquetas);
                 NSLog(@"%@ Altura BD", imagen2.altura);
                 if (imagen2.Nombre != (id)[NSNull null]) {
                 titulo.text=imagen2.Nombre;
                 [titulo reloadInputViews];
                 }
                 
                 
                 
                 if (imagen2.altura != nil) {
                     [UIView beginAnimations:@"Resize" context:nil];
                     [UIView setAnimationDuration:0.5];
                     
                     __block UIImageView * imgVB= ViewFondo;
                     __block UIScrollView * scrollVB= scroll;
                     
                     
                     imgVB = [[UIImageView alloc] initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height/2)-([imagen2.altura floatValue]/2), 320, [imagen2.altura floatValue])];
                     //imgVB.center = self.navigationController.view.center;
                     
                     imgVB.image = ImagenPasar.imagen;
                     
                     scrollVB =[[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
                     
                     
                     //scrollVB.center=self.navigationController.view.center;
                     scrollVB.userInteractionEnabled=YES;
                     
                     [self.view insertSubview:scrollVB belowSubview:barraInferior];
                     [scrollVB addSubview:imgVB];
                     /*
                      UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
                      [panRecognizer setMinimumNumberOfTouches:1];
                      [panRecognizer setMaximumNumberOfTouches:1];
                      [panRecognizer setDelegate:self];
                      [scroll addGestureRecognizer:panRecognizer];
                      
                      */
                     scrollVB.scrollEnabled = YES;
                     
                     // For supporting zoom,
                     scrollVB.minimumZoomScale = 1;
                     scrollVB.maximumZoomScale = 1.5;
                     
                     
                     viewI.frame = CGRectMake(0, 0,320, [imagen2.altura floatValue]);
                     [viewI layoutSubviews];
                     [viewI reloadInputViews];
                     [self.view reloadInputViews];
                     [UIView commitAnimations];
                 }
                 
                 
             });   }];
    
    
    }
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}
- (void)viewDidLoad
{
    //self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    //self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
     //self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
  
    //[self.view reloadInputViews];
    [super viewDidLoad];
      [self Datos];
  	// Do any additional setup after loading the view.
}
-(void)CargarImagenes{
    imagenesCargadas = [[NSMutableArray alloc]init];
    AFHTTPClient *httpClient  = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [httpClient.operationQueue setMaxConcurrentOperationCount:1] ;
    NSMutableArray *operationsArray = [NSMutableArray array];

        
    NSString *post8 =[NSString stringWithFormat:@"&borde=1"];
    
    url=[url stringByAppendingString:post8];
    
    NSURL * URL = [[NSURL alloc]initWithString:url];
    
    
        
        AFImageRequestOperation *getImageOperation =
        [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:URL]
                                             imageProcessingBlock:nil
                                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                              //
                                                              // Save image
                                                              //
                                                              imageFondo=image;
                                                              
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
                                          
                                          NSLog(@"Imagen!");
                                          __block UIImageView * imgVB= ViewFondo;
                                          __block UIScrollView * scrollVB= scroll;
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                            imgVB = [[UIImageView alloc] initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height/2)-([imagen2.altura floatValue]/2), 320, [imagen2.altura floatValue])];
                                              //imgVB.center = self.navigationController.view.center;
                                            
                                              imgVB.image = imageFondo;

                                              scrollVB =[[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
                                              
                                              
                                              //scrollVB.center=self.navigationController.view.center;
                                              scrollVB.userInteractionEnabled=YES;
                                              
                                                       [self.view insertSubview:scrollVB belowSubview:barraInferior];
                                              [scrollVB addSubview:imgVB];
                                              /*
                                               UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
                                               [panRecognizer setMinimumNumberOfTouches:1];
                                               [panRecognizer setMaximumNumberOfTouches:1];
                                               [panRecognizer setDelegate:self];
                                               [scroll addGestureRecognizer:panRecognizer];
                                               
                                               */
                                              scrollVB.scrollEnabled = YES;
                                              
                                              // For supporting zoom,
                                              scrollVB.minimumZoomScale = 1;
                                              scrollVB.maximumZoomScale = 1.5;
                                     
                               
                                               });
                                          /*
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [carousel reloadData];
                                              completado=YES;
                                               for (int i =0; i< [imagenesCargadas count]; i++) {
                                               //  UIImageView *Img = [[UIImageView alloc]initWithImage:[imagenesCargadas objectAtIndex:i]];
                                               UIImage * image = [imagenesCargadas objectAtIndex:i];
                                               [carousel reloadInputViews];
                                               [carousel reloadItemAtIndex:i animated:NO];
                                               }
                                          });
    */
                                          
                                          
                                      }];
}

    


- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return viewI;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	//Get all the touches.
	NSSet *allTouches = [event allTouches];
	
	//Number of touches on the screen
	switch ([allTouches count])
	{
		case 1:
		{
			//Get the first touch.
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
		
            
			switch([touch tapCount])
			{
				case 1://Single tap
					
					break;
				case 2://Double tap.
                    [UIView beginAnimations:@"toolbar" context:nil];
                    if (toolbarHidden  && iadHidden ) {
                        barraSuperior.frame = CGRectOffset(barraSuperior.frame, 0, +barraSuperior.frame.size.height);
                        barraSuperior.alpha = 1;
                        toolbarHidden = NO;
                        iadHidden = NO;
                        barraInferior.frame = CGRectOffset(barraInferior.frame, 0, -barraInferior.frame.size.height);
                        barraInferior.alpha = 1;
                        titulo.alpha = 1;
                        
                    }
                    else {
                        
                        barraSuperior.frame = CGRectOffset(barraSuperior.frame, 0, -barraSuperior.frame.size.height);
                        barraSuperior.alpha = 0;
                        toolbarHidden = YES;
                        iadHidden = YES;
                        barraInferior.frame = CGRectOffset(barraInferior.frame, 0, +barraInferior.frame.size.height);
                        barraInferior.alpha = 0;
                         titulo.alpha = 0;
                        
                        
                    }
                    
                    [UIView commitAnimations];
                    
                    
                    break;
			}
        
        }
            break;
	}
	
}

-(void)move:(id)sender {
	
	
	
	[self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
		
		firstX = [[sender view] center].x;
		firstY = [[sender view] center].y;
	}
	
	translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
	
	[[sender view] setCenter:translatedPoint];
	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		CGFloat finalX = translatedPoint.x;
		CGFloat finalY = translatedPoint.y;
		
		if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
            
            
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:.35];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [[sender view] setCenter:CGPointMake(finalX, finalY)];
            [UIView commitAnimations];
        }}
    [self.view bringSubviewToFront:barraSuperior];
    [self.view bringSubviewToFront:barraInferior];
    
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
