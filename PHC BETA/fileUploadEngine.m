//
//  fileUploadEngine.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 26/03/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "fileUploadEngine.h"

@implementation fileUploadEngine

-(MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path post:(BOOL *)post {
    
    MKNetworkOperation *op ;
    [op setFreezable:YES];
    
    if (post) {
        op = [self operationWithPath:path params:params
                                              httpMethod:@"POST"];
    }
    else{
        op = [self operationWithPath:path];
    }
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        if([completedOperation isCachedResponse]) {
            DLog(@"Data from cache");
        }
        else {
            DLog(@"Data from server");
        }
        
        
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        
       // errorBlock(error);
    }];
    

    
    return op;
    
}

-(NSString*) cacheDirectoryName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"Amigos"];
    return cacheDirectoryName;
}
- (int) cacheMemoryCost
{
    return 1000;
}
 
@end
