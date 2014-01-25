package r3cloud;

import static r3cloud.OfyService.ofy;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import com.google.appengine.api.blobstore.BlobKey;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

@Entity
public class Review implements Comparable<Review>{

	@Id
	Long id;
	@Index
	Date review_date;
	@Index
	Key<User> author;
	@Index 
	Key<Paper> reviewed_paper;
	@Index
	String text;
	
	public Review(){
		
	}
	public Review(Key<User> author, Key<Paper> reviewed_paper, String text){
		this.review_date = new Date();
		this.author = author;
		this.reviewed_paper = reviewed_paper;
		this.text = text;
	}
	
	public static void deleteReviewByID(Long id){
		ofy().delete().type(Review.class).id(id).now();
	}
	
	public static Review createReview(Key<User> author, Key<Paper> paper, String text) {
		Review review = new Review (author, paper, text);
		ofy().save().entity(review).now();
		return review;
	}
	
	//list of reviews for a certain paper
	public static List<Review> getReviewsByPaper(long paperId){
		Key<Paper> paperKey = Paper.getPaperKey(paperId);
		
		List<Review> reviews = ofy().load().type(Review.class).list();
		List<Review> paperReviews = new ArrayList<Review>();
		for (Review r:reviews)
			if (r.getReviewed_paper().equals(paperKey))
				paperReviews.add(r);
		Collections.sort(paperReviews);

		return paperReviews;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Date getReview_date() {
		return review_date;
	}
	public void setReview_date(Date review_date) {
		this.review_date = review_date;
	}
	public Key<User> getAuthor() {
		return author;
	}
	public void setAuthor(Key<User> author) {
		this.author = author;
	}
	public Key<Paper> getReviewed_paper() {
		return reviewed_paper;
	}
	public void setReviewed_paper(Key<Paper> reviewed_paper) {
		this.reviewed_paper = reviewed_paper;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	@Override
	public int compareTo(Review o) {
		// TODO Auto-generated method stub
		if (this.getReview_date().after(o.getReview_date()))
			return -1;
		else 
			return 1;
	}
	
}
