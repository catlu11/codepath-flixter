//
//  DetailsViewController.m
//  
//
//  Created by Catherine Lu on 6/15/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
    @property (weak, nonatomic) IBOutlet UIImageView *bigImage;
    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
    @property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
    @property (weak, nonatomic) IBOutlet UILabel *ratingNumLabel;
    @property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
    @property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load images
    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL = self.detailsDict[@"poster_path"];
    NSString *stringURL = [baseURL stringByAppendingString:posterURL];
    NSURL *imageURL = [NSURL URLWithString:stringURL];
    [self.bigImage setImageWithURL:imageURL];
    [self.thumbImage setImageWithURL:imageURL];
    
    // Set title text
    self.titleLabel.text = self.detailsDict[@"original_title"];
    
    // Set rating text
    NSNumber *ratingNum = self.detailsDict[@"vote_average"];
    NSString *ratingString = [NSString stringWithFormat:@"%@", ratingNum];
    self.ratingNumLabel.text = ratingString;
    
    // Set synopsis text
    self.synopsisLabel.text = self.detailsDict[@"overview"];
    [self.synopsisLabel sizeToFit];
}

@end
