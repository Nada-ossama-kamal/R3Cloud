package r3cloud;

import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyFactory;
import com.googlecode.objectify.ObjectifyService;

public class OfyService {
	
	static {
        factory().register(r3cloud.Paper.class);
        factory().register(r3cloud.Author.class);
		factory().register(r3cloud.User.class);
		
    }

    public static Objectify ofy() {
        return ObjectifyService.ofy();
    }

    public static ObjectifyFactory factory() {
        return ObjectifyService.factory();
    }

}
