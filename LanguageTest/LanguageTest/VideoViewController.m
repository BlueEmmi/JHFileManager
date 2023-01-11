//
//  VideoViewController.m
//  LanguageTest
//
//  Created by PSD on 2022/11/22.
//

#import "VideoViewController.h"
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayer.h>
#import "VideoTableViewCell.h"
#import "VideoModel.h"
#import "VideoCoverView.h"

#define SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height

static NSString *kIdentifier2 = @"VideoTableViewCell";


@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ZFPlayerController *player;
@property(nonatomic,strong) VideoCoverView *stlipControlView;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation VideoViewController


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.pagingEnabled = YES;
//        [_tableView registerClass:[ZFDouYinCell class] forCellReuseIdentifier:kIdentifier];
        [_tableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:kIdentifier2];

        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.frame = self.view.bounds;
        _tableView.rowHeight = _tableView.frame.size.height;
        _tableView.scrollsToTop = NO;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.tableView];
    self.tableView.pagingEnabled = YES;
 

    self.dataSource = [NSMutableArray array];
    [self requestData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.tableView.zf_viewControllerDisappear = true;
    if (self.player.currentPlayerManager.isPlaying) {
        [self.player.currentPlayerManager pause];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tableView.zf_viewControllerDisappear = false;
    if (!self.player.currentPlayerManager.isPlaying) {
        [self.player.currentPlayerManager play];
    }
    
}

- (void)requestData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *videoList = [rootDict objectForKey:@"list"];
    for (NSDictionary *dataDic in videoList) {
        VideoModel *data = [[VideoModel alloc] init];
        [data setValuesForKeysWithDictionary:dataDic];
        [self.dataSource addObject:data];
    }
    [self.tableView reloadData];
    [self playToVideoIndex:false];

}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier2];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self playTheVideoAtIndexPath:indexPath];
}


-(ZFPlayerController *)player{
    if (!_player) {
        /// player,tag值必须在cell里设置
        _player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:[[ZFAVPlayerManager alloc] init] containerViewTag:10086];
        _player.disableGestureTypes = ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch;
        _player.controlView = self.stlipControlView;
        _player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
        _player.allowOrentitaionRotation = NO;
        _player.WWANAutoPlay = YES;
        /// 1.0是完全消失时候
        _player.playerDisapperaPercent = 1.0;
        __weak typeof(self) weakSelf = self;
        _player.playerDidToEnd = ^(id  _Nonnull asset) {
            [weakSelf.player.currentPlayerManager replay];
        };
        
        /// 停止的时候找出最合适的播放
        _player.zf_scrollViewDidEndScrollingCallback = ^(NSIndexPath * _Nonnull indexPath) {
            [weakSelf playToVideoIndex:false];
        };
        
        _player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
            if (weakSelf.tableView.zf_viewControllerDisappear) {
                [weakSelf.player.currentPlayerManager pause];
            }
        };
    }
    return _player;
}

- (void)playToVideoIndex:(bool)load {
    NSInteger index = self.tableView.contentOffset.y / SCREEN_HEIGHT;
    NSInteger cureenIndex = index % self.dataSource.count;
//    if (_cureenIndex == cureenIndex) return;
//    _cureenIndex = cureenIndex;
    VideoModel *data = self.dataSource[cureenIndex];
    
    [self.stlipControlView updateCoverView:data.thumbnail_url placeholderImage:nil];
    [self.player playTheIndexPath:[NSIndexPath indexPathForRow:index inSection:0] assetURL:[NSURL URLWithString:data.video_url]];
}


- (VideoCoverView *)stlipControlView {
    if (!_stlipControlView) {
        _stlipControlView = [VideoCoverView new];
    }
    return _stlipControlView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
