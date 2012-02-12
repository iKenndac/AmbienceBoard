//
//  main.m
//  envirod
//
//  Created by Joachim Bengtsson on 2012-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnviroServer.h"

int main (int argc, const char * argv[])
{

	@autoreleasepool {
	    
	    EnviroServer *serv = [EnviroServer new];
	    [serv run];
		[[NSRunLoop currentRunLoop] run];
	}
    return 0;
}

