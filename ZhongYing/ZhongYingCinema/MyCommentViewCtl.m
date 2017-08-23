//
//  MyCommentViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 17/4/11.
//  Copyright © 2017年 小菜皮. All rights reserved.
//

#import "MyCommentViewCtl.h"
#import "YSLContainerViewController.h"
#import "MyCinemaCommentViewCtl.h"
#import "MyMovieCommentViewCtl.h"
#import "MyNewsCommentViewCtl.h"

@interface MyCommentViewCtl ()<YSLContainerViewControllerDelegate>
{
    NSInteger _index;
    UIButton *_button;
}
@property(nonatomic,strong) MyCinemaCommentViewCtl *myCinemaComment;
@property(nonatomic,strong) MyMovieCommentViewCtl *myMovieComment;
@property(nonatomic,strong) MyNewsCommentViewCtl *myNewsComment;

@end

@implementation MyCommentViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的评论";
    _index = 0;
    UIButton *rightBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(0, 0, 22, 20) image:[UIImage imageNamed:@"my_collection_delete"] target:self action:@selector(gotoMyCommentEvent:) tag:100];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    _button = rightBtn;
    
    [self setupMyCommentYSLContainer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Help Methods
- (void)setupMyCommentYSLContainer
{
    self.myCinemaComment = [[MyCinemaCommentViewCtl alloc] init];
    self.myCinemaComment.title = @"影院";
    
    self.myMovieComment = [[MyMovieCommentViewCtl alloc] init];
    self.myMovieComment.title = @"电影";
    
    self.myNewsComment = [[MyNewsCommentViewCtl alloc] init];
    self.myNewsComment.title = @"资讯";
    
    YSLContainerViewController *YSLContainer = [[YSLContainerViewController alloc] initWithControllers:@[self.myCinemaComment,self.myMovieComment,self.myNewsComment] topBarHeight:HEIGHT_STATUSBAR+HEIGHT_NAVBAR parentViewController:self];
    YSLContainer.delegate = self;
    YSLContainer.menuItemFont = [UIFont systemFontOfSize:16 * widthFloat];
    YSLContainer.contentScrollView.bounces = NO;
    [self.view addSubview:YSLContainer.view];
}

#pragma mark - YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    _button.selected = NO;
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    _index = index;
    if (_index == 0) {
        [self.myMovieComment hideEditView];
        [self.myNewsComment hideEditView];
    }else if (_index == 1){
        [self.myCinemaComment hideEditView];
        [self.myNewsComment hideEditView];
    }else{
        [self.myCinemaComment hideEditView];
        [self.myMovieComment hideEditView];
    }
    [controller viewWillAppear:YES];
}

#pragma mark - View Handle
- (void)gotoMyCommentEvent:(UIButton *)btn
{
    if (_index == 0) {
        [self.myCinemaComment gotoEdit:btn];
    }else if (_index == 1){
        [self.myMovieComment gotoEdit:btn];
    }else{
        [self.myNewsComment gotoEdit:btn];
    }
}

@end
