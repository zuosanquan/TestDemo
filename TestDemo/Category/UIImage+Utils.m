//
//  UIImage+Utils.m
//  TestDemo
//
//  Created by camera360 on 16/5/4.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

+(instancetype)originalImageNamed:(NSString *)imageName
{
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


@end
