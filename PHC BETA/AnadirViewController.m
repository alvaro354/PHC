//
//  AnadirViewController.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 29/03/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "AnadirViewController.h"
#import "Mensaje.h"
#import "Imagen.h"
#import "DescargaImagenes.h"
#import "AsyncImageView.h"
#import "UIImageView+AFNetworking.h"

@interface AnadirViewController ()

@end

@implementation AnadirViewController
@synthesize flOperation,flUploadEngine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    imagenesArray= [[NSMutableArray alloc] init];
   animado =NO;
    vistaBuscar.layer.borderWidth=1.5;
    vistaBuscar.layer.borderColor=[UIColor blackColor].CGColor;
    viewFondo.alpha=0.3;
    NSLog(@"Search");
    vistaBuscar.clipsToBounds=YES;
    vistaBuscar.layer.cornerRadius = 8.0;
     buscar.delegate = self;
    tabla.delegate = self;
    tabla.dataSource =self;
    [self reloadInputViews];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    
    
    self.view.alpha=0;
    
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
   
    
    self.view.alpha=1;
    
    [UIView commitAnimations];



    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)getData{
   
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.labelText = NSLocalizedString(@"Cargando", @"");
    
    
    
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
    
    NSString *post3 =[NSString stringWithFormat:@"&username=%@",buscar.text];
    
    NSString *hostStr = @"http://lanchosoftware.es/app/buscar.php?";
    hostStr = [hostStr stringByAppendingString:post];
    hostStr = [hostStr stringByAppendingString:post2];
      hostStr = [hostStr stringByAppendingString:post3];
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
         
         dispatch_async(dispatch_get_main_queue(), ^{ 
         CCOptions padding = kCCOptionECBMode;
         NSString *string = [[NSString alloc] initWithData:datas encoding:NSASCIIStringEncoding];
         NSData *_secretData = [NSData dataWithBase64EncodedString:string];
         
         NSData *encryptedData = [crypto decrypt:_secretData  key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
         NSString* newStr = [[NSString alloc]initWithData:encryptedData encoding:NSASCIIStringEncoding];
         const char *convert = [newStr UTF8String];
         NSString *responseString = [NSString stringWithUTF8String:convert];
         
          NSLog(@"%@ Respueta",responseString );
         NSArray *returned = [parser objectWithString:responseString error:Nil];
         
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
         
         array = mmutable;
         NSMutableArray * nombres = [[NSMutableArray alloc]init];
         arrayMostrar = [[NSMutableArray alloc] init];
         
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
         
         
         NSLog(@"%lu Numero Array Mostrar",(unsigned long)[ arrayMostrar count]);
         if ([ arrayMostrar count] !=0) {
             [self descargar:nil];
         }
      
         
         // Each element in statuses is a single status
         // represented as a NSDictionary
         
         [tabla reloadData];
         
         
         });     }];
      [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(rel) userInfo:nil repeats:NO];
    
}

-(void)rel{
    NSLog(@"Reload");
    [tabla performSelectorOnMainThread:@selector(reloadData) withObject:Nil waitUntilDone:NO];
    [tabla reloadInputViews];
}
     
-(IBAction)volver:(id)sender{
    animado = YES;
    CABasicAnimation *animY = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
    animY.duration = 0.6;
    animY.repeatCount = 1;
    animY.delegate=self;
    animY.removedOnCompletion = NO;
    animY.fillMode = kCAFillModeForwards;
    animY.toValue=[NSNumber numberWithFloat:-550];
    [vistaBuscar.layer addAnimation:animY forKey:nil];
    animY.toValue=[NSNumber numberWithFloat:550];
    [tabla.layer addAnimation:animY forKey:nil];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDidStopSelector:@selector(removeMyView)];
    
    self.view.alpha=0;
    
    [UIView commitAnimations];

}


-(void)removeMyView{
    [viewFondo removeFromSuperview];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];

}
-(IBAction)descargar:(id)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"Descargando" );
    
    __block NSString* IDFinal;

        Usuario *Usu = [arrayMostrar objectAtIndex:[arrayMostrar count]-1];
        IDFinal = Usu.usuario;
        
        for(Usuario *Usuarios in arrayMostrar){
            
            
           // Imagen * imagen = [[DescargaImagenes alloc] descargarImagenIDF:Usuarios.ID perfil:@"1" vez:@"0"];
            
            //DescargaImagenes* descargar = [[DescargaImagenes alloc] init];
          //  [descargar descargarImagenIDF:Usuarios.ID perfil:@"1" vez:@"0"];
            
           
            //if([descargar responseImage]!= nil){
               // Usuarios.imagen= [descargar responseImage].imagen;
        
    
           // NSLog(@"IDF +: %@", Usuarios.ID);
            
            if ([IDFinal isEqualToString:Usuarios.usuario]) {
                NSLog(@"Terminado");
               
                [self->tabla reloadData];
            }
        }
    }
    
   
    
    
    




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    NSLog(@"Search Pulsado");
    [self.view endEditing:YES];
    [self getData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [ arrayMostrar count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //CeldaInvitacionesCell *cell = (CeldaInvitacionesCell *)[tableView dequeueReusableCellWithIdentifier:@"CeldaInvitaciones"];
    
    static NSString *CellIdentifier = @"CeldaInvitaciones";
 CeldaInvitacionesCell *cell = (CeldaInvitacionesCell *)[tableView dequeueReusableCellWithIdentifier:@"CeldaInvitaciones"];
    
      if (cell == nil) {
     cell = [[CeldaInvitacionesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     }
     

  
    if ([ arrayMostrar count] !=0) {
        Usuario *items = [arrayMostrar objectAtIndex:indexPath.row];
        cell.name.text = items.usuario;
        
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
        
        NSString *post =[NSString stringWithFormat:@"&idF=%@",items.ID];
        
        NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
     
        hostStr = [hostStr stringByAppendingString:post2];
           hostStr = [hostStr stringByAppendingString:post];
        hostStr = [hostStr stringByAppendingString:post3];
        hostStr = [hostStr stringByAppendingString:post4];
        hostStr = [hostStr stringByAppendingString:post5];
        hostStr = [hostStr stringByAppendingString:post6];
        hostStr = [hostStr stringByAppendingString:post7];
        
        
        NSString *string = [[NSString alloc] initWithFormat:@"%@",hostStr];
        
        
        NSURL *urlT = [[NSURL alloc]initWithString:string];
        
      //  [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.image];
        
        __block CeldaInvitacionesCell * cellB = cell;
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlT];
        
        [cell.image setImageWithURLRequest:urlRequest
                        placeholderImage:nil
                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                     cellB.image.image = image;
                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                     NSLog(@"Failed to download image: %@", error);
                                 }];
        cell.image.clipsToBounds=YES;
        cell.image.layer.cornerRadius = 8.0;
        cell.image.layer.borderWidth=1.5;
        cell.image.layer.borderColor=[UIColor blackColor].CGColor;
        cell.clipsToBounds=YES;
        cell.layer.cornerRadius = 8.0;
        cell.layer.borderWidth=1;
        cell.layer.borderColor=[UIColor blackColor].CGColor;
       /* if (((AsyncImageView *)cell.image).image != nil) {
 
            NSLog(@"Añadido");
            
        if ([imagenesArray containsObject:((AsyncImageView *)cell.image).image]) {
        
            [imagenesArray replaceObjectAtIndex:indexPath.row withObject:((AsyncImageView *)cell.image).image];
        }
            
        else{
            [imagenesArray addObject:((AsyncImageView *)cell.image).image];
        }
                
        }*/
    }
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"MensajeSegue"]) {
    //    Usuario *usuario = [ arrayMostrar objectAtIndex:[tabla indexPathForSelectedRow].row];
      // [segue.destinationViewController setNombre:usuario.usuario];
     //  [segue.destinationViewController setFoto:usuario.imagen ];
      //  [segue.destinationViewController setDato:usuario.Estado ];
     
        
    }
   
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate
-(void)colocar{
    animado=NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    vistaBuscar.alpha=1;
    tabla.alpha=1;
    
    [UIView commitAnimations];

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colocar) name:@"Colocar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volver:) name:@"Volver" object:nil];
   
    NSLog(@"Animacion");
    
    CeldaInvitacionesCell *cell = (CeldaInvitacionesCell *)[tableView cellForRowAtIndexPath:indexPath];
   
    
    Usuario *usuario = [arrayMostrar objectAtIndex:[tabla indexPathForSelectedRow].row];
    usuario.imagen= cell.image.image;
    NSData *datos = [NSKeyedArchiver archivedDataWithRootObject:usuario];
    
    [[NSUserDefaults standardUserDefaults] setObject:datos forKey:@"DatosAmigo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
    IndexPulsado=indexPath;
    //[self performSegueWithIdentifier:@"MensajeSegue" sender:self];
    CABasicAnimation *animY = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
    animY.duration = 0.6;
    animY.repeatCount = 1;
    animY.delegate=self;
    animY.removedOnCompletion = YES;
    animY.fillMode = kCAFillModeForwards;
    animY.toValue=[NSNumber numberWithFloat:-550];
    [vistaBuscar.layer addAnimation:animY forKey:nil];
    animY.toValue=[NSNumber numberWithFloat:550];
    [tabla.layer addAnimation:animY forKey:nil];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    vistaBuscar.alpha=0;
    tabla.alpha =0;
    
    [UIView commitAnimations];
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
   
    
  /*
    
    [secondViewController willMoveToParentViewController:self];
    [self.parentViewController addChildViewController:secondViewController];
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.type = kCATransitionFade;//choose your animation
    [secondViewController.view.layer addAnimation:transition forKey:nil];
 
    [self.parentViewController.view addSubview:secondViewController.view];
    [secondViewController didMoveToParentViewController:self];
   */
    
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
 
    
   
    if (!animado) {
        NSLog(@"Mensaje View");
        animado=YES;
     
     UIViewController* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Mensaje"];
    [secondViewController willMoveToParentViewController:self];
    [self.parentViewController addChildViewController:secondViewController];
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.type = kCATransitionFade;//choose your animation
    [secondViewController.view.layer addAnimation:transition forKey:nil];
    
    [self.parentViewController.view addSubview:secondViewController.view];
    [secondViewController didMoveToParentViewController:self];
    }
    
}

@end
