//
//  NSString+AESCrypt.h
//
//  AES128Encryption + Base64Encoding
//

#import "NSString+AESCrypt.h"

@implementation NSString (AESCrypt)

- (NSString *)AES128EncryptWithKey
{
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [plainData AES128EncryptWithKey];
    
    NSString *encryptedString = [encryptedData base64Encoding];
    
    return encryptedString;
}

@end
