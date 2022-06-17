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
//    NSLog(@"%@", self.detailsDict);
    // Do any additional setup after loading the view.
    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL = self.detailsDict[@"poster_path"];
    NSString *stringURL = [baseURL stringByAppendingString:posterURL];
    NSURL *imageURL = [NSURL URLWithString:stringURL];
    [self.bigImage setImageWithURL:imageURL];
    [self.thumbImage setImageWithURL:imageURL];
    
    self.titleLabel.text = self.detailsDict[@"original_title"];
    NSNumber *ratingNum = self.detailsDict[@"vote_average"];
    NSString *ratingString = [NSString stringWithFormat:@"%@", ratingNum];
//    NSLog(@"%@", ratingString);
    self.ratingNumLabel.text = ratingString;
    self.synopsisLabel.text = self.detailsDict[@"overview"];
    [self.synopsisLabel sizeToFit];
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
