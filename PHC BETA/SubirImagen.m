//
//  SubirImagen.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 14/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "SubirImagen.h"

@interface SubirImagen ()

@end

@implementation SubirImagen
@synthesize flOperation,flUploadEngine,imagen,campoActivo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) alertView:(UIAlertView*)alert3 didDismissWithButtonIndex:(NSInteger)buttonIndex

{
    
	if (buttonIndex == 0 && alert3.tag == 1)
	{
        [self volver:nil];
    }
}

-(IBAction)SubirImagen:(id)sender{
    
    
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
    NSData *imageData = UIImageJPEGRepresentation(imagen, 0.5);
    
    NSLog(@" Tamaño Imagen : %d",[imageData length]);
    
    
    
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
    
    NSString * amg = [[NSString alloc] initWithFormat:@""] ;
    for (Usuario *u in etiquetados) {
        if ([amg isEqualToString:@""]) {
           amg= [amg stringByAppendingString:[NSString stringWithFormat:@"%@",u.ID]];
        }
        else{

            amg= [amg stringByAppendingString:[NSString stringWithFormat:@",%@",u.ID]];
        }
    }
       

    NSString * encodedTitulo = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                           NULL,
                                                                                                           (CFStringRef)titulo.text,
                                                                                                           NULL,
                                                                                                           (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                           kCFStringEncodingUTF8 ));
    NSString * encodedAmigos = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                     NULL,
                                                                                                     (CFStringRef)amg,
                                                                                                     NULL,
                                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                     kCFStringEncodingUTF8 ));
    

    
    
 
    
    NSData* imagen2=[[encryptedData base64EncodingWithLineLength:0] dataUsingEncoding:[NSString defaultCStringEncoding] ] ;
    
    
    NSString *post =[NSString stringWithFormat:@"id=%@",usuarioID];
    NSString *post2 =[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
    NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
    NSString *post4=[NSString stringWithFormat:@"&hora=%@",[hms stringFromDate:myDate]];
    NSString *post5=[NSString stringWithFormat:@"&token=%@",tokenID];
     NSString *post6=[NSString stringWithFormat:@"&titulo=%@",encodedTitulo ];
     NSString *post7=[NSString stringWithFormat:@"&publico=%ld",(long)privacidad.selectedSegmentIndex];
         NSString *post8=[NSString stringWithFormat:@"&etiquetas=%@",encodedAmigos ];
     NSString *post9=[NSString stringWithFormat:@"&altura=%f",imagen.size.height];
    
    
    NSString *urlString= @"http://lanchosoftware.es/phc/imageupload.php?";
    // NSString *urlString= @"http://lanchosoftware.es/app/imagenperfil.php?";
    urlString = [urlString stringByAppendingString:post];
    urlString = [urlString stringByAppendingString:post2];
    urlString = [urlString stringByAppendingString:post3];
    urlString = [urlString stringByAppendingString:post4];
    urlString = [urlString stringByAppendingString:post5];
     urlString = [urlString stringByAppendingString:post6];
     urlString = [urlString stringByAppendingString:post7];
    urlString = [urlString stringByAppendingString:post8];
    urlString = [urlString stringByAppendingString:post9];
    
        NSLog(@"URL: %@",urlString);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"imagename.jpg\"\r\n",index] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imagen2]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSOperationQueue *cola = [NSOperationQueue new];
    // now lets make the connection to the web
    
    [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{ 
         
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         if ( [returnString isEqualToString:@"Yes"]) {
             
                          
             UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Great!" message:@"Foto Subida"
                                                                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             alertsuccess.tag=1;
             [alertsuccess show];
         }
         else{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error"
                                                                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             alertsuccess.tag=0;
             [alertsuccess show];
         }
         self->returnData=[[NSData alloc]initWithData:data];
          
              self->returnData=[[NSData alloc]initWithData:data];
             
         });
     }];
    NSLog(@"%u",[returnData length]);
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@ Resultado",returnString);

    
    
}

- (void)viewDidLoad
{
    titulo.delegate=self;
    animado =NO;
    scroll.layer.borderWidth=1.5;
    scroll.layer.borderColor=[UIColor blackColor].CGColor;
    vistaFondo.alpha=0.3;
    NSLog(@"Caracteristicas Imagen");
    buscar.clipsToBounds=YES;
    buscar.layer.cornerRadius = 8.0;
     
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
    
    arrayMostrar=[[NSMutableArray alloc]init];
    
    NSData *datos = [[NSUserDefaults standardUserDefaults] objectForKey:@"DatosGuardados"];
    amigos = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
    NSLog(@"%u Amigos",[amigos count]);
    
    [tabla reloadData];
    
    [super viewDidLoad];
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
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [titulo resignFirstResponder];
  
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

    [self setCampoActivo:nil];
}
- (void) apareceElTeclado:(NSNotification *)laNotificacion
{
    NSLog(@"Aparece");
    NSDictionary *infoNotificacion = [laNotificacion userInfo];
    CGSize tamanioTeclado = [[infoNotificacion objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height+30, 0);
    [scroll setContentInset:edgeInsets];
    [scroll setScrollIndicatorInsets:edgeInsets];
    
    [scroll scrollRectToVisible:[self campoActivo].frame animated:YES];
}

- (void) desapareceElTeclado:(NSNotification *)laNotificacion
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.15];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [scroll setContentInset:edgeInsets];
    [scroll setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}

#pragma mark - Métodos de acción adicionales
- (void) scrollViewPulsado
{
    [[self view] endEditing:YES];
}

-(void)getData{
    
 
    
    
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
    [scroll.layer addAnimation:animY forKey:nil];
    //animY.toValue=[NSNumber numberWithFloat:550];
    //[tabla.layer addAnimation:animY forKey:nil];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDidStopSelector:@selector(removeMyView)];
    
    self.view.alpha=0;
    
    [UIView commitAnimations];
    
}


-(void)removeMyView{
    [scroll removeFromSuperview];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}
-(IBAction)descargar:(id)sender{
    NSLog(@"Descargando" );
    StringEncryption *crypto = [[StringEncryption alloc] init] ;
    
    NSLog(@"Obteniendo datos");
    NSDate *myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    NSDateFormatter *dma = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    [dma setDateFormat:@"dd-mm-yyyy"];
    
    NSString *_key = @"alvarol2611995";
    
    
    _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
    
    NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
    
    NSString *post2=[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
    NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
    __block NSString* IDFinal;
    Usuario *Usu = [ arrayMostrar objectAtIndex:[ arrayMostrar count]-1];
    IDFinal = Usu.usuario;
    
    NSString *post4=[NSString stringWithFormat:@"&token=%@",tokenID];
    NSString *post5 =[NSString stringWithFormat:@"&id=%@",usuarioID];
    NSString *post6 =[NSString stringWithFormat:@"&perfil=1"];
    
    
    if ([ arrayMostrar count] != 0) {
        
        Usuario *Usu = [ arrayMostrar objectAtIndex:[ arrayMostrar count]-1];
        IDFinal = Usu.usuario;
    }
    else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    
    
    for(Usuario *Usuarios in  arrayMostrar){
        
        
        NSString *post =[NSString stringWithFormat:@"idF=%@",Usuarios.usuario];
        
        NSString *hostStr = @"/phc/downloadImage.php?";
        hostStr = [hostStr stringByAppendingString:post];
        hostStr = [hostStr stringByAppendingString:post2];
        hostStr = [hostStr stringByAppendingString:post3];
        hostStr = [hostStr stringByAppendingString:post4];
        hostStr = [hostStr stringByAppendingString:post5];
        hostStr = [hostStr stringByAppendingString:post6];
        
        
        NSLog(@"%@",hostStr);
        
        self.flUploadEngine = [[fileUploadEngine alloc] initWithHostName:@"lanchosoftware.es" customHeaderFields:nil];
        
        
        self.flOperation = [self.flUploadEngine postDataToServer:nil path:hostStr post:NO];
        [self.flOperation addCompletionHandler:^(MKNetworkOperation* operation) {
            
            
            if([operation isCachedResponse]) {
                NSLog(@"Data from cache");
            }
            else {
                NSLog(@"Data from server");
            }
            
            NSData *datas = [operation responseData];
            
            CCOptions padding = kCCOptionECBMode;
            NSString *string = [[NSString alloc] initWithData:datas encoding:NSASCIIStringEncoding];
            NSData *_secretData = [NSData dataWithBase64EncodedString:string];
            
            NSData *encryptedData = [crypto decrypt:_secretData  key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
            
            
            Usuarios.imagen= [[UIImage alloc] initWithData:encryptedData];
            
            NSLog(@"%f,%f",Usuarios.imagen.size.width,Usuarios.imagen.size.height);
            if ([IDFinal isEqualToString:Usuarios.usuario]) {
                [self->tabla reloadData];
            }
        }
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
    return [amigos count];
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
    
    
    
    if ([arrayMostrar count] !=0) {
        Usuario *items = [arrayMostrar objectAtIndex:indexPath.row];
        cell.name.text = items.usuario;
        if (items.imagen == nil) {
            cell.image.backgroundColor = [UIColor grayColor];
            
        }
        else{
            cell.image.image= items.imagen;
        }
        cell.image.clipsToBounds=YES;
        cell.image.layer.cornerRadius = 8.0;
        cell.image.layer.borderWidth=1.5;
        cell.image.layer.borderColor=[UIColor blackColor].CGColor;
    }
    else{
       
        Usuario *items = [amigos objectAtIndex:indexPath.row];
        cell.name.text = items.usuario;
         NSLog(@"%@ Nombre",items.usuario );
        if (items.imagen == nil) {
            cell.image.backgroundColor = [UIColor grayColor];
             NSLog(@"NO Imagen");
        }
        else{
            cell.image.image= items.imagen;
        }
        cell.image.clipsToBounds=YES;
        cell.image.layer.cornerRadius = 8.0;
        cell.image.layer.borderWidth=1.5;
        cell.image.layer.borderColor=[UIColor blackColor].CGColor;
        
    }
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"MensajeSegue"]) {
        Usuario *usuario = [ arrayMostrar objectAtIndex:[tabla indexPathForSelectedRow].row];
        /*   [segue.destinationViewController setNombre:usuario.usuario];
         [segue.destinationViewController setFoto:usuario.imagen ];
         [segue.destinationViewController setDato:usuario.Estado ];
         */
        
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
    
    scroll.alpha=1;
    tabla.alpha=1;
    
    [UIView commitAnimations];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Usuario * usuario ;
    if ([arrayMostrar count] != 0 ) {
        usuario = [arrayMostrar objectAtIndex:indexPath.row];
        
    }  else{
        usuario = [amigos objectAtIndex:indexPath.row];
        
    }

    if(etiquetados == nil || [etiquetados count]==0){
        etiquetados = [[NSMutableArray alloc]init];
        [etiquetados addObject:usuario];
            NSLog(@" Etiquetados: %@", etiquetados);
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];    
        
        return;
    }
    
    
    if ([etiquetados count] >0) {
    for (int i = 0; i < [etiquetados count]; i++) {
        Usuario * us = [etiquetados objectAtIndex:i];
        if (us == usuario) {
            NSLog(@" Desetiquetado: %@", usuario.usuario);
            [etiquetados removeObjectAtIndex:i];
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            NSLog(@" Etiquetados: %@", etiquetados);
            return;
        }
        if (i == [etiquetados count]-1) {
                NSLog(@" Etiquetado: %@", usuario.usuario);
            [etiquetados addObject:usuario];
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            NSLog(@" Etiquetados: %@", etiquetados);
            return;
            
            
        }
        
    }
    }
    NSLog(@" Etiquetados: %@", etiquetados);
    
    
    
    
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    NSLog(@"Animado");
    
    
    if (!animado) {
        animado=YES;
        Usuario *usuario = [arrayMostrar objectAtIndex:[tabla indexPathForSelectedRow].row];
        NSData *datos = [NSKeyedArchiver archivedDataWithRootObject:usuario];
        [[NSUserDefaults standardUserDefaults] setObject:datos forKey:@"DatosAmigo"];
        [self.flOperation cancel];
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
