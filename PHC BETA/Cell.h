//
//  Cell.h
//  Location
//
//  Created by Alvaro Lancho on 22/07/12.
//  Copyright (c) 2012 Burgo Ventanas I S.L.U. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface Cell : UICollectionViewCell{
  }
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UIImageView *image;
@property BOOL actividad;
@property (nonatomic, retain) UIActivityIndicatorView *indicador;

@end
