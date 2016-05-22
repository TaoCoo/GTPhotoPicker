//
//  GTAlbumPickerCollectionViewCell.h
//  GTPhotoPicker
//
//  Created by gt on 16/5/22.
//  Copyright © 2016年 gt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface GTAlbumPickerCollectionViewCell : UICollectionViewCell

@property(strong,nonatomic) UIImageView *photoImage;
@property(strong,nonatomic) UIButton *selectButton;


-(void)loadPhotoData:(PHAsset *)assetItem;
-(void)selectButtonStage:(NSMutableArray *)selectArray existence:(PHAsset *)assetItem;

@end
