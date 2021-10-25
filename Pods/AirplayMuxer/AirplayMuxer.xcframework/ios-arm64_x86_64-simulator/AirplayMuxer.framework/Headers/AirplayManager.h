//
// Created by Arveen kumar on 01/07/2021.
//

#import <Foundation/Foundation.h>
#import <FeedMedia/FeedMedia.h>



@protocol AirplayDelegate<NSObject>

-(CMTime) onAirplayStarted: (AVPlayer*) avplayer;

-(void) onAirplayStopped:(CMTime) time;

@end

@interface AirplayManager : NSObject {
   

}



-(id) init;

- (void)registerAirplayDelegate:(id<AirplayDelegate>)delegate withOriginalUrl:(NSURL *)url musicVolume:(float)vol withStation:(FMStation*) station withCrossfade:(NSTimeInterval) fadeTime;





@end
