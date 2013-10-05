//
// PrivadosViewController.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 30/03/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "PrivadosViewController.h"
#import "MensajesParse.h"
#import "AsyncImageView.h"
#import "ComentariosPase.h"
#import "UIImageView+AFNetworking.h"

@interface PrivadosViewController ()

@end

@implementation PrivadosViewController
@synthesize viewS,campoActivo,ID,usuario;

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
    alerta=0;
    NSLog(@"Mensaje");
 
    viewFondo.clipsToBounds=YES;
    viewFondo.layer.cornerRadius = 8.0;
    viewFondo.layer.borderWidth=1.5;
    viewFondo.layer.borderColor=[UIColor blackColor].CGColor;

    
    
    usuario= [[Usuario alloc]init];
    
    NSData *dats = [[NSUserDefaults standardUserDefaults] objectForKey:@"DatosAmigo"];
  usuario = [NSKeyedUnarchiver unarchiveObjectWithData:dats];
      
  

            NSLog(@"Usuario ID:  %@", usuario.ID);
            NSLog(@"Usuario: %@",usuario.usuario);
     


    name.text=usuario.usuario;
    datos.text=usuario.Estado;
    imagen.image=usuario.imagen;
  
    

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
    
    NSString *post =[NSString stringWithFormat:@"idF=%@",usuario.ID];
    
    NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
    hostStr = [hostStr stringByAppendingString:post];
    hostStr = [hostStr stringByAppendingString:post2];
    hostStr = [hostStr stringByAppendingString:post3];
    hostStr = [hostStr stringByAppendingString:post4];
    hostStr = [hostStr stringByAppendingString:post5];
    hostStr = [hostStr stringByAppendingString:post6];
    hostStr = [hostStr stringByAppendingString:post7];
    
    
    NSString *string = [[NSString alloc] initWithFormat:@"%@",hostStr];
    
    
    NSURL *urlT = [[NSURL alloc]initWithString:string];
    
    __block UIImageView * selfB = imagen;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlT];
    
    [imagen setImageWithURLRequest:urlRequest
                      placeholderImage:nil
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                   selfB.image = image;
                               } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                   NSLog(@"Failed to download image: %@", error);
                               }];


    imagen.clipsToBounds=YES;
    imagen.layer.cornerRadius = 8.0;
    imagen.layer.borderWidth=1.5;
    imagen.layer.borderColor=[UIColor blackColor].CGColor;

    
    self.view.alpha=0;

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
    
    
    [viewFondo addSubview:imagen];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}








- (void) alertView:(UIAlertView*)alert3 didDismissWithButtonIndex:(NSInteger)buttonIndex

{
    if (buttonIndex ==0) {
        [self cancelar:nil];
        alerta=1;
    }
    
    
    
}

-(IBAction)enviar:(id)sender{
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Mensajes) name:@"Mensajes" object:nil];

    BOOL * msj = [[MensajesParse alloc] EnviarMensajeIDM:usuario.ID usuario:usuario.usuario privado:@"1" texto:mensaje.text];

    
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
