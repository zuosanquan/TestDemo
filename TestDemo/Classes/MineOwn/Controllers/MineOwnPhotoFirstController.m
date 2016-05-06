//
//  MineOwnPhotoFirstController.m
//  TestDemo
//
//  Created by camera360 on 16/5/4.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import "MineOwnPhotoFirstController.h"
#import "BrowsePhotoController.h"
#import "AbbrevPhotoCell.h"
#import "PhotoModel.h"

static NSString * kCollectCellIdentifier = @"kCollectCellIdentifier";

static const CGFloat insetEdge           = 5.0;
//默认每行显示图片个数为4个
static CGFloat       itemPerLine         = 5.0;
//每个item的大小
static CGFloat       itemSizeWidth       = 100.0;


/**
 *  自定义相册类， 用于存放从系统相册中获取的照片
 */
@interface MineOwnPhotoFirstController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView                   * collectView;
@property(nonatomic, strong) NSMutableArray<PhotoModel *>       * imageDatas;
@property(nonatomic, strong) NSMutableArray<NSIndexPath *>      * selectedPhotos;
@property(nonatomic, strong) UICollectionViewFlowLayout         * flowLayout;
@property(nonatomic, assign) NSInteger                          itemsPerLine;
@property(nonatomic, assign) BOOL                               isEditing;


@end

@implementation MineOwnPhotoFirstController

#pragma Mark -- 懒加载
- (NSMutableArray<PhotoModel *> *)imageDatas
{
    if (!_imageDatas) {
        _imageDatas = @[].mutableCopy;
    }
    return _imageDatas;
}

- (NSMutableArray<NSIndexPath *> *)selectedPhotos
{
    if (!_selectedPhotos) {
        _selectedPhotos = @[].mutableCopy;
    }
    return _selectedPhotos;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        /** 此处配置layout的属性
         ...
         ...
         **/
    }
    return _flowLayout;
}


- (UICollectionView *)collectView
{
    if (!_collectView)
    {
        _collectView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:self.flowLayout];
        [_collectView registerClass:[AbbrevPhotoCell class] forCellWithReuseIdentifier:kCollectCellIdentifier];
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.dataSource = self;
        _collectView.delegate   = self;
    }
    return _collectView;
}

- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
//    检查编辑状态， 修改editItem的plain
    UIBarButtonItem * editItem = self.navigationItem.rightBarButtonItem;
    
    editItem.title = _isEditing?@"导出":@"编辑";
}


#pragma  Mark -- 布局工作
- (void) initialData
{
    self.itemsPerLine = itemPerLine;
    _fromSystem   = true;
    _isEditing = false;
}

- (void) initialUI
{
    [self.view addSubview:self.collectView];
//    配置navigationbar
    UIBarButtonItem * editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editPhotos:)];
    self.navigationItem.rightBarButtonItem = editItem;
}

- (void) editPhotos:(UIBarButtonItem *) sender
{
    self.isEditing = !_isEditing;
    if (!_isEditing) //如果点击了导出按钮， 需要清空已选
    {
        [self.selectedPhotos enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop)
        {
            AbbrevPhotoCell * cell = (AbbrevPhotoCell *)[self.collectView cellForItemAtIndexPath:indexPath];
            cell.isSelected = !cell.isSelected;
            
        }];
        /** 在这里做导出操作 **/
        [self.selectedPhotos removeAllObjects];
    }
    
}

- (void) initialEvent
{
    [self addObserver:self forKeyPath:@"itemsPerLine" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"group" options:NSKeyValueObservingOptionNew context:nil];
    
    //添加手势
    UISwipeGestureRecognizer * swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeItemsPerLine:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer * swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeItemsPerLine:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.collectView addGestureRecognizer:swipeUp];
    [self.collectView addGestureRecognizer:swipeDown];
    
}

- (void)changeItemsPerLine:(UISwipeGestureRecognizer *) sender
{
//    左滑动增加单行显示的图片个数，右滑减少单行的图片个数
//    单行最多显示6个， 最少显示1个
    NSLog(@"Taflasdjf");
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            (self.itemsPerLine + 1) > 6 ? 6:self.itemsPerLine++;
            break;
        case UISwipeGestureRecognizerDirectionRight:
            (self.itemsPerLine - 1) < 1 ? 1:self.itemsPerLine--;
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
    [self initialEvent];
//    设置初始数据, 必须在初始了事件之后才有观察效果
    [self initialData];
    
    
    [_group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result)
        {
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
            {
                PhotoModel * model = [PhotoModel new];
                model.photo = result;
                model.isSelected = false;
                [self.imageDatas addObject:model];
            }
        }
        else
        {
            //遍历相片或视频完毕， 可以展示资源
            NSLog(@"%ld", self.imageDatas.count);
            [self.collectView reloadData];
            
        }
        
    }];

    // Do any additional setup after loading the view.
}




#pragma Mark -- CollectionView Delegate && DataSource


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return self.imageDatas.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AbbrevPhotoCell * cell = (AbbrevPhotoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCollectCellIdentifier forIndexPath:indexPath];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(AbbrevPhotoCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    设置cellmodel
    [cell setModel:self.imageDatas[indexPath.row]];
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(itemSizeWidth , itemSizeWidth);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return insetEdge;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return insetEdge;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    判断当前的状态是否是编辑状态
    if (_isEditing) //可以进行多选
    {
        PhotoModel * model = self.imageDatas[indexPath.row];
        model.isSelected = !model.isSelected;
        AbbrevPhotoCell * cell = (AbbrevPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.isSelected = model.isSelected;
        if (model.isSelected) {
            //添加到已选数组中
            [self.selectedPhotos addObject:indexPath];
        }
    }
    else // 查看完整图片
    {
        BrowsePhotoController * broVc = [[BrowsePhotoController alloc] init];
        broVc.group = _group;
        broVc.currentIndex = indexPath.row;
        [self.navigationController pushViewController:broVc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Mark  -- Event handle, 事件处理
/** 监听自己的itemsPerline属性， 动态确定每行显示的图片个数 **/
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"itemsPerLine"]) {
        //如果每行显示item个数发生变化， 更新
        //计算每个Item的大小
        CGSize containerSize = self.collectView.frame.size;
        itemSizeWidth        = (containerSize.width - (itemPerLine-1)*insetEdge) / (1.0 *[change[@"new"] integerValue]);
        //刷新视图
        [self.collectView reloadData];
    }
    else
    {
//        解析group中的值
        //获取相册中的资源
        [self.imageDatas removeAllObjects];
        [_group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result)
                {
                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
                    {
                        PhotoModel * model = [PhotoModel new];
                        model.photo = result;
                        model.isSelected = false;
                        [self.imageDatas addObject:model];
                    }
                }
                else
                {
                    //遍历相片或视频完毕， 可以展示资源
                    [self.collectView reloadData];
                    
                }
                
        }];
    }

}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"itemsPerLine"];
    [self removeObserver:self forKeyPath:@"group"];
}

@end
