//
//  GTPhotoBrowser.m
//  GTPhotoPicker
//
//  Created by gut on 16/5/23.
//  Copyright © 2016年 gt. All rights reserved.
//

#define kScrollViewHeight  (kAlbumPickerScreenH - 60 - 40)

#import "GTPhotoBrowser.h"
#import "GTPhotoPicker.h"
#import "GTGetAlbumPhotos.h"

@interface GTPhotoBrowser ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)GTGetAlbumPhotos *manager;
@property (nonatomic,assign)NSInteger selectedIndex;

@end

@implementation GTPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.manager = [GTGetAlbumPhotos new];
    _selectedIndex = 1;
    
    [self setupNavBgView];
    [self setupScrollViewWithImageArray:_selectedImageArray];
}

#pragma mark - baseSet

- (void)setupNavBgView{
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAlbumPickerScreenW, 60)];
    _bgView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_bgView];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(0, 20, 60, 40);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = kAlbumPickerFontWithFloat(16);
    [cancleButton setTitleColor:kAlbumPickerMainColor forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:cancleButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, kAlbumPickerScreenW - 80*2, 40)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)_selectedImageArray.count];
    _titleLabel.font = kAlbumPickerFontWithFloat(16);
    [_bgView addSubview:_titleLabel];
}

- (void)cancleClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupScrollViewWithImageArray:(NSArray<PHAsset *> *)imageArray{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, kAlbumPickerScreenW,kScrollViewHeight)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    [imageArray enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 根据比例算出imageView宽高比例
        __block float imageViewHeight = 0;
        
        // 创建
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:imgView];
        
        // 添加手势
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTouchAction:)];
        [imgView addGestureRecognizer:tapGesture];
        
        // 基本信息设置
        [self.manager getImageObject:obj complection:^(UIImage *imageItem, BOOL isDegraded) {
            
            imageViewHeight = (imageItem.size.height / imageItem.size.width) * kAlbumPickerScreenW;
            imgView.image = imageItem;
            imgView.frame = CGRectMake(kAlbumPickerScreenW * idx, (kScrollViewHeight - imageViewHeight)/2, kAlbumPickerScreenW, imageViewHeight);
        }];
        
    }];
    
    
    _scrollView.contentSize = CGSizeMake(kAlbumPickerScreenW*(imageArray.count), kScrollViewHeight);
}

- (void)imageViewTouchAction:(id)sender{
    [self navgationBarShowAndHiddenAnimation];
}

- (void)navgationBarShowAndHiddenAnimation{
    
    NSInteger offsetY = _bgView.frame.origin.y == 0 ? -64:0;
    
    [UIView animateWithDuration:0.5 animations:^{
        _bgView.frame = CGRectMake(_bgView.frame.origin.x,
                                   offsetY,
                                   _bgView.frame.size.width,
                                   _bgView.frame.size.height);
    }];
    
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _selectedIndex = (_scrollView.contentOffset.x)/kAlbumPickerScreenW;
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)_selectedIndex+1,(unsigned long)_selectedImageArray.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
