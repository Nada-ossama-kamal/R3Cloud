package r3cloud;

import static r3cloud.OfyService.ofy;

import java.util.Collections;
import java.util.Date;
import java.util.List;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

@Entity
public class Recommendation implements Comparable<Recommendation>{
	
	@Id
	Long id;
	@Index
	Date recommendation_date;
	@Index
	Key<User> recommender;
	@Index
	List<Key<Paper>> papers;
	@Index
	Key<Request> request;
	public Recommendation(Key<User> recommender, Key<Request> request, List<Key<Paper>> papers){
		this.recommender = recommender;
		this.request = request;
		this.papers = papers;
		this.recommendation_date = new Date();
	}
	public Recommendation(){
		
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Date getRecommendation_date() {
		return recommendation_date;
	}
	public void setRecommendation_date(Date recommendation_date) {
		this.recommendation_date = recommendation_date;
	}
	public Key<User> getRecommender() {
		return recommender;
	}
	public void setRecommender(Key<User> recommender) {
		this.recommender = recommender;
	}
	public List<Key<Paper>> getPapers() {
		return papers;
	}
	public void setPapers(List<Key<Paper>> papers) {
		this.papers = papers;
	}
	public Key<Request> getRequest() {
		return request;
	}
	public void setRequest(Key<Request> request) {
		this.request = request;
	}
	@Override
	public int compareTo(Recommendation o) {
		// TODO Auto-generated method stub
		if (this.getRecommendation_date().after(o.getRecommendation_date()))
			return -1;
		else 
			return 1;
	}
	public static List<Recommendation> loadRecommendationsByRequest(Key<Request> req){
		List<Recommendation> recommendations = ofy().load().type(Recommendation.class).filter("request", req).list();
		Collections.sort(recommendations);
		return recommendations;
	}
	
	public static Recommendation createRecommendation(Key<User> recommender, Key<Request> req, List<Key<Paper>> papers) {
		Recommendation recomm = new Recommendation(recommender, req, papers);
		ofy().save().entity(recomm).now();
		return recomm;
	}
}
