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
@synthesize Imagen,descargado;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {


        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    /*
     F1=[[ImagenView alloc]init];
     F2=[[ImagenView alloc]init];
     F3=[[ImagenView alloc]init];
     F4=[[ImagenView alloc]init];
     */
    
  
    
        Imagen.backgroundColor= [UIColor grayColor];
         Imagen.layer.borderWidth=0.2;
         Imagen.layer.borderColor=[UIColor blueColor].CGColor;
        [ Imagen setNeedsDisplay];

}

-(void)ImagenesDe:(NSURL*)URLS{
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    __block BOOL Error= NO;
    Imagenes=[[NSMutableArray alloc]init];
    AFHTTPClient *httpClient  = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [httpClient.operationQueue setMaxConcurrentOperationCount:1] ;
    NSMutableArray *operationsArray = [NSMutableArray array];
    
        //   NSLog(@"URL: %@", us.URLimagen);
        
       
        
        AFImageRequestOperation *getImageOperation =
        [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:URLS]
                                             imageProcessingBlock:nil
                                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                              //
                                                              // Save image
                                                              //
                                                              if(image != nil){
                                                                  Imagen.image=image;
                                                                  descargado=YES;
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
                                               
                                                  
                                                  /* for (int i =0; i< [imagenesCargadas count]; i++) {
                                                   //  UIImageView *Img = [[UIImageView alloc]initWithImage:[imagenesCargadas objectAtIndex:i]];
                                                   UIImage * image = [imagenesCargadas objectAtIndex:i];
                                                   [carousel reloadInputViews];
                                                   [carousel reloadItemAtIndex:i animated:NO];
                                                   }*/
                                                  
                                              });}
                                          
                                          
                                      }];

 });
    
    
}



@end
