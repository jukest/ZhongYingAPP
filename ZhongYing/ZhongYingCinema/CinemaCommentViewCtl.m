//
//  CinemaCommentViewCtl.m
//  ZhongYingCinema
//
//  Created by dscvsd on 16/11/25.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "CinemaCommentViewCtl.h"
#import "TQStarRatingView.h"

@interface CinemaCommentViewCtl ()<StarRatingViewDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UILabel *_markLb;
    UITextView *_contentView;
    UILabel *_wordCount;
    UIButton *_commitBtn;
    UILabel *_placeHolder;
    NSString *_mark;
    MBProgressHUD *_HUD;
}
@end

@implementation CinemaCommentViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.name;
    
    _mark = @"10";
    [self initCinemaCommentUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Help Methods
- (void)initCinemaCommentUI
{
    _scrollView = [FanShuToolClass createScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) contentSize:CGSizeMake(ScreenWidth, ScreenHeight -63) target:self];
    [self.view addSubview:_scrollView];
    
    NSString *mark = @"10分";
    _markLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 25, 150, 40) text:mark font:[UIFont systemFontOfSize:60] textColor:Color(248, 66, 95, 1.0) alignment:NSTextAlignmentCenter];
    _markLb.center = CGPointMake(ScreenWidth / 2, 25 + 20);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:mark];
    NSRange range = [mark rangeOfString:@"分"];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
    _markLb.attributedText = string;
    [_scrollView addSubview:_markLb];
    
    TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0, 90, 210, 30) numberOfStar:5];
    starRatingView.center = CGPointMake(ScreenWidth / 2, 90 + 15);
    starRatingView.delegate = self;
    [_scrollView addSubview:starRatingView];
    
    _contentView = [[UITextView alloc] initWithFrame:CGRectMake(16, 90 + 35 + 25, (ScreenWidth - 32), 140)];
    _contentView.delegate = self;
    _contentView.layer.borderWidth = 1.0f;
    _contentView.layer.borderColor = Color(254, 230, 204, 1.0).CGColor;
    _contentView.font = [UIFont systemFontOfSize:18];
    _contentView.returnKeyType = UIReturnKeyDone;
    [_scrollView addSubview:_contentView];
    
    _placeHolder = [FanShuToolClass createLabelWithFrame:CGRectMake(12, 12, 200, 20) text:@"快来说说你的看法吧" font:[UIFont systemFontOfSize:18] textColor:Color(210, 210, 210, 1.0) alignment:NSTextAlignmentLeft];
    [_contentView addSubview:_placeHolder];
    
    _wordCount = [FanShuToolClass createLabelWithFrame:CGRectMake(_contentView.frame.size.width -10 -60, _contentView.frame.size.height -7 -15, 60, 15) text:@"0/100" font:[UIFont systemFontOfSize:16] textColor:Color(166, 166, 166, 1.0) alignment:NSTextAlignmentRight];
    [_contentView addSubview:_wordCount];
    
    _commitBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(12, ScreenHeight- 64 -110, ScreenWidth -24, 52) title:@"提交" titleColor:[UIColor whiteColor] target:self action:@selector(commitBtnDidClicked:) tag:1000];
    _commitBtn.backgroundColor = Color(252, 186, 0, 1.0);
    _commitBtn.layer.cornerRadius = 5.0;
    _commitBtn.layer.masksToBounds = YES;
    [_scrollView addSubview:_commitBtn];
}

#pragma mark - view handles
- (void)commitBtnDidClicked:(UIButton *)btn
{
    NSLog(@"提交%@",_contentView.text);
    if ([_contentView.text length] < 6) {
        [self showHudMessage:@"评论至少6个字！"];
    }else{
        _HUD = [FanShuToolClass createMBProgressHUDWithText:@"提交中..." target:self];
        [self.view addSubview:_HUD];
        NSString *urlStr;
        if ([self.type isEqualToString:@"影院评论"]) {
            urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserCinemaCommentURL];
        }else if([self.type isEqualToString:@"待评价评论"]){
            urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserMovieCommentURL];
        }else{
            urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserMakeCommentURL];
        }
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"token"] = ApiTokenStr;
        if ([self.type isEqualToString:@"影院评论"]) {
            parameters[@"cinema_id"] = @([self.id integerValue]);
        }else{
            parameters[@"movie_id"] = @([self.id integerValue]);
        }
        parameters[@"stars"] = [NSNumber numberWithFloat:[_mark floatValue]];
        parameters[@"content"] = _contentView.text;
        ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
        [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
            if ([dataBack[@"code"] integerValue] == 0) {
                [self showHudMessage:@"评论成功"];
                NSInteger count = [ApiMyCommentStr integerValue];
                if ([self.type isEqualToString:@"待评价评论"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",count -1] forKey:@"mycomment"];// 评论
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Evaluate" object:self.evaluate];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self.type isEqualToString:@"电影评论"]) {
                        MovieComment *comment = [[MovieComment alloc] init];
                        comment.nickname = ApiNickNameStr;
                        comment.avatar = ApiavatarStr;
                        comment.stars = _mark;
                        comment.content = _contentView.text;
                        comment.created_time = [NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]];
                        self.block(comment);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self showHudMessage:dataBack[@"message"]];
            }
            [_HUD hide:YES];
        } failure:^(NSError *error) {
            [self showHudMessage:@"连接服务器失败!"];
            [_HUD hide:YES];
        }];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if ([textView.text length] + [text length] > 100) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (![textView.text isEqualToString:@""]) {
        _placeHolder.hidden = YES;
    }else{
        _placeHolder.hidden = NO;
    }
    _wordCount.text = [NSString stringWithFormat:@"%zd/100",[textView.text length]];
}

#pragma mark - StarRatingViewDelegate
- (void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    NSString *mark = [NSString stringWithFormat:@"%.1f分",score * 10];
    _mark = [mark substringToIndex:mark.length -1];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:mark];
    NSRange range = [mark rangeOfString:@"分"];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
    _markLb.attributedText = string;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_contentView resignFirstResponder];
}

@end
