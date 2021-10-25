//
//  NSMutableArray+QueueAdditions.m
//  hls-muxer
//
//  Created by Arveen kumar on 16/08/2021.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (QueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end
