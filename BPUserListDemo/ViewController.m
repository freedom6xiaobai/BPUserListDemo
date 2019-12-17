//
//  ViewController.m
//  BPUserListDemo
//
//  Created by baipeng on 2019/12/12.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

#import "ViewController.h"
#import "HGHomeUserHeaderView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.


	HGHomeUserHeaderView *userHeaderView = [[HGHomeUserHeaderView alloc]initWithFrame:CGRectMake(22, UIScreen.mainScreen.bounds.size.height-49-200-149, 50, 200)];
	[self.view addSubview:userHeaderView];

}


@end
