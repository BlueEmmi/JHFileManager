//
//  VideoTableViewCell.m
//  LanguageTest
//
//  Created by PSD on 2022/11/22.
//

#import "VideoTableViewCell.h"
#import <Masonry/Masonry.h>
@interface VideoTableViewCell()
@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UIImageView *videoView;
@end


@implementation VideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self addUI];
    }
    return self;
}
-(void)addUI{
    self.videoView = [[UIImageView alloc] init];
    self.videoView.tag = 10086;
    _videoView.contentMode = UIViewContentModeScaleAspectFit;

    [self.contentView addSubview:self.videoView];
//    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.contentView);
//    }];
    
    self.titleLb = [[UILabel alloc] init];
    self.titleLb.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.videoView.frame = self.contentView.bounds;
}


-(void)setModel:(VideoModel *)model{
    _model = model;
    self.titleLb.text = model.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
