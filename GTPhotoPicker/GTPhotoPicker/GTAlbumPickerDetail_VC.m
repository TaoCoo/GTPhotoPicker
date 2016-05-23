//
//  GTAlbumPickerDetail_VC.m
//  GTPhotoPicker
//
//  Created by gt on 16/5/22.
//  Copyright © 2016年 gt. All rights reserved.
//



#import "GTAlbumPickerDetail_VC.h"
#import "GTPhotoPicker.h"
#import "GTGetAlbumPhotos.h"
#import "GTAlbumPickerCollectionViewCell.h"
#import "GTPhotoBrowser.h"

@interface GTAlbumPickerDetail_VC ()<UICollectionViewDelegate,UICollectionViewDataSource>

// 里面的元素是 PHAsset
@property (nonatomic,strong) NSArray *photosArray;
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,strong) GTGetAlbumPhotos *manager;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *navBgView;
@property (nonatomic,strong) UIView *bottomBgView;
//预览按钮
@property (nonatomic,strong) UIButton *previewButton;
//完成按钮
@property (nonatomic,strong) UIButton *completionButton;
@end

@implementation GTAlbumPickerDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
    
    [self setupUI];
}

-(NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

#pragma mark - baseSet

- (void)getData{
    
    _manager = [GTGetAlbumPhotos new];
    self.photosArray = [_manager getAlbumPhotos];
   // NSLog(@"-----photos=%@----%lu--",self.photosArray,(unsigned long)self.photosArray.count);
}

- (void)setupUI{
    
    [self setupNavigationControllerAndBottomTwoButton];
    
    [self setupCollectionView];
}

- (void)setupNavigationControllerAndBottomTwoButton{
    
    for (int i = 0; i<2; i++) {
        
        UIView *view = [UIView new];
        [self.view addSubview:view];
        if (i == 0) {
            _navBgView = view;
            _navBgView.backgroundColor = kAlbumPickerRGBA(224, 53, 56, 1);
            _navBgView.frame = CGRectMake(0, 0, kAlbumPickerScreenW, 60);
        }else if (i == 1){
            _bottomBgView = view;
            _bottomBgView.backgroundColor = [UIColor whiteColor];
            _bottomBgView.frame = CGRectMake(0, kAlbumPickerScreenH - 40, kAlbumPickerScreenW, 40);
        }
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, kAlbumPickerScreenW - 80*2, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kAlbumPickerMainColor;
    label.font = kAlbumPickerFontWithFloat(16);
    label.text = @"相册";
    [_navBgView addSubview:label];

    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(kAlbumPickerScreenW - 60, 20, 60, 40);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = kAlbumPickerFontWithFloat(16);
    [cancleButton setTitleColor:kAlbumPickerMainColor forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    [_navBgView addSubview:cancleButton];
    
    
    for (int i = 0; i<2; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * (kAlbumPickerScreenW - 60), 0, 60, 40);
        [button setTitle:@[@"预览",@"完成"][i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = kAlbumPickerFontWithFloat(16);
        button.tag = i;
        button.enabled = NO;
        [button addTarget:self action:@selector(buttomTwoClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBgView addSubview:button];
        
        if (i == 0) {
            _previewButton = button;
        }else if(i == 1){
            _completionButton = button;
        }
    }
}

- (void)setupCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat photoSize = (kAlbumPickerScreenW - 3) / 4;
    flowLayout.minimumInteritemSpacing = 1.0;
    flowLayout.minimumLineSpacing = 1.0;
    flowLayout.itemSize = (CGSize){photoSize,photoSize};
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, kAlbumPickerScreenW, kAlbumPickerScreenH - 100) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[GTAlbumPickerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([GTAlbumPickerCollectionViewCell class])];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
}

#pragma mark - button

- (void)cancleClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttomTwoClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 0) {
        // 预览
        
        GTPhotoBrowser *photoBrowser = [GTPhotoBrowser new];
        photoBrowser.selectedImageArray = _selectArray;
        [self presentViewController:photoBrowser animated:YES completion:nil];
        
    }else if (button.tag == 1){
        // 完成
        if (_selectArray.count == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
             self.result(nil);
        }else{
            NSMutableArray *photos = [NSMutableArray array];
            [_selectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_manager getImageObject:obj complection:^(UIImage *image, BOOL isDegraded) {
                    if (image) {
                        [photos addObject:image];
                    }
                }];
            }];
            //回调
            self.result(photos);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        //NSLog(@"-----selectArray=%@----",_selectArray);
    }
}

-(void)selectPhotoButtonClick:(UIButton *)button{
    NSInteger index = button.tag;
    if (button.selected == NO) {
        [self shakeToShow:button];
        if (self.selectArray.count + 1 > _pickNumber) {
            [self showSelectPhotoAlertView:_pickNumber];
        }else{
            [self.selectArray addObject:[self.photosArray objectAtIndex:index]];
            [button setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateNormal];
            button.selected = YES;
        }
    }else{
        [self shakeToShow:button];
        [self.selectArray removeObject:[self.photosArray objectAtIndex:index]];
        [button setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        button.selected = NO;
    }
    
    if (_selectArray.count == 0) {
        _previewButton.enabled = NO;
        _completionButton.enabled = NO;
        [_previewButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_completionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else{
        _previewButton.enabled = YES;
        _completionButton.enabled = YES;
        [_previewButton setTitleColor:kAlbumPickerMainColor forState:UIControlStateNormal];
        [_completionButton setTitleColor:kAlbumPickerMainColor forState:UIControlStateNormal];
    }
}

#pragma mark 列表中按钮点击动画效果

- (void) shakeToShow:(UIButton*)button{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
}


#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photosArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GTAlbumPickerCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GTAlbumPickerCollectionViewCell class]) forIndexPath:indexPath];
    
    
    photoCell.selectButton.tag = indexPath.row;
    [photoCell.selectButton addTarget:self action:@selector(selectPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [photoCell loadPhotoData:[self.photosArray objectAtIndex:indexPath.row]];
    [photoCell selectButtonStage:self.selectArray existence:[self.photosArray objectAtIndex:indexPath.row]];
    
    return photoCell;
}

#pragma UICollectionView --- Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"------row=%ld------",(long)indexPath.row);
     // 此功能未完成，待后期完善。
}

#pragma mark - private
-(void)showSelectPhotoAlertView:(NSInteger)photoNumOfMax{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:@"最多只能选择%ld张图片",(long)photoNumOfMax]preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
