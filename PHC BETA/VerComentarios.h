//
//  VerMensajes.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 18/06/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Usuario.h"
#import "Imagen.h"

@interface VerComentarios :UIViewController <UITableViewDataSource ,UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>{
    
    
    int contadorAntiguo;
    BOOL descargado;
    __weak IBOutlet UILabel *titulo;
    
    __weak IBOutlet UIView *barraInferior;
    CGRect rect;
    __weak IBOutlet UIToolbar *barraSuperior;
    NSMutableArray * URLs;
        NSMutableArray * imagenesCargadas;
    BOOL terminado2;
    NSString *usuarioPasar;
        NSString *idUsuarioPasar;
}
-(IBAction)recargarBoton:(id)sender;
-(IBAction)volver:(id)sender;
-(IBAction)enviar:(id)sender;
- (void)Mensajes;
@property (strong, nonatomic) IBOutlet UINavigationItem *barraNavegador;
@property (retain, nonatomic) IBOutlet UITableView *table;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *texto;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewEnviar;
@property (strong, nonatomic) UITextField *campoActivo;
@property(nonatomic, retain) NSMutableArray *mensajes;
@property(nonatomic, retain) Imagen * us;
@property(nonatomic) int Vez;

@end