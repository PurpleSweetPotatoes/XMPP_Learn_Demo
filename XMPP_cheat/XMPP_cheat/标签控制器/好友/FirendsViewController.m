//
//  FirendsViewController.m
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/13.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "FirendsViewController.h"
#import "AddFirendViewController.h"
#import "CheattingVC.h"
@interface FirendsViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
{
    /**
     *  表查询数据结果控制器
     */
    NSFetchedResultsController *_resultsCtl;
}

/**
 *  数据库上下文
 */
@property (nonatomic, strong) NSManagedObjectContext *rosterContext;

/**
 *  展示的tableView表
 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FirendsViewController

#pragma mark - 类方法

#pragma mark - 创建方法

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self registerNotification];
}

#pragma mark - 实例方法
- (void)initData{
    
    //1.配置花名册数据库上下文(2种方式)
    _rosterContext = [BQXMPPTool sharedXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    //2.从上下文中取出对应的模型
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //3.设置结果排序规则
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    //3.1利用条件筛选，过滤
    NSPredicate *predic = [NSPredicate predicateWithFormat:@"subscription != %@",@"none"];
    request.predicate = predic;
    //4.根据规则配置对应数据库中的数据存取器
    _resultsCtl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_rosterContext sectionNameKeyPath:nil cacheName:nil];
    //5.利用获取数据
    NSError *error;
    [_resultsCtl performFetch:&error];
    if (error) {
        BQLog(@"%@",error);
        return;
    }
    //6.设置代理(配置数据存取器后，每当数据有改变时都会回调方法)
    _resultsCtl.delegate = self;
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(addFirendToMyList:)];
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)registerNotification{
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultsCtl.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    //取得对应好友的用户信息
    XMPPUserCoreDataStorageObject *user = _resultsCtl.fetchedObjects[indexPath.row];

    if (user.photo) {
        cell.imageView.image = user.photo;
    }else {
        NSData *imageData = [[BQXMPPTool sharedXMPPTool].avatar photoDataForJID:user.jid];
        cell.imageView.image = [UIImage imageWithData:imageData];
    }
    cell.textLabel.text = [user.jidStr componentsSeparatedByString:@"@"][0];
    cell.detailTextLabel.text = [self getUserStateWithUserObject:user];
    return cell;
}
#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XMPPUserCoreDataStorageObject *user = _resultsCtl.fetchedObjects[indexPath.row];
    CheattingVC *cheatVc = [[CheattingVC alloc] initWithXMPPUserCoreDataStorageObject:user];
    [cheatVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:cheatVc animated:YES];
}

//配置删除好友
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //获取对应好友信息
        XMPPUserCoreDataStorageObject *user = _resultsCtl.fetchedObjects[indexPath.row];
        //根据好友jid删除好友
        [[BQXMPPTool sharedXMPPTool].roster removeUser:user.jid];
        [self.tableView reloadData];
    }
}
#pragma mark - NSFetchedResultsControllerDelegate 
/**
 *  存取器结果已经发生改变时调用
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - 事件响应方法
- (void)addFirendToMyList:(UIBarButtonItem *)item {
    AddFirendViewController *addFirendVc = [[AddFirendViewController alloc] initWithNibName:@"AddFirendViewController" bundle:nil];
    addFirendVc.title = item.title;
    [addFirendVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:addFirendVc animated:YES];
}
#pragma mark - Method
- (NSString *)getUserStateWithUserObject:(XMPPUserCoreDataStorageObject *)user {
    
    NSString *userState;
    
    switch ([user.sectionNum intValue]) {
        case UserOnLine:
            userState = @"在线";
            break;
        case UserGoOut:
            userState = @"离在";
            break;
        case UserOffLine:
            userState = @"离线";
            break;
        default:
            break;
    }
    return userState;
}
#pragma mark - set方法

#pragma mark - get方法
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,HAS_TABBAR_AND_NAVIGATIONBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
@end
