//
//  HGHomeUserHeaderView.m
//  HGSmallSpace
//
//  Created by baipeng on 2019/12/10.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

#import "HGHomeUserHeaderView.h"
#import "HGUserInfoItemModel.h"
#import <UIImageView+WebCache.h>
#import "UIView+Extension.h"
#import <AFNetworking/AFNetworking.h>

@interface HGHomeUserHeaderView ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)HGHeaderTempView *tempView;//底部临时view，为网络请求占位
@property (nonatomic, strong) NSMutableArray *dataArray;//分页数据源
@property (nonatomic, assign) NSUInteger currentpage;//分页
@property (nonatomic, assign) BOOL isNext;//是否有下一页

@property (nonatomic, strong) NSMutableArray *imageArray;//控件数组

@property (nonatomic,strong)NSTimer *timer;//计时器
@property (nonatomic, assign) NSInteger firstIndex;//顶部坐标
@property (nonatomic, assign) NSInteger lastIndex;//底部坐标
@end

@implementation HGHomeUserHeaderView

#pragma mark - life cyle 1、视图生命周期
- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = UIColor.blackColor;
		self.clipsToBounds = YES;
		[self addSubview:self.scrollView];
		[self addSubview:self.tempView];
		self.tempView.hidden = YES;
        [self loadDataWithPage:1];

	}
	return self;
}
#pragma mark - 2、不同业务处理之间的方法以


#pragma mark - Network 3、网络请求
- (void)loadDataWithPage:(NSUInteger)page{
	AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
	sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
	sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
	sessionManager.requestSerializer.timeoutInterval = 30;

	sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/plain", @"text/html", nil];
	[sessionManager GET:@"http://localhost/Temp/test.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		self.isNext = [responseObject[@"data"][@"next"] boolValue];
		NSArray *list = responseObject[@"data"][@"list"];
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *dic in list){
			HGUserInfoItemModel *model = [[HGUserInfoItemModel alloc]initWithJson:dic];
			[array addObject:model];
		}
		NSLog(@"----------------网络请求%d----------------",array.count);
		if (array.count < 4) {
			if (array.count < 3) {
				for (int i = 0; i < 3; i++) {
					[array addObject:array.firstObject];
				}
			}else if (array.count == 2){
				[array addObjectsFromArray:array];
			}else if (array.count == 3){
				[array addObject:array.firstObject];
			}
		}
		[self.dataArray setArray:array];
		self.currentpage = page;
		[self checkImages];

	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"%@",error);
	}];

}

//200+count*50+200 整体空间
-(void)checkImages{
	[self.imageArray removeAllObjects];
	for (int i = 0; i < self.dataArray.count; i++) {
		UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(5,200+i*50, 40, 40)];
		imgv.tag = 1000+i;
		imgv.userInteractionEnabled = YES;
		imgv.layer.cornerRadius = 20;
		imgv.layer.masksToBounds = YES;
		imgv.layer.borderColor = UIColor.redColor.CGColor;
		imgv.layer.borderWidth = 1;
		imgv.backgroundColor = UIColor.clearColor;
		[self.scrollView addSubview:imgv];
		[self.imageArray addObject:imgv];

		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
		[imgv addGestureRecognizer:tap];

		HGUserInfoItemModel *model = [self.dataArray objectAtIndex:i];
		[imgv sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
	}
	if (self.imageArray.count) {
		[self startAnimation];
	}
}

#pragma mark - Action Event 4、响应事件
//开始动画
- (void)startAnimation{
	self.firstIndex = 0;
	self.lastIndex = 0;
	UIImageView *imgV = self.imageArray.firstObject;
	imgV.alpha = 0;
  	self.scrollView.hidden = NO;
	self.scrollView.contentSize = CGSizeMake(50, 200+50*self.imageArray.count+200);
	self.scrollView.contentOffset = CGPointMake(0, 25);
	[self.scrollView layoutIfNeeded];

	if (!self.timer) {
		self.timer = [NSTimer timerWithTimeInterval:1.2 target:self selector:@selector(autoInterval) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
	}

}
//计时器，1.2s一格，2.4动画，0.6s第二个开始, 1.5缩放，0.8s显隐
-(void)autoInterval{
	//底部缩放
	if (self.lastIndex < self.imageArray.count) {
		UIImageView *imgV = self.imageArray[self.lastIndex];
		imgV.alpha = 0;
		imgV.transform = CGAffineTransformScale(imgV.transform, 0.1f, 0.1f);
		[UIView animateWithDuration:1.6 animations:^{
			imgV.alpha = 1;
			imgV.transform = CGAffineTransformScale(imgV.transform, 10.0f, 10.0f);
		}completion:nil];
	}
	if (self.tempView.hidden == NO) {//1.85
		if (self.lastIndex >= 3) {
			self.tempView.hidden = YES;
		}
		[self.tempView tempStartAnimation];
	}
	self.lastIndex++;

	//列表动画
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:2.4];
	CGFloat offSetY = self.scrollView.contentOffset.y;
	self.scrollView.contentOffset = CGPointMake(0, offSetY+50);
	[self.scrollView layoutIfNeeded];
	[UIView commitAnimations];
}

//点击头像事件
-(void)tapAction:(UITapGestureRecognizer *)tap{
	NSUInteger index = tap.view.tag-1000;
	HGUserInfoItemModel *model = [self.dataArray objectAtIndex:index];
	NSLog(@"%@",model.avatar);
}
#pragma mark - Call back 5、回调事件

#pragma mark - Delegate 6、代理、数据源


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	CGFloat offSetY = scrollView.contentOffset.y;
	NSInteger index = offSetY/50;

	self.firstIndex = index;
//	NSLog(@"自动滚动位置：%f  %d",offSetY,index);

	//顶部显隐
	if (self.firstIndex-4 < self.imageArray.count &&
		self.firstIndex >= 4 &&
		offSetY >= 225) {
//		NSLog(@"---------------------显隐动画：%d  %f",self.firstIndex-4,offSetY);

		UIImageView *imgV = self.imageArray[self.firstIndex-4];
		imgV.alpha = 1;
		[UIView animateWithDuration:0.8 animations:^{
			imgV.alpha = 0;
		}completion:nil];
		self.firstIndex++;
	}

	//请求分页数据
	if (self.lastIndex >= self.imageArray.count) {//1.85
		NSLog(@"---121312321321=====");
		if (self.timer) {
			[self.timer invalidate];
			self.timer = nil;
		}
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			NSMutableArray *array = [NSMutableArray array];
			[array addObjectsFromArray:[self.dataArray subarrayWithRange:NSMakeRange(self.dataArray.count-3,3)]];
			self.tempView.listArray = array;
			if (self.isNext) {
				[self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
				[self loadDataWithPage:++self.currentpage];
			}else{
				[self startAnimation];
			}
			self.tempView.hidden = NO;
		});
 	}
}


#pragma mark - interface 7、UI处理


#pragma mark - lazy loading 8、懒加载
-(UIScrollView *)scrollView{
	if (!_scrollView) {
		_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 50, 200)];
		_scrollView.delegate = self;
 		_scrollView.backgroundColor = UIColor.clearColor;
	}
	return _scrollView;
}
-(HGHeaderTempView *)tempView{
	if (!_tempView) {
		_tempView = [[HGHeaderTempView alloc]initWithFrame:CGRectMake(0, 0, 50, 200)];
	}
	return _tempView;
}

-(NSMutableArray *)dataArray{
	if (!_dataArray) {
		_dataArray = [NSMutableArray array];
	}
	return _dataArray;
}

-(NSMutableArray *)imageArray{
	if (!_imageArray) {
		_imageArray = [NSMutableArray array];
	}
	return _imageArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



@interface HGHeaderTempView ()<UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger tempFirstIndex;//顶部坐标
@property (nonatomic, strong) NSMutableArray *imagesList;//最后三个控件数组

@property (nonatomic,assign)BOOL again;
@end

@implementation HGHeaderTempView

#pragma mark - life cyle 1、视图生命周期
- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.delegate = self;

	}
	return self;
}
#pragma mark - 2、不同业务处理之间的方法以

#pragma mark - Network 3、网络请求
//count*50 整体空间
-(void)setListArray:(NSArray *)listArray{
	_listArray = listArray;
	[self.imagesList removeAllObjects];
	for (int i = 0; i < self.listArray.count; i++) {
		UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(5,25+i*50, 40, 40)];
		imgv.tag = 2000+i;
		imgv.userInteractionEnabled = YES;
		imgv.layer.cornerRadius = 20;
		imgv.layer.masksToBounds = YES;
		imgv.layer.borderColor = UIColor.redColor.CGColor;
		imgv.layer.borderWidth = 1;
		imgv.backgroundColor = UIColor.clearColor;
		[self addSubview:imgv];
		[self.imagesList addObject:imgv];

		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
		[imgv addGestureRecognizer:tap];

		HGUserInfoItemModel *model = [listArray objectAtIndex:i];
		[imgv sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
	}

	self.again = YES;
	self.tempFirstIndex = 0;
	self.contentSize = CGSizeMake(50, 50*self.imagesList.count+200);
	self.contentOffset = CGPointMake(0, 0);
	[self layoutIfNeeded];
	self.again = NO;

}

#pragma mark - Action Event 4、响应事件
//开始动画
- (void)tempStartAnimation{
	//列表动画
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:2.4];
	CGFloat offSetY = self.contentOffset.y;
	self.contentOffset = CGPointMake(0, offSetY+50);
	[self layoutIfNeeded];
	[UIView commitAnimations];

}

//点击头像事件
-(void)tapAction:(UITapGestureRecognizer *)tap{
	NSUInteger index = tap.view.tag-2000;
	HGUserInfoItemModel *model = [self.listArray objectAtIndex:index];
	NSLog(@"%@",model.avatar);
}
#pragma mark - Call back 5、回调事件

#pragma mark - Delegate 6、代理、数据源
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (self.again) {
		return;
	}
	//顶部显隐
	if (self.tempFirstIndex < self.imagesList.count && self.tempFirstIndex >= 0) {
		NSLog(@"---显隐动画：%d  %f",self.tempFirstIndex,scrollView.contentOffset.y);
		UIImageView *imgV = self.imagesList[self.tempFirstIndex];
		imgV.alpha = 1;
		[UIView animateWithDuration:0.8 animations:^{
			imgV.alpha = 0;
		}completion:nil];
		self.tempFirstIndex++;
	}

}

#pragma mark - interface 7、UI处理

#pragma mark - lazy loading 8、懒加载
-(NSMutableArray *)imagesList{
	if (!_imagesList) {
		_imagesList = [NSMutableArray array];
	}
	return _imagesList;
}

@end
