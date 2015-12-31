//
//  CheattingVC.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/27.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "CheattingVC.h"
#import "BQFootImageView.h"
#import <AVFoundation/AVFoundation.h>
#import <BmobSDK/BmobFile.h>

typedef NS_ENUM(NSUInteger, MessageType) {
    MessageType_Text = 100,
    MessageType_Sound,
    MessageType_Image
};

static NSString * const kIdentifiText = @"CheattingCellText";
static NSString * const kIdentifiImage = @"CheattingCellImage";
static NSString * const kIdentifiSound = @"CheattingCellSound";

@interface CheattingVC ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextFieldDelegate,BQFootImageViewDelegate>
{
    XMPPUserCoreDataStorageObject *_firendInfo;
    NSManagedObjectContext *_msgContext;
    NSFetchedResultsController *_msgResultsCtl;
    AVAudioPlayer *_player;
}
/**
 *  表格视图
 */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BQFootImageView *footView;

@end

@implementation CheattingVC

#pragma mark - 类方法

#pragma mark - 创建方法
- (instancetype)initWithXMPPUserCoreDataStorageObject:(XMPPUserCoreDataStorageObject *) firend{
    self = [super init];
    if (self) {
        _firendInfo = firend;
        self.title = [firend.jidStr componentsSeparatedByString:@"@"][0];
    }
    return self;
}
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self registerNotification];
}
- (void)dealloc {
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}
#pragma mark - 实例方法
- (void)initData{
    //获取聊天消息的上下文
    _msgContext = [BQXMPPTool sharedXMPPTool].messageStorage.mainThreadManagedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sort];
    //将不满足条件的过滤
    NSPredicate *predic = [NSPredicate predicateWithFormat:@"bareJidStr = %@",_firendInfo.jidStr];
    request.predicate = predic;
    
    //获取数据库结果
    _msgResultsCtl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_msgContext sectionNameKeyPath:nil cacheName:nil];
    _msgResultsCtl.delegate = self;
    NSError *error;
    [_msgResultsCtl performFetch:&error];
    if (error) {
        BQLog(@"数据库读取出错:%@",error.localizedDescription);
    }
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footView];
    [self controllerDidChangeContent:_msgResultsCtl];
}

- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification"
                                               object:nil];
}

- (void)sendMessageWithMsgType:(MessageType)msgType withBody:(NSString *)body {
    XMPPStream *stream = [BQXMPPTool sharedXMPPTool].xmppStream;
    //配置消息体
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:_firendInfo.jid];

    [message addAttributeWithName:@"MessageType" intValue:msgType];

    [message addBody:body];
    
    //发送消息
    [stream sendElement:message];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
//        if ([identifier isEqualToString:kIdentifiText]) {
//            
//        }else if ([identifier isEqualToString:kIdentifiImage]) {
//            
//        }else if ([identifier isEqualToString:kIdentifiSound]) {
//            
//        }
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}
#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XMPPMessageArchiving_Message_CoreDataObject *msg = _msgResultsCtl.fetchedObjects[indexPath.row];
    XMPPMessage *message = msg.message;
    MessageType type = [message attributeIntValueForName:@"MessageType"];
    if (type == MessageType_Sound) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:message.body];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSError *error;
            _player = [[AVAudioPlayer alloc] initWithData:data error:&error];
            _player.volume = 1.0f;
            if (error == nil && [_player prepareToPlay]) {
                [_player play];
            }
        });
    }
}
#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _msgResultsCtl.fetchedObjects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPMessageArchiving_Message_CoreDataObject *msg = _msgResultsCtl.fetchedObjects[indexPath.row];
    XMPPMessage *message = msg.message;
    MessageType type = [message attributeIntValueForName:@"MessageType"];
    UITableViewCell *cell;
    switch (type) {
        case MessageType_Text:
            cell = [self tableView:tableView cellWithIdentifier:kIdentifiText];
            break;
        case MessageType_Sound:
            cell = [self tableView:tableView cellWithIdentifier:kIdentifiSound];
            break;
        case MessageType_Image:
            cell = [self tableView:tableView cellWithIdentifier:kIdentifiImage];
            break;
        default:
            break;
    }
    
    cell.textLabel.text = message.body;
    
    return cell;
}


#pragma mark - NSFetchedResultsControllerDelegate Method
/**
 *  数据库内容已发生改变
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
    if (controller.fetchedObjects.count > 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:controller.fetchedObjects.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

#pragma mark - UITextFieldDelegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    [self sendMessageWithMsgType:MessageType_Text withBody:self.footView.textField.text];
    
    self.footView.textField.text = nil;
    
    return YES;
}
#pragma mark - 监听听筒or扬声器

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        BQLog(@"手机靠近用户,启用一般模式");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        BQLog(@"手机离开用户,启用扩音模式");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}
#pragma mark - BQFootImageViewDelegate Method

- (void)footImageViewclickedBtnCallBackWithButton:(UIButton *)btn {
    
}

- (void)footImageViewrecorderEndWithUrl:(NSString *)file {
    NSData *data = [NSData dataWithContentsOfFile:file];

    //将数据上传至服务器
    //1.配置文件名字
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileName = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME] stringByAppendingString:[format stringFromDate:date]];
    fileName = [fileName stringByAppendingString:@".caf"];
    
    
    [BmobFile filesUploadBatchWithDataArray:@[@{@"filename":fileName,@"data":data}] progressBlock:^(int index, float progress) {
        NSLog(@"%lf",progress);
    } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
        if (isSuccessful == YES) {
            BmobFile *bmobfile = (BmobFile *)[array firstObject];
            [self sendMessageWithMsgType:MessageType_Sound withBody:bmobfile.url];
        }else {
            BQLog(@"%@",error.localizedDescription);
        }
    }];
    
}
#pragma mark - get方法

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HAS_NAVIGATIONBAR_HEIGHT - 44) style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (BQFootImageView *)footView {
    if (_footView == nil) {
        _footView = [[BQFootImageView alloc] initWithFrame:CGRectMake(0, HAS_NAVIGATIONBAR_HEIGHT - 44, SCREEN_WIDTH, 44)];
        _footView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
        _footView.delegate = self;
        _footView.textField.delegate = self;
    }
    return _footView;
}


@end
