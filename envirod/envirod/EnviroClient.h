#import "TCAsyncHashProtocol.h"
#import "EnviroServer.h"

@interface EnviroClient : NSObject <TCAsyncHashProtocolDelegate>
@property(copy) NSString *host;
@property(readonly) NSDictionary *boards;
-(void)run;
+(EnviroClient*)client;

-(void)setBoard:(NSData*)data forName:(NSString*)name;
@end
