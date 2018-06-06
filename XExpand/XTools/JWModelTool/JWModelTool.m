//
//  ZJModelTool.m
//  MyDamaiProject
//
//  Created by canoe on 16/9/28.
//  Copyright (c) 2016年 canoe. All rights reserved.
//

#import "JWModelTool.h"

@implementation JWModelTool

//代码创建model类
+(void)createModelWithDictionary:(NSDictionary *)dict modelName:(NSString *)modelName
{
    dispatch_queue_t queue = dispatch_queue_create("tk.bourne.testQueue", DISPATCH_QUEUE_CONCURRENT);
    printf("\n@interface %s :NSObject\n",modelName.UTF8String);
    for (NSString *key in dict) {
        NSString *qualifierStr = @"copy";
        NSString *typeStr = @"NSString";
        
        NSObject *value = dict[key];
        if ([value isKindOfClass:[NSString class]]) {
            printf("@property (nonatomic, %s) %s *%s;\n",qualifierStr.UTF8String,typeStr.UTF8String,key.UTF8String);
        }else if([value isKindOfClass:[@(YES) class]]){
            qualifierStr = @"assign";
            typeStr = @"BOOL";
            printf("@property (nonatomic, %s) %s %s;\n",qualifierStr.UTF8String,typeStr.UTF8String,key.UTF8String);
        }else if([value isKindOfClass:[NSNumber class]]){
            qualifierStr = @"assign";
            NSString *valueStr = [NSString stringWithFormat:@"%@",value];
            if ([valueStr rangeOfString:@"."].location!=NSNotFound){
                typeStr = @"CGFloat";
            }else{
                NSNumber *valueNumber = (NSNumber *)value;
                if ([valueNumber longValue] < 2147483648) {
                    typeStr = @"NSInteger";
                }else{
                    typeStr = @"long long";
                }
            }
            printf("@property (nonatomic, %s) %s %s;\n",qualifierStr.UTF8String,typeStr.UTF8String,key.UTF8String);
        }else if([value isKindOfClass:[NSArray class]]){
            NSArray *array = (NSArray *)value;
            NSString *genericTypeStr = @"";
            //判断数组是否有值
            if (array.count > 0) {
                NSObject *firstObj = [array firstObject];
                if ([firstObj isKindOfClass:[NSDictionary class]]) {
                    genericTypeStr = [NSString stringWithFormat:@"<<#%@Model#> *>",key];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), queue, ^{
                        printf("\n//-----------------新的Model-------------");
                        [JWModelTool createModelWithDictionary:array[0] modelName:[NSString stringWithFormat:@"<#%@Model#>",key]];
                    });
                }else if ([firstObj isKindOfClass:[NSString class]]){
                    genericTypeStr = @"<NSString *>";
                }else if ([firstObj isKindOfClass:[NSNumber class]]){
                    genericTypeStr = @"<NSNumber *>";
                }
                
                qualifierStr = @"strong";
                typeStr = @"NSArray";
                printf("@property (nonatomic, %s) %s%s *%s;\n",qualifierStr.UTF8String,typeStr.UTF8String,genericTypeStr.UTF8String,key.UTF8String);
            }else
            {
                printf("@property (nonatomic, %s) %s *%s;\n//数组内部没有数据,所以无法读取\n",qualifierStr.UTF8String,typeStr.UTF8String,key.UTF8String);
            }
        }else if ([value isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)value;
            qualifierStr = @"strong";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), queue, ^{
                printf("\n//-----------------新的Model-------------");
                [JWModelTool createModelWithDictionary:dict modelName: [NSString stringWithFormat:@"<#%@Model#>",key]];
            });
            printf("@property (nonatomic, %s) %s *%s;\n",qualifierStr.UTF8String,[NSString stringWithFormat:@"<#%@Model#>",key].UTF8String,key.UTF8String);
        }else
        {
            printf("@property (nonatomic, %s) %s *%s;\n",qualifierStr.UTF8String,typeStr.UTF8String,key.UTF8String);
        }
    }
    printf("@end\n");
    
    //.m 文件里面的内容
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), queue, ^{
        printf("\n@implementation %s\n",modelName.UTF8String);
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSString *key in dict) {
            NSObject *value = dict[key];
            if([value isKindOfClass:[NSArray class]]){
                [arrayM addObject:[NSString stringWithFormat:@"@\"%@\" : [<#%@Model#> class]",key,key]];
            }
        }
        if (arrayM.count > 0) {
            NSString *str = [arrayM componentsJoinedByString:@","];
            printf("+ (NSDictionary *)objectClassInArray{\n     return @{%s};\n}",str.UTF8String);
        }
        printf("\n@end\n");
    });
}
@end
