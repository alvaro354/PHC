//
//  LoadEngine.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 27/03/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "LoadEngine.h"

@implementation LoadEngine


-(MKNetworkOperation*) imagesForID:(NSString*)ID completionHandler:(ImagesResponseBlock) imageURLBlock errorHandler:(MKNKErrorBlock) errorBlock{
    

    
    NSDate *myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    NSDateFormatter *dma = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    [dma setDateFormat:@"dd-mm-yyyy"];
  
    NSString *post2=[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
    NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
    
        NSString *post =[NSString stringWithFormat:@"id=%@",ID];
        
        NSString *hostStr = @"lanchosoftware.es/phc/downloadImage.php?";
        hostStr = [hostStr stringByAppendingString:post];
        hostStr = [hostStr stringByAppendingString:post2];
        hostStr = [hostStr stringByAppendingString:post3];
        NSLog(@"%@ URL", hostStr);
    
    MKNetworkOperation *op = [self operationWithPath:hostStr];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        if([completedOperation isCachedResponse]) {
            DLog(@"Data from cache");
        }
        else {
            DLog(@"Data from server");
        }
        
      NSData *data = [completedOperation responseData];
        
        imageURLBlock(data);
        
        
     
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    
     return op;
}

-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"Amigos"];
    return cacheDirectoryName;
}


@end
