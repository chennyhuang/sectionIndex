#import "ChineseToPinyin.h"

@implementation ChineseToPinyin

+ (NSString *)pinyinFromChineseString:(NSString *)string
{
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeUppercase];
    
    NSString *str = [PinyinHelper toHanyuPinyinStringWithNSString:string withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
    return str;
}

+ (NSString *)spFromChineseString:(NSString *)string
{
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeUppercase];
    NSString *str1 = [PinyinHelper SptoHanyuPinyinStringWithNSString:string withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
    return str1;
}

@end
