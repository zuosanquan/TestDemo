//
//  NSString+Utils.m
//  TestDemo
//
//  Created by camera360 on 16/5/4.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

+(instancetype)stringFromInteger:(NSInteger)value
{
    return [self stringWithFormat:@"%ld", value];
}

@end
