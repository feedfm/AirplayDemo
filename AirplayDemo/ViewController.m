//
//  ViewController.m
//  testing2
//
//  Created by Arveen kumar on 19/07/2021.
//

@import AVKit;

#import "ViewController.h"

@interface ViewController () <AirplayDelegate>


@property (weak, nonatomic) IBOutlet UIButton *airPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property AirplayManager *airPlayer;
@property AVPlayer *player;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FMLogSetLevel(FMLogLevelDebug);
    FMAudioPlayer *player = [FMAudioPlayer sharedPlayer];
      
    [player whenAvailable:^{
        
        NSLog(@"Available");
       
    } notAvailable:^{
        NSLog(@"Not available");
    }];
    
    _airPlayer = [[AirplayManager alloc] init];
    if (@available(iOS 11.0, *)) {
        AVRoutePickerView *playView = [[AVRoutePickerView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_airPlayButton addSubview:playView];
    }
    
}


- (IBAction)playButton:(id)sender {
    
    // Audio session must be started for this to work.
    AVAudioSession *avAudioSession = [AVAudioSession sharedInstance];
    if (@available(iOS 13.0, *)) {
        Boolean success = [avAudioSession setCategory: AVAudioSessionCategoryPlayback
                                                mode: AVAudioSessionModeDefault
                                  routeSharingPolicy:AVAudioSessionRouteSharingPolicyDefault
                                             options: AVAudioSessionCategoryOptionAllowAirPlay
                                               error: nil];
    } else {
    // Fallback on earlier versions
    }
    [avAudioSession setActive: YES error: nil];
    //
    FMAudioPlayer *player = [FMAudioPlayer sharedPlayer];
    NSURL *videoURL = [NSURL URLWithString:@"https://cdn.jwplayer.com/manifests/BxgGjBH3.m3u8"];
    //Base Url of the hoster server
    // When a video has started, register a new delegate.
    [_airPlayer registerAirplayDelegate:self withOriginalUrl:videoURL musicVolume:0.15 withStation:player.stationList[1] withCrossfade:6];
    
    _player = [AVPlayer playerWithURL:videoURL];
    _player.allowsExternalPlayback = YES;

    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = self.playerView.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:playerLayer];
    [_player play];
    
    
}

// this method will be called when AirplaySDK has taken over playback. Pause your existing players and feedfm player before returning

- (CMTime)onAirplayStarted:(AVPlayer *)avplayer {
    
    CMTime time = [_player currentTime];
    [_player pause];
    [_player replaceCurrentItemWithPlayerItem:nil];
    
    // return current time of video or zero to start from beginning
    return time;
}


// restart the video from the given time
- (void)onAirplayStopped:(CMTime)time {
    
    NSURL *videoURL = [NSURL URLWithString:@"https://cdn.jwplayer.com/manifests/BxgGjBH3.m3u8"];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:videoURL];
    [_player replaceCurrentItemWithPlayerItem:item];
    [_player seekToTime:time];
    [_player play];
}


@end
