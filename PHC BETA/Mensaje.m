//
//  Mensaje.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 30/03/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "Mensaje.h"

@interface Mensaje ()

@end

@implementation Mensaje
@synthesize viewS,campoActivo;

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
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.view.frame=frame;
    
    alerta=0;
     NSLog(@"Mensaje");
    imagen.clipsToBounds=YES;
    imagen.layer.cornerRadius = 8.0;
    imagen.layer.borderWidth=1.5;
    imagen.layer.borderColor=[UIColor blackColor].CGColor;
    
    viewFondo.clipsToBounds=YES;
    viewFondo.layer.cornerRadius = 8.0;
    viewFondo.layer.borderWidth=1.5;
    viewFondo.layer.borderColor=[UIColor blackColor].CGColor;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *dats = [defaults objectForKey:@"DatosAmigo"];
    usuario = [NSKeyedUnarchiver unarchiveObjectWithData:dats];
    
    imagen.image=usuario.imagen;
    name.text=usuario.usuario;
    datos.text=usuario.Estado;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    
    
    self.view.alpha=0;
    
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    
    
    self.view.alpha=1;
    
    [UIView commitAnimations];
    
    
   
    [mensaje setDelegate:self];
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

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(IBAction)enviar:(id)sender{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.labelText = NSLocalizedString(@"Connecting", @"");
     [self setCampoActivo:nil];
    [self.view endEditing:YES];
    
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
  
    NSString *post2=[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
    
    
    NSString *_key = @"alvarol2611995";
    CCOptions padding = kCCOptionECBMode;
    
    _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
    
     NSData *_secretDataCon = [mensaje.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *encryptedDataCon = [crypto encrypt:_secretDataCon key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
	
	
	/*NSData *decryptedData = [crypto decrypt:encryptedData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
     
     NSLog(@"decrypted data in dex: %@", decryptedData);
     NSString *str = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
     
     NSLog(@"decrypted data string for export: %@",str);
     */
    NSString * encodedStringUsu = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                        NULL,
                                                                                                        (CFStringRef)[encryptedDataCon base64EncodingWithLineLength:0],
                                                                                                        NULL,
                                                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                        kCFStringEncodingUTF8 ));
    

    NSString *ID =[[NSUserDefaults standardUserDefaults] objectForKey:@"ID_usuario"];
    
    NSString *post =[NSString stringWithFormat:@"id=%@&amigo=%@&estado=0",ID, usuario.usuario];
    
    NSString *hostStr = @"http://lanchosoftware.es/app/anadirAmigo.php?";
    hostStr = [hostStr stringByAppendingString:post];
    hostStr = [hostStr stringByAppendingString:post5];
    hostStr = [hostStr stringByAppendingString:post2];
    
    NSString *postString = @"&mensaje=";
      postString = [postString stringByAppendingString:encodedStringUsu];
    
    NSLog(@"%@",hostStr);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:hostStr]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
 
    
    
    NSOperationQueue *cola = [NSOperationQueue new];
    // now lets make the connection to the web
    
    [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"%@ Mensaje",returnString);
         if([returnString isEqualToString:@"Agregado"]){
                 
             UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Aceptado" message:@"Ya sois amigos."
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alertsuccess show];
             
             
         }
         if([returnString isEqualToString:@"Ya es tu amigo"]){
             
             
             UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Ya sois amigos" message:@"No puedes agregar ."
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alertsuccess show];
             
             
             
             
         }
          if([returnString isEqualToString:@""] || [returnString isEqualToString:@"0 NO"] ){
            
             
             UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fatal Error"
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alertsuccess show];
         }

         
             });  }];

}

- (void) alertView:(UIAlertView*)alert3 didDismissWithButtonIndex:(NSInteger)buttonIndex

{
    if (buttonIndex ==0) {
            [self cancelar:nil];
        alerta=1;
    }
    

    
}

-(IBAction)cancelar:(id)sender{
   
    CABasicAnimation *animY = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    
    animY.duration = 0.6;
    animY.repeatCount = 0;
    animY.delegate=self;
    animY.removedOnCompletion = NO;
    animY.fillMode = kCAFillModeForwards;
    animY.toValue=[NSNumber numberWithFloat:550];
    [viewS.layer addAnimation:animY forKey:nil];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    viewS.alpha=0;
    
    [UIView commitAnimations];

   
    
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    NSLog(@"Llamado");
     [[NSNotificationCenter defaultCenter] postNotificationName:@"Colocar" object:nil];
    [viewS removeFromSuperview];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (alerta ==1 ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Volver" object:nil];
    }


   

    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [mensaje resignFirstResponder];
      
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"TEXT");
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
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
    [viewS setContentInset:edgeInsets];
    [viewS setScrollIndicatorInsets:edgeInsets];
    
    [viewS scrollRectToVisible:[self campoActivo].frame animated:YES];
}

- (void) desapareceElTeclado:(NSNotification *)laNotificacion
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
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
