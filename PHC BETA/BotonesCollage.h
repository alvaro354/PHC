//
//  BotonesCollage.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 05/03/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "AutomaticVC.h"
#import "AutomaticVC2.h"
#import "AutomaticVCI.h"
#import "AutomaticVCI2.h"

@interface BotonesCollage : UIViewController<iCarouselDataSource,iCarouselDelegate>{
    
    IBOutlet UIButton *manual;
    IBOutlet UIButton *automatico;
       BOOL Carrousuelpuesto;
}
-(IBAction)automatico:(id)sender;
-(IBAction)manual:(id)sender;
@property (nonatomic) IBOutlet iCarousel *carousel;
@end
