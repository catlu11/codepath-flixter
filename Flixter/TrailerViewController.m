//
//  TrailerViewController.m
//  Flixter
//
//  Created by Catherine Lu on 6/17/22.
//

#import "TrailerViewController.h"
#import "WebKit/WebKit.h"

@interface TrailerViewController ()
    @property (weak, nonatomic) IBOutlet WKWebView *webVideoView;
    @property (weak, nonatomic) IBOutlet UIButton *cancelButton;
    @property (strong, nonatomic) NSString *videoURL;
    @property (strong, nonatomic) NSArray *videoArray;
@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Construct API query
    NSString *movieId = [NSString stringWithFormat:@"%@", self.detailsDict[@"id"]];
    NSString *apiURLString = @"https://api.themoviedb.org/3/movie/";
    apiURLString = [apiURLString stringByAppendingString:movieId];
    apiURLString = [apiURLString stringByAppendingString:@"/videos?api_key=99c35d01f55c02ab3de5e8b1c7d5b6c8&language=en-US"];
    NSURL *apiURL = [NSURL URLWithString:apiURLString];
    
    // Make API request
    NSURLRequest *request = [NSURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       if (error != nil) {
           NSLog(@"No video results.");
       }
       else {
           NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           self.videoArray = dataDictionary[@"results"];
           
           NSString *site = self.videoArray[0][@"site"];
           NSString *key = self.videoArray[0][@"key"];
           
           // Convert the url String to a NSURL object.
           if ([site isEqualToString:@"YouTube"]) {
               self.videoURL = [@"https://www.youtube.com/watch?v=" stringByAppendingString:key];
           }
           else if ([site isEqualToString:@"Vimeo"]) {
               self.videoURL = [@"https://www.vimeo.com/" stringByAppendingString:key];
           }
           else {
               NSLog(@"unknown site :(");
           }
        
           NSURLRequest *videoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.videoURL]
                                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                timeoutInterval:10.0];
           [self.webVideoView loadRequest:videoRequest];
       }
   }];
    [task resume];
}
- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
