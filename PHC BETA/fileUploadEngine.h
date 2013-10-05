//
//  fileUploadEngine.h
//  PHC BETA
//
//  Created by Alvaro Lancho on 26/03/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface fileUploadEngine : MKNetworkEngine

-(MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path post:(BOOL *)post;

@end


