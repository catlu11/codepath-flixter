//
//  DetailsViewController.m
//  
//
//  Created by Catherine Lu on 6/15/22.
//

#import "DetailsViewController.h"
#import "TrailerViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
    @property (weak, nonatomic) IBOutlet UIImageView *bigImage;
    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
    @property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
    @property (weak, nonatomic) IBOutlet UILabel *ratingNumLabel;
    @property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
    @property (strong, nonatomic) IBOutlet UITapGestureRecognizer *thumbTapGesture;
    @property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Load images
//    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
//    NSString *posterURL = self.detailsDict[@"poster_path"];
//    NSString *stringURL = [baseURL stringByAppendingString:posterURL];
//    NSURL *imageURL = [NSURL URLWithString:stringURL];
//
    NSString *baseSmallURL = @"https://image.tmdb.org/t/p/w45";
    NSString *baseBigURL = @"https://image.tmdb.org/t/p/original";
    NSString *posterURL = self.detailsDict[@"poster_path"];
    NSString *smallURL = [baseSmallURL stringByAppendingString:posterURL];
    NSString *bigURL = [baseBigURL stringByAppendingString:posterURL];
    NSURL *imageSmallURL = [NSURL URLWithString:smallURL];
    NSURL *imageBigURL = [NSURL URLWithString:bigURL];
    
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:imageSmallURL];
    NSURLRequest *requestBig = [NSURLRequest requestWithURL:imageBigURL];

    [self.thumbImage setImageWithURL:imageBigURL];
    [self.bigImage setImageWithURLRequest:requestSmall placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *smallImage) {
         self.bigImage.image = smallImage;
         
         [self.bigImage setImageWithURLRequest:requestBig placeholderImage:smallImage
                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                    self.bigImage.image = largeImage;
                }
                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    NSLog(@"Failed to retrieve larger image.");
                }];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
            NSLog(@"Failed to retrieve image.");
    }];
    
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

//- (IBAction)didTap:(UITapGestureRecognizer *)sender {
//    CGPoint location = [sender locationInView:self.view];
//   // User tapped at the point above. Do something with that if you want.
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TrailerViewController *trailerVC = [segue destinationViewController];
    trailerVC.detailsDict = self.detailsDict;
}

@end
