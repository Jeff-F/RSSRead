//
//  SMMoreViewController.m
//  RSSRead
//
//  Created by ming on 14-3-4.
//  Copyright (c) 2014年 starming. All rights reserved.
//

#import "SMMoreViewController.h"
#import "SMUIKitHelper.h"
#import "SMMoreCell.h"
#import "SMRSSListViewController.h"
#import "SMAboutViewController.h"
#import "SMBlurBackground.h"
#import "MSDynamicsDrawerViewController.h"
#import "SMViewController.h"

@interface SMMoreViewController ()

@property(nonatomic,strong)NSArray *optionArr;

@property (nonatomic, strong) NSDictionary *paneViewControllerClasses;
@property (nonatomic, strong) NSDictionary *paneViewControllerTitles;

@property (nonatomic, strong) NSDictionary *sectionTitles;
@property (nonatomic, strong) NSArray *tableViewSectionBreaks;

@property (nonatomic, strong) UIBarButtonItem *paneStateBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *paneRevealLeftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *paneRevealRightBarButtonItem;

@end

@implementation SMMoreViewController

-(void)doBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadView {
    [super loadView];
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(doBack)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view]addGestureRecognizer:recognizer];
    recognizer = nil;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [SMUIKitHelper colorWithHexString:COLOR_BACKGROUND];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.view addSubview:[SMBlurBackground QBluerView]];
    _optionArr = @[
                   @{
                       @"cn": @"首页",
                       @"en":@"home"
                       },
                   @{
                       @"cn": @"添加新订阅",
                       @"en":@"addRSS"
                       },
                   @{
                       @"cn":@"收藏",
                       @"en":@"fav"
                       },
                   @{
                       @"cn": @"关于",
                       @"en":@"about"
                       },
                   
                   ];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_optionArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SMMoreCell heightForOption];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SMMoreCell";
    SMMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SMMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [SMUIKitHelper colorWithHexString:@"#f2f2f2"];
    }
    if (_optionArr.count > 0) {
        NSDictionary *aOption = _optionArr[indexPath.row];
        [cell setOption:aOption];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *aOption = _optionArr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([aOption[@"en"]isEqualToString:@"home"]) {
        //首页
        [self transitionToViewController:HomeViewController];
        return;
    }
    
    if ([aOption[@"en"]isEqualToString:@"addRSS"]) {
        //添加rss
        [self transitionToViewController:AddRSSViewController];
        return;
    }
    
    if ([aOption[@"en"]isEqualToString:@"fav"]) {
        //收藏的
        [self transitionToViewController:FavoriteListController];
        return;
    }
    
    if ([aOption[@"en"]isEqualToString:@"about"]) {
        //关于
        [self transitionToViewController:AboutViewController];
        return;
    }
    
    if ([aOption[@"en"]isEqualToString:@"setting"]) {
        //设置
        
    }
}

#pragma mark addsubscribesdelegate
-(void)addedRSS:(Subscribes *)subscribe {
    NSLog(@"add subscribe1111111");
    //[_smMoreViewControllerDelegate addSubscribeToMainViewController:subscribe];
    [self transitionToViewController:HomeViewController];
}

#pragma mark - MSDynamicDrawerController
- (void)transitionToViewController:(MSPaneViewControllerType)paneViewControllerType
{
    // Close pane if already displaying the pane view controller
    if (paneViewControllerType == self.paneViewControllerType) {
        [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:YES completion:nil];
        return;
    }
    
    BOOL animateTransition = self.dynamicsDrawerViewController.paneViewController != nil;
    
    UIViewController *paneViewController;
    
    switch (paneViewControllerType) {
        case HomeViewController:
            paneViewController = [SMViewController new];
            break;
            
        case AddRSSViewController:{
            SMAddRSSViewController *controller = [SMAddRSSViewController new];
            controller.smAddRSSViewControllerDelegate = self;
            paneViewController = controller;
            self.paneRevealLeftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Left Reveal Icon"] style:UIBarButtonItemStyleBordered target:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:)];
            paneViewController.navigationItem.leftBarButtonItem = self.paneRevealLeftBarButtonItem;
            break;
        }
        
        case FavoriteListController:{
            SMRSSListViewController *rsslistVC = [[SMRSSListViewController alloc]initWithNibName:nil bundle:nil];
            rsslistVC.isFav = YES;
            rsslistVC.isNewVC = YES;
            paneViewController = rsslistVC;
            self.paneRevealLeftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Left Reveal Icon"] style:UIBarButtonItemStyleBordered target:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:)];
            paneViewController.navigationItem.leftBarButtonItem = self.paneRevealLeftBarButtonItem;
            break;
        }
            
        case AboutViewController:
            paneViewController = [SMAboutViewController new];
            self.paneRevealLeftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Left Reveal Icon"] style:UIBarButtonItemStyleBordered target:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:)];
            paneViewController.navigationItem.leftBarButtonItem = self.paneRevealLeftBarButtonItem;
            break;
            
        default:
            break;
    }
    
    UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
    [self.dynamicsDrawerViewController setPaneViewController:paneNavigationViewController animated:animateTransition completion:nil];
    
    self.paneViewControllerType = paneViewControllerType;
}

- (void)dynamicsDrawerRevealLeftBarButtonItemTapped:(id)sender
{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:nil];
}


@end
