//
//  NSData+AESCrypt.h
//
//  AES128Encryption + Base64Encoding
//

#import <Foundation/Foundation.h>

@interface NSData (AESCrypt)

- (NSData *)AES128EncryptWithKey;

- (NSString *)base64Encoding;

@end
