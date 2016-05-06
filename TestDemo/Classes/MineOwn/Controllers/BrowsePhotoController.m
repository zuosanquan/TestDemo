//
//  BrowsePhotoController.m
//  TestDemo
//
//  Created by camera360 on 16/5/5.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import "BrowsePhotoController.h"
#import <PureLayout/PureLayout.h>

const static NSInteger defaultImageCount = 3;

@interface BrowsePhotoController ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView   * scrollView;
@property(nonatomic, strong) UIImageView    * leftImageView;
@property(nonatomic, strong) UIImageView    * centerImageView;
@property(nonatomic, strong) UIImageView    * rightImageView;
@property(nonatomic, strong) NSMutableArray * imageSizeArr;
@property(nonatomic, strong) UIScrollView   * centerScorllView;
@property(nonatomic, strong) NSMutableArray<ALAsset *> * assets;
@property(nonatomic, assign) NSInteger      imageCount;


@end

@implementation BrowsePhotoController

-(NSMutableArray *)imageSizeArr
{
    if (_imageSizeArr == nil) {
//        初始化一个所有图片数量的数组
        _imageSizeArr = [NSMutableArray arrayWithCapacity:_imageCount];
        for (int i= 0; i < _imageCount; i++) {
            [_imageSizeArr addObject:@(0)];
        }
    }
    return _imageSizeArr;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44-64)];
        _scrollView.contentSize = CGSizeMake(defaultImageCount * kScreenWidth, 0);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        _scrollView.userInteractionEnabled = true;
        [_scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:false];
        _scrollView.pagingEnabled = true;
        _scrollView.showsHorizontalScrollIndicator = false;
//        将左中右image添加到滚动视图中
        [_scrollView addSubview:self.leftImageView];
        [_scrollView addSubview:self.centerScorllView];
        [_scrollView addSubview:self.rightImageView];
    }
    return _scrollView;
}

-(UIScrollView *)centerScorllView
{
    if (!_centerScorllView)
    {
        _centerScorllView = [[UIScrollView alloc] init];
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = kScreenWidth;
        _centerScorllView.frame = frame;
        _centerScorllView.contentSize = CGSizeMake(kScreenWidth, 0);
        _centerScorllView.backgroundColor = [UIColor whiteColor];
        _centerScorllView.delegate = self;
        _centerScorllView.userInteractionEnabled = true;
        _centerScorllView.showsHorizontalScrollIndicator = false;
        _centerScorllView.showsVerticalScrollIndicator = false;
        _centerScorllView.bouncesZoom = true;
        _centerScorllView.maximumZoomScale = 3.0;
        _centerScorllView.minimumZoomScale = 1.0;
        [_centerScorllView setZoomScale:1.0];
        //将中间image添加到滚动视图中
        [_centerScorllView addSubview:self.centerImageView];
      
    }
    return _centerScorllView;
}

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = 0;
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
//        因为进入到这个页面， 必然是点击了照片， 所以一定会至少存在一张照片， 可以在此设置默认值
        UIImage * image = [self fetchOriginImageAtIndex:(_currentIndex-1)];
        CGSize imageSize = image.size;
        CGFloat useHeight = (imageSize.height * kScreenWidth) / imageSize.width;
        frame.size.height = useHeight;
        _leftImageView.frame = frame;
        _leftImageView.image = image;
        
    }
    return _leftImageView;
}

- (UIImageView *)centerImageView
{
    if (!_centerImageView) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = 0;
        _centerImageView = [[UIImageView alloc] init];
        _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage * image = [self fetchOriginImageAtIndex:_currentIndex];
        CGSize imageSize = image.size;
        CGFloat useHeight = imageSize.height * kScreenWidth / imageSize.width;
        frame.size.height = useHeight;
        _centerImageView.frame = frame;
        _centerImageView.image = image;
        //给中间图片添加点击事件， 双击放大
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
        [_centerScorllView addGestureRecognizer:doubleTap];
    }
    return _centerImageView;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView)
    {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = kScreenWidth * 2;
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage * image = [self fetchOriginImageAtIndex:_currentIndex + 1];
        CGSize imageSize = image.size;
        CGFloat useHeight = imageSize.height * kScreenWidth / imageSize.width;
        frame.size.height = useHeight;
        _rightImageView.frame = frame;
        _rightImageView.image = image;
    }
    return _rightImageView;
}

- (NSMutableArray<ALAsset *> *)assets
{
    if (_assets == nil) {
        _assets = @[].mutableCopy;
    }
    return _assets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
}

- (void)setGroup:(ALAssetsGroup *)group
{
    _group = group;
    //解析图片数据
    _imageCount = [group numberOfAssets];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if (result && [[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
            [self.assets addObject:result];
    }];
    
}

#pragma Mark -- 辅助方法， 获取asset中图片等

- (UIImage *)fetchOriginImageAtIndex:(NSInteger) index;
{
    NSInteger useIndex = (index+_imageCount)%_imageCount;
    ALAsset * asset = [_assets objectAtIndex:useIndex];
    ALAssetRepresentation * representation = [asset defaultRepresentation];
    CGImageRef imageRef = [representation fullScreenImage];
    UIImage * image =  [UIImage imageWithCGImage:imageRef];
    if (![self.imageSizeArr[useIndex] integerValue])
    {
        CGFloat  height = image.size.height * kScreenWidth / image.size.width;
        [self.imageSizeArr replaceObjectAtIndex:useIndex withObject:@(height)];
    }
    return image;
}


#pragma Mark -- 搭建UI
- (void)initialUI
{
    [self.view addSubview:self.scrollView];
    self.navigationController.navigationBar.translucent = false;
}

#pragma Mark -- ScrollView Delegate & DataSource
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollView == scrollView)
    {
//        如果偏移量较小， 不需要改变图片偏移
        if (scrollView.contentOffset.x == kScreenWidth)
            return;
        [self reloadImage];
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:false];
        [self.centerScorllView setZoomScale:1.0];
    }
}

/**
 *  刷新图片， 制造图片滑动的假象
 */
- (void)reloadImage
{
    //判断滑动方向
    if (self.scrollView.contentOffset.x == kScreenWidth * 2)
        //向右滑动
        _currentIndex = (++_currentIndex) % _imageCount;
    else
        //向左滑动
        _currentIndex = (--_currentIndex + _imageCount) % _imageCount;
    //更新图片
    UIImage * leftImage = [self fetchOriginImageAtIndex:_currentIndex-1];
    UIImage * centerImage = [self fetchOriginImageAtIndex:_currentIndex];
    UIImage * rightImage = [self fetchOriginImageAtIndex:_currentIndex + 1];
    //需要分别更改imageView的大小来去掉白边
    NSInteger leftIndex = (_currentIndex - 1 + _imageCount)%_imageCount;
    NSInteger rightIndex = (_currentIndex + 1)%_imageCount;
    CGRect frame = _leftImageView.frame;
    frame.size.height = [self.imageSizeArr[leftIndex] floatValue];
    _leftImageView.frame = frame;
    _leftImageView.image = leftImage;
    frame = _centerImageView.frame;
    frame.size.height = [self.imageSizeArr[_currentIndex] floatValue];
    _centerImageView.frame = frame;
    _centerImageView.image = centerImage;
    frame = _rightImageView.frame;
    frame.size.height = [self.imageSizeArr[rightIndex] floatValue];
    _rightImageView.frame = frame;
    _rightImageView.image = rightImage;
    
    
}

#pragma Mark -- 图片方法缩小, 改变矩阵的方式来实现
- (void)scaleImage:(UITapGestureRecognizer *) sender
{
//    默认双击放大1.5倍
    float newScale = [(UIScrollView *)sender.view.superview zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale inView:_centerScorllView withCenter:[sender locationInView:sender.view]];
    [_centerScorllView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale inView:(UIScrollView *) scrollView withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = _centerScorllView.frame.size.height / scale;
    zoomRect.size.width  = _centerScorllView.frame.size.width / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width * 0.5);
    zoomRect.origin.y    = center.y - (zoomRect.size.height * 0.5);
    return zoomRect;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView * view in _centerScorllView.subviews) {
        return view;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
