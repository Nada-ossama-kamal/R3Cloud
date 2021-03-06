package r3cloud;

import static r3cloud.OfyService.ofy;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import com.google.api.server.spi.config.ApiResourceProperty;
import com.google.api.server.spi.config.ApiTransformer;
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.datastore.QueryResultIterable;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyFactory;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Load;
import com.googlecode.objectify.cmd.Query;

@Entity
public class Paper implements Comparable{
	@Id
	Long id;
	@Index
	@Load
	String title;
	@Index
	String date;
	@Index
	boolean text;
	@Index
	String url;
	@Index
	BlobKey content;
	String abstractPaper;
	@Index
	Key<User> owner;
	@Index
	String topic;
	@Index
	String[] keywords;
	@Index
	List<Key<Author>> authors;
	String lastUpdatedDate;
	double rating;

	public Paper() {

	}

	public Paper(String title, boolean text, String url, BlobKey content,
			String abstractPaper, Key<User> owner, String topic,
			String[] keywords, List<Key<Author>> authors) {
		this.title = title;
		DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		Date now = Calendar.getInstance().getTime();
		String date = df.format(now);
		this.date = date;
		this.text = text;
		if (text)
			this.content = content;
		else
			this.url = url;
		
		
		this.abstractPaper = abstractPaper;
		this.owner = owner;
		this.topic = topic;
		this.keywords = keywords;
		this.authors = authors;
		this.lastUpdatedDate = date;
		this.rating = 0.0;
	}

	public static Paper createPaper(String title, boolean text, String url,
			BlobKey content, String abstractPaper, Key<User> owner, String topic,
			String[] keywords, List<Key<Author>> authors) {
		Paper paper = new Paper(title, text, url, content, abstractPaper,
				owner, topic, keywords, authors);
		ofy().save().entity(paper).now();
		
		
		
		return paper;
	}
	
	public static void deletePaperByID(Long id){
		ofy().delete().type(Paper.class).id(id).now();
	}
	
	

	
	/*
	 * public static void editPaper(Key<Paper> paperKey, String title, boolean
	 * text, String url, File content, String abstractPaper, Key<User> owner,
	 * String topic, List<String> keywords, List<Key<Author>> authors){ Long id
	 * = paperKey.getId(); Paper paper =
	 * ofy().load().type(Paper.class).id(id).get(); ofy(). boolean titleChanged
	 * = false; boolean textChanged = false; boolean urlChanged = false; boolean
	 * keywordsChanged = false; boolean authorsChanged = false;
	 * 
	 * 
	 * }
	 */
	
	public String getTitle() {
		return this.title;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public void setText(boolean text) {
		this.text = text;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public void setContent(BlobKey content) {
		this.content = content;
	}

	public void setAbstractPaper(String abstractPaper) {
		this.abstractPaper = abstractPaper;
	}

	public void setOwner(Key<User> owner) {
		this.owner = owner;
	}

	public void setTopic(String topic) {
		this.topic = topic;
	}
	
	public static Paper setTopicByID(Long id, String topic) {
		Paper paper = Paper.loadPaperById(id);
		paper.setTopic(topic);
		DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		Date now = Calendar.getInstance().getTime();
		String date = df.format(now);
		paper.setLastUpdatedDate(date);
		//com.google.appengine.api.datastore.Entity paperEntity = ofy().toEntity(paper);
		//paperEntity.setProperty("topic",topic);
		ofy().save().entity(paper).now();
		
		return paper;
	}
	public static Paper setTitleByID(Long id, String title) {
		Paper paper = Paper.loadPaperById(id);
		paper.setTitle(title);
		DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		Date now = Calendar.getInstance().getTime();
		String date = df.format(now);
		paper.setLastUpdatedDate(date);
		ofy().save().entity(paper).now();
		//com.google.appengine.api.datastore.Entity paperEntity = ofy().toEntity(paper);
		//paperEntity.setProperty("title",title);
		
		
		return paper;
	}
	
	public static Paper setAbstractByID(Long id, String abs) {
		Paper paper = Paper.loadPaperById(id);
		ofy().load().type(Paper.class).id(id).getKey();
		paper.setAbstractPaper(abs);
		DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		Date now = Calendar.getInstance().getTime();
		String date = df.format(now);
		paper.setLastUpdatedDate(date);
		ofy().save().entity(paper).now();
		//com.google.appengine.api.datastore.Entity paperEntity = ofy().toEntity(paper);
		//paperEntity.setProperty("abstractPaper",abs);
		//ofy().save().entities(paperEntity);
		
		return paper;
	}

	public static Paper setKeywordsByID(Long id, String[] keywordsPaper){
		Paper paper = Paper.loadPaperById(id);
		ofy().load().type(Paper.class).id(id).getKey();
		paper.setKeywords(keywordsPaper);
		DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		Date now = Calendar.getInstance().getTime();
		String date = df.format(now);
		paper.setLastUpdatedDate(date);
		ofy().save().entity(paper).now();
		//com.google.appengine.api.datastore.Entity paperEntity = ofy().toEntity(paper);
		//ArrayList<String> keywordsArray = new ArrayList<String>(Arrays.asList(keywordsPaper));
		//paperEntity.setProperty("keywords",keywordsArray);
		//ofy().save().entities(paperEntity);
		
		return paper;
	}
	
	public static Paper setAuthorsByID(Long paperID, ArrayList<Key<Author>> authors) {
		Paper paper = Paper.loadPaperById(paperID);
		paper.setAuthors(authors);
		DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		Date now = Calendar.getInstance().getTime();
		String date = df.format(now);
		paper.setLastUpdatedDate(date);
		ofy().save().entity(paper).now();
		
		//com.google.appengine.api.datastore.Entity paperEntity = ofy().toEntity(paper);
		//paperEntity.setProperty("authors",authors);
		//ofy().save().entities(paperEntity);
		
		return paper;
	}
	
	public static Paper setContentByID(Long paperID, boolean text, String url, BlobKey content){
		Paper paper = Paper.loadPaperById(paperID);
		paper.setText(text);
		if(text)
			paper.setContent(content);
		else
			paper.setUrl(url);
		
		ofy().save().entity(paper).now();
		return paper;
		
	}
	
	

	public void setKeywords(String[] keywords) {
		this.keywords = keywords;
	}

	public void setAuthors(List<Key<Author>> authors) {
		this.authors = authors;
	}

	public void setLastUpdatedDate(String lastUpdatedDate) {
		this.lastUpdatedDate = lastUpdatedDate;
	}

	public Key<Paper> getKey() {
		Key<Paper> paperKey = Key.create(Paper.class, this.id);
		return paperKey;
	}
	
	public static List<Paper> loadAll(){
	    List<Paper> papers = ofy().load().type(Paper.class).order("title").list();
//	    for(Paper paper:papers){
//			paper.rating=0.0;
//			ofy().save().entity(paper).now();
//	    }
		return papers;
		
	}
public static  List<Paper> Search(String searchTerm){
		
		QueryResultIterable<Paper> allPapers = ofy().load().type(Paper.class)
				.order("title").iterable();
		
		List<Paper> listPapersWithSearchTerm = new ArrayList<Paper>();

		

		
		for (Paper paper : allPapers) {
			
			if (paper.title.toLowerCase().trim().contains(searchTerm.toLowerCase())) {
				
				listPapersWithSearchTerm.add(paper);
				continue;
			}
			
			for(String keyword : paper.keywords){
				if(keyword.toLowerCase().trim().contains(searchTerm.toLowerCase())){
					
					listPapersWithSearchTerm.add(paper);
					break;
				}
				
			}
				

		}
		
		return listPapersWithSearchTerm;

	}
/**Adds or updates rating for paper based on the user input
	 * 
	 * @param paperID
	 * @param username
	 * @param score
	 */
    public static void addRatingById(Long paperID, String username, double score){ 
    	ofy().clear();
    	Paper paper = Paper.loadPaperById(paperID);
    	double oldUserRating=0.0;
    	
    	if(r3cloud.Rating.getByPaperAndUser(paperID, username)==null){
    		Rating rating=	Rating.createRating(User.getUserKey(username), paper.getKey(), score);
    		ofy().save().entity(rating).now();
    		ofy().clear();
//    		System.out.println("score sent"+score);
//    		System.out.println("rating size"+r3cloud.Rating.getByPaper(paperID).size());
//    		System.out.println(paper.rating);
    		paper.rating=(paper.rating*(r3cloud.Rating.getByPaper(paperID).size()-1)+score)/r3cloud.Rating.getByPaper(paperID).size();
//    		System.out.println(paper.rating);
    	}else{
    		Rating rating=r3cloud.Rating.getByPaperAndUser(paperID, username);
    		oldUserRating=rating.getScore();
    		rating.setScore(score);
    		ofy().save().entity(rating).now();
    		paper.rating=(paper.rating*r3cloud.Rating.getByPaper(paperID).size())-oldUserRating;
    	
    		paper.rating=(paper.rating+score)/r3cloud.Rating.getByPaper(paperID).size();

    		
    	}
    	
    	
    	  
    	 
    	  ofy().save().entity(paper).now();
    }
    /**Deletes rating for paper based on the user input
	 * 
	 * @param paperID
	 * @param username
	 * 
	 */
    public static void deleteRatingById(Long paperID, String username){ 
    	ofy().clear();
    	Paper paper = Paper.loadPaperById(paperID);
    	
    	double oldUserRating=0.0;
    	if(r3cloud.Rating.getByPaperAndUser(paperID, username)==null){
    		
    	}else{
    		Rating rating=r3cloud.Rating.getByPaperAndUser(paperID, username);
    		oldUserRating=rating.getScore();
    		ofy().clear();
    		paper.rating=(paper.rating*r3cloud.Rating.getByPaper(paperID).size())-oldUserRating;
    		
    		ofy().delete().entity(rating).now();
    		ofy().clear();
    		if(r3cloud.Rating.getByPaper(paperID).size()!=0)
    		paper.rating=(paper.rating)/r3cloud.Rating.getByPaper(paperID).size();
    		else
    			paper.rating=0.0;
    		
    	}
    	
    	 
    	  
    	  
    	  ofy().save().entity(paper).now();
    }
    
    public static int getVotesNoById(Long paperId){
    	return r3cloud.Rating.getByPaper(paperId).size();
    	
    }
    public double getRating(){
    	return rating;
    }
	public static Paper loadPaperById(Long id){
		Paper paper = ofy().cache(false).load().type(Paper.class).id(id).get();

		return paper;
	}
	public Long getId() {
		return id;
	}

	public String getDate() {
		return date;
	}

	public boolean isText() {
		return text;
	}

	public String getUrl() {
		return url;
	}

	public BlobKey getContent() {
		return content;
	}

	public String getAbstractPaper() {
		return abstractPaper;
	}

	public Key<User> getOwner() {
		return owner;
	}

	public String getTopic() {
		return topic;
	}

	public String[] getKeywords() {
		return keywords;
	}

	public List<Key<Author>> getAuthors() {
		return authors;
	}

	public String getLastUpdatedDate() {
		return lastUpdatedDate;
	}

	public static List<Paper> loadTopic(String topic){
		List<Paper> papers = ofy().load().type(Paper.class).filter("topic", topic).list();
		return papers;
	}
	
	
	public static List<String> getAllTopics(){
		List<Paper> papers = ofy().load().type(Paper.class).list();
		List<String> topics = new ArrayList<String>();
		for(Paper paper:papers){
			String topic = paper.topic;
			if(!topics.contains(topic)){
				topics.add(topic);
			}
		}
		return topics;
	}

	public static Paper getPaperById(long id){
		r3cloud.Paper paper = ofy().load().type(r3cloud.Paper.class).id(id).get();
		return paper;
	}
	public static r3cloud.Paper getPaperByKey(Key<Paper> paperKey){
		r3cloud.Paper paper = ofy().load().key(paperKey).getValue();
		return paper;
	}
	public static Key<r3cloud.Paper> getPaperKey(long id){
		Key<r3cloud.Paper> paperKey = Key.create(r3cloud.Paper.class, id);
		return paperKey ;
	}
	
	//list of papers belonging to a user
	public static List<Paper> getPapersByUser(Key<User> user){
		
		List<Paper> papers = ofy().load().type(Paper.class).list();
		List<Paper> userPapers = new ArrayList<Paper>();
		for (Paper p : papers)
			if (p.getOwner().equals(user))
				userPapers.add(p);
		Collections.sort(userPapers);

		return userPapers;
	}
	

	@Override
	public int compareTo(Object o) {
		// TODO Auto-generated method stub
		Paper p = (Paper) o;
		//this.get
		Date thisDate = new Date(this.getDate());
		Date pDate = new Date(p.getDate());
		if (thisDate.after(pDate))
			return -1;
		else 
			return 1;
	}
}
