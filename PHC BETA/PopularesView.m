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
@synthesize F1,F2,F3,F4,Marcos;

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
    /*
     F1=[[ImagenView alloc]init];
     F2=[[ImagenView alloc]init];
     F3=[[ImagenView alloc]init];
     F4=[[ImagenView alloc]init];
     */
    
    Marcos= [[NSMutableArray alloc]initWithObjects:F1,F2,F3,F4,nil];
    NSLog(@"Iniciando");

    for (ImagenView * IV in Marcos) {
       
        IV.backgroundColor= [UIColor grayColor];
        IV.layer.borderWidth=0.2;
        IV.layer.borderColor=[UIColor blueColor].CGColor;
        [IV setNeedsDisplay];
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

    for (int i=0 ; i < 4; i++) {
            NSLog(@"Colocando: %d",i);
        ImagenView * IV = [Marcos objectAtIndex:i];
        [IV setImage:[Imagenes objectAtIndex:i]];
      //  IV.backgroundColor=[UIColor whiteColor];
        [IV setNeedsDisplay];
        [self setNeedsDisplay];
        [super setNeedsDisplay];

    }
 
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    PopularesView *another = [[PopularesView alloc] init];
    another.F1 = F1;
    another.F2 = F2;
    another.F3 = F3;
    another.F4 = F4;
    another.backgroundColor= [UIColor redColor];
    
    return another;
}

@end
