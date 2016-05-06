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


//等比例缩放图片
- (UIImage *)scaleToSize:(CGSize) size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    float verticalRadio = size.height * 1.0 / height;
    float horizontalRadio = size.width * 1.0 / width;
    
    float radio = 1;
    //如果横纵向放大倍数都大于1， 以较小倍数为准
    if (verticalRadio > 1 && horizontalRadio > 1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    //如果有一个方向是缩小的， 则以缩小为准
    else
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    width = width * radio;
    height = height * radio;
    
    int xPos = (size.width - width) * 0.5;
    int yPos = (size.height - height) * 0.5;
    
    //创建一个位图的context， 并设置为当前使用的context
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    //绘制改变大小的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    //使当前的context出堆栈
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)imageFillSize:(CGSize)viewsize
{
    CGSize size = self.size;
    CGFloat scalex = viewsize.width / size.width;
    CGFloat scaley = viewsize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    UIGraphicsBeginImageContext(viewsize);
    
    float width = size.width * scale;
    float height = size.width * scale;
    
    float dwidth = (viewsize.width - width) * 0.5;
    float dheight = (viewsize.height = height) * 0.5;
    
    CGRect rect = CGRectMake(dwidth, dheight, width, height);
    [self drawInRect:rect];
    
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

// 缩放从顶部开始平铺图片
- (UIImage *)imageScaleAspectFillFromTop:(CGSize)frameSize
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat radio = self.size.height / self.size.width;
    CGFloat height = frameSize.height * radio;
    
    UIImage * adjustImg = [self scaleToSize:CGSizeMake(frameSize.width * screenScale, height)];
    
    adjustImg = [adjustImg subImageInRect:CGRectMake(0, 0, frameSize.width * screenScale, frameSize.width * screenScale)];
    return adjustImg;
}


- (UIImage *)subImageInRect:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage * smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CFRelease(subImageRef);
    return smallImage;
}


@end
