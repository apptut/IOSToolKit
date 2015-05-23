//
//  NSString+MD5.m
//  Muse
//
//  实现字符串md5函数处理
//

#import "NSString+ITK_MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ITK_MD5)

- (NSString *)itk_MD5
{
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

@end
