//
//  InfoTableViewController.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/19.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "InfoTableViewController.h"
#import "EditView.h"

typedef NS_ENUM(NSUInteger, TextFeildName) {
    NickName = 2,
    Department,
    Position,
    Phone,
    Email
};


@interface InfoTableViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/** 账号 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

/**  部门 */
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;

/** 职位*/
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

/** 电话 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

/**  邮箱 */
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (nonatomic, strong) UIImagePickerController *pickerVc;
@end

@implementation InfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XMPPvCardTemp *myvCard = [BQXMPPTool sharedXMPPTool].vCard.myvCardTemp;
    NSLog(@"%p",myvCard);
    if (myvCard.photo != nil) {
        self.headImageView.image = [UIImage imageWithData:myvCard.photo];
    }else {
        self.headImageView.image = [UIImage imageNamed:@"tabbar_me"];
    }
    self.userNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME];
    self.nicknameLabel.text = myvCard.nickname;
    self.departmentLabel.text = myvCard.orgName;
    self.positionLabel.text = myvCard.title;
    self.phoneLabel.text = myvCard.note;
    self.emailLabel.text = myvCard.mailer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.row ==0) {
        return;
    }
    if (indexPath.row == 1) {
        [self showImagePickVc];
    }else {
        [self showEditViewWithIndexPath:indexPath];
    }
}
- (void)showImagePickVc {
        __weak typeof(self) weakSelf = self;
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        weakSelf.pickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
        [weakSelf presentViewController:weakSelf.pickerVc animated:YES completion:nil];
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.pickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:weakSelf.pickerVc animated:YES completion:nil];
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)showEditViewWithIndexPath:(NSIndexPath *)indexPath {
    UILabel *newlabel;
    NSString *title;
    switch (indexPath.row) {
        case NickName:
            newlabel = self.nicknameLabel;
            title = @"昵称";
            break;
        case Department:
            newlabel = self.departmentLabel;
            title = @"部门";
            break;
        case Position:
            newlabel = self.positionLabel;
            title = @"职务";
            break;
        case Phone:
            newlabel = self.phoneLabel;
            title = @"电话";
            break;
        case Email:
            newlabel = self.emailLabel;
            title = @"邮箱";
            break;
        default:
            break;
    }

    [EditView showEditViewWithTitle:title text:newlabel.text UsingBlock:^(NSString *text) {
        newlabel.text = text;
    }];
    
}

#pragma mark - UIImagePickViewDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.headImageView.image = info[@"UIImagePickerControllerOriginalImage"];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveInfo:(UIBarButtonItem *)sender {
    XMPPvCardTemp *myvCard = [BQXMPPTool sharedXMPPTool].vCard.myvCardTemp;
    if (self.headImageView != nil) {
        myvCard.photo = UIImageJPEGRepresentation(self.headImageView.image, 0.5);
    }
    
    myvCard.nickname = self.nicknameLabel.text;
    myvCard.orgName = self.departmentLabel.text;
    myvCard.title = self.positionLabel.text;
    myvCard.note = self.phoneLabel.text;
    myvCard.mailer = self.emailLabel.text;
    
    [[BQXMPPTool sharedXMPPTool].vCard updateMyvCardTemp:myvCard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImagePickerController *)pickerVc {
    if (_pickerVc == nil) {
        UIImagePickerController *imagePickVc = [[UIImagePickerController alloc] init];
        imagePickVc.allowsEditing = YES;
        imagePickVc.delegate = self;
        _pickerVc = imagePickVc;
    }
    return _pickerVc;
}

@end
