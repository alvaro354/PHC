//
//  PopularesView.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 03/11/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFImageRequestOperation.h"
#import "PopularesView.h"
#import "ImagenView.h"

@implementation PopularesView
@synthesize F1,F2,F3,F4;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
     
        
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    Marcos= [[NSMutableArray alloc]initWithObjects:F1,F2,F3,F4,nil];
    for (ImagenView * IV in Marcos) {
        IV.backgroundColor= [UIColor grayColor];
        IV.layer.borderWidth=1;
        IV.layer.borderColor=[UIColor blackColor].CGColor;
        
        [self reloadInputViews];
}
}

-(void)ImagenesDe:(NSMutableArray*)URLS{
   
    __block BOOL Error= NO;
    Imagenes=[[NSMutableArray alloc]init];
    AFHTTPClient *httpClient  = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [httpClient.operationQueue setMaxConcurrentOperationCount:1] ;
    NSMutableArray *operationsArray = [NSMutableArray array];
    for (NSURL *us in URLS) {
        
        //   NSLog(@"URL: %@", us.URLimagen);
        
       
        
        AFImageRequestOperation *getImageOperation =
        [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:us]
                                             imageProcessingBlock:nil
                                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                              //
                                                              // Save image
                                                              //
                                                              if(image != nil){
                                                                  [Imagenes addObject:image];
                                                              }
                                                              else{
                                                                  Error=YES;
                                                                  NSLog(@"Image request CACHE error!");
                                                              }
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
        
        
        
        
    }
    
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
                                          if(Error){
                                              
                                              
                                              // IMPORTANTE BORRAR DE LA CACHE Y VOLVER A CARGAR
                                              
                                              
                                          }
                                          else{
                                              NSLog(@"Imagenes: %lu", (unsigned long)[Imagenes count]);
                                              
                                             
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self colocarImagenes];
                                                  
                                                  /* for (int i =0; i< [imagenesCargadas count]; i++) {
                                                   //  UIImageView *Img = [[UIImageView alloc]initWithImage:[imagenesCargadas objectAtIndex:i]];
                                                   UIImage * image = [imagenesCargadas objectAtIndex:i];
                                                   [carousel reloadInputViews];
                                                   [carousel reloadItemAtIndex:i animated:NO];
                                                   }*/
                                                  
                                              });}
                                          
                                          
                                      }];

    
    
    
}

-(void)colocarImagenes{
    NSLog(@"Colocando");
    for (int i=0 ; i < [Imagenes count]; i++) {
        ImagenView * IV = [Marcos objectAtIndex:i];
        IV.image= [Imagenes objectAtIndex:i];
        //[self addSubview:IV];
    }
    [self reloadInputViews];
}

@end
