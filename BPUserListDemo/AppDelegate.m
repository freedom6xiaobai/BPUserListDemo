//
//  AppDelegate.m
//  BPUserListDemo
//
//  Created by baipeng on 2019/12/12.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
		// Override point for customization after application launch.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
	if (@available(iOS 11.0, *)){
		[UITableView appearance].estimatedRowHeight = 0;
		[UITableView appearance].estimatedSectionHeaderHeight = 0;
		[UITableView appearance].estimatedSectionFooterHeight = 0;
		[UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
#else
#endif


  

	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

	//*******************网络***********************************************************************************
	//捕获未知异常
void UncaughtExceptionHandler(NSException *exception) {
	/**
	 *  获取异常崩溃信息
	 */
	NSArray *callStack = [exception callStackSymbols];
	NSString *reason = [exception reason];
	NSString *name = [exception name];
	NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
	NSLog(@"异常错误报告 : \n%@", content);

}

	//*******************私有方法***********************************************************************************





@end

