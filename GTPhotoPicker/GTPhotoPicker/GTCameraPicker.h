//
//  GTCameraPicker.h
//  GTPhotoPicker
//
//  Created by gt on 16/5/21.
//  Copyright © 2016年 gt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GTCameraPicker : NSObject

// 回调
+ (void)loadImageFromeViewController:(UIViewController *)viewController finishAction:(void(^)(UIImage *image))finishAction;

@end
