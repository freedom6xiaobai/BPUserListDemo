//
//  HGUserInfoItemModel.h
//  BPUserListDemo
//
//  Created by baipeng on 2019/12/12.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGUserInfoItemModel : NSObject
@property (nonatomic,copy)NSString *avatar;
-(instancetype)initWithJson:(NSDictionary *)json;
@end

NS_ASSUME_NONNULL_END
