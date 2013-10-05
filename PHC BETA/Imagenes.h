//
//  Imagenes.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 11/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ScrollView.h"
#import "AsyncImageView.h"



@interface Imagenes : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>{
    BOOL toolbarHidden ;
    BOOL  iadHidden;
    UIImageView * viewI ;
    CGFloat firstX;
	CGFloat firstY;
    ScrollView *scroll;
    Imagen* imagen2;
    IBOutlet UILabel *  titulo;
    NSMutableArray * imagenesCargadas;
}
-(IBAction)volver:(id)sender;
-(IBAction)etiquetas:(id)sender;
-(IBAction)comentarios:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *barraSuperior;
@property (nonatomic,strong) UIImage* imageFondo;
@property (nonatomic,strong) NSString* url;
@property (nonatomic,strong) NSURL* urlDatos;
@property (weak, nonatomic) IBOutlet UIToolbar *barraInferior;
@property (weak, nonatomic) IBOutlet UIImageView *ViewFondo;
@property float width;
@property float height;


@end
