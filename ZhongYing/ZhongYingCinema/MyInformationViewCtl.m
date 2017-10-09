//
//  MyInformationViewCtl.m
//  ZhongYingCinema
//
//  Created by 小菜皮 on 2016/11/18.
//  Copyright © 2016年 小菜皮. All rights reserved.
//

#import "MyInformationViewCtl.h"
#import "LFSPopupView.h"
#import "ProcotolViewController.h"

@interface MyInformationViewCtl ()<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIView *_whiteView;
    UIScrollView *_scrollView;
    UIImageView *_myInformationHeadImg;
    UITextField *_userNameTextField;
    UITextField *_phoneTextField;
    UITextField *_nameTextField;
    // 年龄、性别
    UILabel *_yearLb;
    UILabel *_sexLb;
    UIImageView *_sexImg;
    MBProgressHUD *_HUD;
    NSInteger _yearIndex;
    NSInteger _sexIndex;
    
    
}
//用户名
@property (nonatomic, strong) NSString *nickName;
//手机号
@property (nonatomic, strong) NSString *phoneString;
//姓名
@property (nonatomic, strong) NSString *userName;
//年龄
@property (nonatomic, strong) NSString *ageStr;
//性别
@property (nonatomic, strong) NSString *sexStr;

//是否修改了资料
@property (nonatomic, assign,getter=isReviseInfo) BOOL reviseInfo;
@end

@implementation MyInformationViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的资料";
    self.reviseInfo = NO;
    _scrollView = [UIViewController createScrollView];
    [self.view addSubview:_scrollView];
    
    _whiteView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 20, ScreenWidth, 330) backgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_whiteView];
    
    _yearIndex = [ApiAgeStr integerValue];
    _sexIndex = [ApiGenderStr integerValue];
    [self initMyInformationUI];
    // 键盘
    [self registerLJWKeyboardHandler];
}

#pragma mark - help Methods
- (void)initMyInformationUI{
    NSArray *leftArr = @[@"头像",@"昵称",@"手机号",@"姓名",@"年龄",@"性别"];
    for (int i=0; i<leftArr.count; i++) {
        UIView *sixView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 50) backgroundColor:[UIColor whiteColor]];
        [_whiteView addSubview:sixView];
        
        CGSize leftSize = [FanShuToolClass createString:leftArr[i] font:[UIFont systemFontOfSize:17] lineSpacing:0 maxSize:CGSizeMake(ScreenWidth/2, 50)];
        UILabel *leftLb = [FanShuToolClass createLabelWithFrame:CGRectMake(0, 0, leftSize.width, 50) text:leftArr[i] font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [sixView addSubview:leftLb];
        
        UIView *lineView = [FanShuToolClass createViewWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5f) backgroundColor:[UIColor lightGrayColor]];
        [_whiteView addSubview:lineView];
        
        if (i == 0) {
            sixView.frame = CGRectMake(0, 0, ScreenWidth, 80);
            leftLb.frame = CGRectMake(20, 15, leftSize.width, 50);
            lineView.frame = CGRectMake(0, 79.5, ScreenWidth, 0.5f);
            
            // 头像
            _myInformationHeadImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(ScreenWidth-84, 8, 64, 64) image:[UIImage imageNamed:@""] tag:1000];
            [_myInformationHeadImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_URL,ApiavatarStr]] placeholderImage:[UIImage imageNamed:@"my_head"]];
            [sixView addSubview:_myInformationHeadImg];
            sixView.tag = 1000;
            
            UITapGestureRecognizer *sixViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myInformationTapClick:)];
            [sixView addGestureRecognizer:sixViewTap];
        }else {
            sixView.frame = CGRectMake(0, 30+50*i, ScreenWidth, 50);
            leftLb.frame = CGRectMake(20, 0, leftSize.width, 50);
            lineView.frame = CGRectMake(0, 79.5+50*i, ScreenWidth, 0.5f);
            if (i == 1) {
                // 昵称：在没设置时默认显示手机号码
                _userNameTextField = [FanShuToolClass createTextFieldWithFrame:CGRectMake(20+leftSize.width, 0, ScreenWidth-40-leftSize.width, 50) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:17] target:self];
                _userNameTextField.backgroundColor = [UIColor whiteColor];
                _userNameTextField.textAlignment = NSTextAlignmentRight;
                _userNameTextField.text = ApiNickNameStr ? ApiNickNameStr : @"";
                [sixView addSubview:_userNameTextField];
            }else if (i == 2) {
                // 手机号
                _phoneTextField = [FanShuToolClass createTextFieldWithFrame:CGRectMake(20+leftSize.width, 0, ScreenWidth-40-leftSize.width, 50) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:17] target:self];
                _phoneTextField.backgroundColor = [UIColor whiteColor];
                _phoneTextField.textAlignment = NSTextAlignmentRight;
                _phoneTextField.userInteractionEnabled = NO;
                _phoneTextField.text = ApimobileStr;
                [sixView addSubview:_phoneTextField];
            }else if (i == 3) {
                // 姓名
                _nameTextField = [FanShuToolClass createTextFieldWithFrame:CGRectMake(20+leftSize.width, 0, ScreenWidth-40-leftSize.width, 50) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:17] target:self];
                _nameTextField.placeholder = @"必填";
                _nameTextField.backgroundColor = [UIColor whiteColor];
                _nameTextField.textAlignment = NSTextAlignmentRight;
                _nameTextField.text = ApiNameStr ? ApiNameStr : @"";
                [sixView addSubview:_nameTextField];
            }else if (i == 4) {
                // 年龄
                NSArray *years = @[@"未设置",@"20岁以下",@"20-30岁",@"31-40岁",@"40岁以上"];
                _yearLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-40, 50) text:years[_yearIndex] font:[UIFont systemFontOfSize:17] textColor:[UIColor grayColor] alignment:NSTextAlignmentRight];
                [sixView addSubview:_yearLb];
                
                UIImageView *rightImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(ScreenWidth-30, 16, 10, 18) image:[UIImage imageNamed:@"Login_arrow"] tag:1000];
                [sixView addSubview:rightImg];
                
                sixView.tag = 1001;
                UITapGestureRecognizer *sixViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myInformationTapClick:)];
                [sixView addGestureRecognizer:sixViewTap];
            }else {
                NSArray *sexs = @[@"无",@"男",@"女"];
                _sexLb = [FanShuToolClass createLabelWithFrame:CGRectMake(ScreenWidth-70, 0, 30, 50) text:sexs[_sexIndex] font:[UIFont systemFontOfSize:17] textColor:[UIColor grayColor] alignment:NSTextAlignmentRight];
                [sixView addSubview:_sexLb];
                
                if ([_sexLb.text isEqualToString:@"女"]) {
                    _sexImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(ScreenWidth-80, 14, 14, 22) image:[UIImage imageNamed:@"Login_sex_woman"] tag:1001];

                } else {
                    
                    _sexImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(ScreenWidth-80, 14, 14, 22) image:[UIImage imageNamed:@"Login_sex_man"] tag:1001];
                }
                [sixView addSubview:_sexImg];
                
                UIImageView *rightImg = [FanShuToolClass createImageViewWithFrame:CGRectMake(ScreenWidth-30, 16, 10, 18) image:[UIImage imageNamed:@"Login_arrow"] tag:1000];
                [sixView addSubview:rightImg];
                
                sixView.tag = 1002;
                UITapGestureRecognizer *sixViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myInformationTapClick:)];
                [sixView addGestureRecognizer:sixViewTap];
            }
        }
    }
    
    // 确认
    UIButton *sureBtn = [FanShuToolClass createButtonWithFrame:CGRectMake(15, ScreenHeight-180, ScreenWidth-30, 50) title:@"确认" titleColor:[UIColor whiteColor] target:self action:@selector(gotoMyInformationEvent:) tag:100];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    sureBtn.backgroundColor = COLOR_NAVAAR;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4.0f;
    [_scrollView addSubview:sureBtn];
}

- (void)keyBoardDown{
    [_userNameTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
}

- (void)uploadAvatar
{
    if (self.reviseInfo) {
        
    } else {
        return;
    }
    
    _HUD = [FanShuToolClass createMBProgressHUDWithText:@"修改中..." target:self];
    [self.view addSubview:_HUD];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserModifyAvatarURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    NSData *imageData = UIImageJPEGRepresentation(_myInformationHeadImg.image, 0.000000001);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect uploadZhongYingData:imageData fileName:fileName SuccessURL:url parameters:parameters result:^(id dataBack, NSString *currentPager) {
        if ([dataBack[@"code"] integerValue] == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:dataBack[@"content"][@"url"] forKey:@"Apiavatar"];// 头像
            [self showHudMessage:@"修改成功"];
        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_HUD hideAnimated:YES];
    } failure:^(NSError *error) {
        [self showHudMessage:@"连接服务器失败!"];
        [_HUD hideAnimated:YES];
    }];
}

- (void)uploadProfile
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ApiUserModifyProfileURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = ApiTokenStr;
    parameters[@"nickname"] = _userNameTextField.text;
    if (_nameTextField.text.length!=0) {
        parameters[@"name"] = _nameTextField.text;
    }
    if (_sexIndex == 1 || _sexIndex == 2) {
        
        parameters[@"gender"] = @(_sexIndex);
    }
    parameters[@"age"] = @(_yearIndex);
    ZhongYingConnect *connect = [ZhongYingConnect shareInstance];
    [connect getZhongYingDictSuccessURL:urlStr parameters:parameters result:^(id dataBack, NSString *currentPager) {
        
        if ([dataBack[@"code"] integerValue] == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:_nameTextField.text forKey:@"Apiname"];// 用户姓名
            [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"Apinickname"];// 用户昵称
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",_sexIndex] forKey:@"Apigender"];// 性别，枚举值，0-未设置|1-男|2-女
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",_yearIndex] forKey:@"Apiage"];// 年龄，枚举值，0-未设置|1-20岁以下|2-20-30岁|3-31-40岁|4-40岁以上
            if (self.reviseInfo) {
                
            } else {
                
                [self showHudMessage:@"修改成功"];
            }

        }else{
            [self showHudMessage:dataBack[@"message"]];
        }
        [_HUD hideAnimated:YES];
    } failure:^(NSError *error) {
        [_HUD hideAnimated:YES];
        [self showHudMessage:@"连接服务器失败!"];
    }];
}

#pragma mark - View Handles
- (void)myInformationTapClick:(UITapGestureRecognizer *)tap{
    [self keyBoardDown];
    if (tap.view.tag == 1000) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照" ,@"相册", nil];
        [actionSheet showInView:self.view];
    }else if (tap.view.tag == 1001) {
        // 展示年龄段
        NSArray *yearArr = @[@"20岁以下",@"20-30岁",@"31-40岁",@"40岁以上"];
        LFSPopupView *popupView = [[LFSPopupView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.view addSubview:popupView];
        
        [popupView createTableViewWithArr:yearArr withTitle:@"修改年龄段" withBackColor:Color(98, 98, 98, 0.6) withType:LFSPopup_year withLFSBlock:^(int tag) {
            _yearLb.text = yearArr[tag];
            _yearIndex = tag +1;
        }];
    }else {
        // 展示性别
        NSArray *sexArr = @[@"男",@"女"];
        LFSPopupView *popupView = [[LFSPopupView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.view addSubview:popupView];
        
        [popupView createTableViewWithArr:sexArr withTitle:@"修改性别" withBackColor:Color(98, 98, 98, 0.6) withType:LFSPopup_sex withLFSBlock:^(int tag) {
            _sexLb.text = sexArr[tag];
            NSArray *sexImgArr = @[@"Login_sex_man",@"Login_sex_woman"];
            _sexImg.image = [UIImage imageNamed:sexImgArr[tag]];
            _sexIndex = tag +1;
        }];
    }
}

- (void)gotoMyInformationEvent:(UIButton *)btn{
//    [self reviseInfoForUser];
    [self keyBoardDown];
    if (btn.tag == 100) {
        [self uploadAvatar];  //上传头像
        [self uploadProfile]; // 上传用户资料
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 访问照相机、访问相册
// 访问照相机
- (void)touch_photo{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate =self;
    // 自定义照片样式
    pickerImage.allowsEditing =YES;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

// 访问相册
- (void)touch_album{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    // 自定义照片样式
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self touch_photo];
    }else if(buttonIndex == 1){
        [self touch_album];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    _myInformationHeadImg.image = [info objectForKey: UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        self.reviseInfo = YES;
    }];
}

- (BOOL)reviseInfoForUser {
    BOOL reviseInfo = NO;
    
    if (self.nibName == _userNameTextField.text && self.phoneString == _phoneTextField.text && self.userName == _nameTextField.text && self.ageStr == _yearLb.text && self.sexStr == _sexLb.text) {
        reviseInfo = NO;
    } else {
        reviseInfo = YES;
    }
    self.reviseInfo = reviseInfo;
    return reviseInfo;
}

@end
