package r3cloud;

import static r3cloud.OfyService.ofy;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

@Entity
public class Rating {
	@Id
	Long id;
	@Index
	Key<User> rater;
	@Index
	Key<Paper> paper;
	double score;
	
	public Rating()
	{	
		
	}
	public Rating(Key<User> rater, Key<Paper> paper, double score) {
		this.rater = rater;
		this.paper = paper;
		this.score = score;
	}
	
	public static Rating createRating(Key<User> rater, Key<Paper> paper, double score) {
		
		
			Rating rating = new  Rating( rater,  paper, score);
			ofy().save().entity(rating).now();
			return rating;
		
		}
		
		
	
	public Key<User> getRater() {
		return rater;
	}
	public void setRater(Key<User> rater) {
		this.rater = rater;
	}
	public Key<Paper> getPaper() {
		return paper;
	}
	public void setPaper(Key<Paper> paper) {
		this.paper = paper;
	}
	public double getScore() {
		return score;
	}
	public Key<Rating> getKey() {
		Key<Rating> ratingKey = Key.create(Rating.class, this.id);
		return ratingKey;
	}
	public void setScore(double score) {
		this.score = score;
		ofy().save().entity(this).now();
	}
	public static Rating getByPaperAndUser(long paperId,String username){
		Rating rating=ofy().cache(false).load().type(Rating.class).filter("rater",User.getUserKey(username)).filter("paper",r3cloud.Paper.loadPaperById(paperId)).first().get();
		return rating;
	}
	public static List<Rating> getByPaper(long paperId){
		List<Rating> ratings=ofy().cache(false).load().type(Rating.class).filter("paper",r3cloud.Paper.loadPaperById(paperId)).list();
		return ratings;
	}
}
