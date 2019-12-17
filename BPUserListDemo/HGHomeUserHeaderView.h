//
//  HGHomeUserHeaderView.h
//  HGSmallSpace
//
//  Created by baipeng on 2019/12/10.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HGHomeUserHeaderView : UIView
@end

@interface HGHeaderTempView : UIScrollView
@property (nonatomic,copy)dispatch_block_t didComBlock;//结束重新开始主视图动画
@property (nonatomic, strong) NSArray *listArray;//数据源数，整体数据源最后三个
- (void)tempStartAnimation;
@end
