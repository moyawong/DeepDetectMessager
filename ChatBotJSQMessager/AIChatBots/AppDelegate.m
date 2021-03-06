//
//  AppDelegate.m
//  AIChatBots
//
//  Created by yangboz on 2016/12/26.
//  Copyright © 2016年 ___SMARTKIT.INFO___. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "AllChatBotsModel.h"
#import "DataModel.h"
#import "MasterViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>{
MasterViewController *masterViewController;
}
@end

@implementation AppDelegate

-(void)setMasterControllerData:(NSMutableArray *)data
{
    masterViewController.chatbots = data;
    NSLog(@"masterViewController.chatbots %@",data);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    //API json data initialization
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chatbots" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    AllChatBotsModel *allChatBotsModel = [[AllChatBotsModel alloc] initWithData:jsonData error:&error];
    // 4) Dump the contents of the person object
    // to thedebug console.
    NSLog(@"AllChatBotsVO => %@\n", allChatBotsModel);
    NSLog(@"AllChatBotsVO.chatbots: %@\n",[allChatBotsModel chatbots]);
    NSLog(@"AllChatBotsVO.chatbots[0]: %@\n", [[allChatBotsModel chatbots] objectAtIndex:0]);
    // 5) Model store
    [[DataModel sharedInstance] setAllChatBots:allChatBotsModel];
    
    // 6) Set delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithArray:
                              [allChatBotsModel chatbots] ];
    //
    [appDelegate setMasterControllerData:mArray];
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


#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
