//
//  HGUserInfoItemModel.m
//  BPUserListDemo
//
//  Created by baipeng on 2019/12/12.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

#import "HGUserInfoItemModel.h"

@implementation HGUserInfoItemModel
-(instancetype)initWithJson:(NSDictionary *)json{

	if (self == [super init]) {
		self.avatar = json[@"avatar"]?:@"";
	}
	return self;

}
@end
