#import "TCAsyncHashProtocol.h"

#define kPort 23589

@interface EnviroServer : NSObject <TCAsyncHashProtocolDelegate>
-(void)run;
@end