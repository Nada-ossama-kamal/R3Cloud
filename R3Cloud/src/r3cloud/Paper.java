package r3cloud;

import static r3cloud.OfyService.ofy;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.datastore.QueryResultIterable;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.cmd.Query;

@Entity
public class Paper {
	@Id
	Long id;
	@Index
	String title;
	@Index
	String date;
	@Index
	boolean text;
	@Index
	String url;
	@Index
	BlobKey content;
	@Index
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
	}

	public static Paper createPaper(String title, boolean text, String url,
			BlobKey content, String abstractPaper, Key<User> owner, String topic,
			String[] keywords, List<Key<Author>> authors) {
		Paper paper = new Paper(title, text, url, content, abstractPaper,
				owner, topic, keywords, authors);
		ofy().save().entity(paper).now();
		return paper;
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
		
		
		ofy().load().type(Paper.class).id(id).getKey();
		paper.setTopic(topic);
		com.google.appengine.api.datastore.Entity paperEntity = ofy().toEntity(paper);
		paperEntity.setProperty("topic",topic);
		ofy().save().entities(paperEntity);
		
		return paper;
	}
	public static Paper setTitleByID(Long id, String title) {
		Paper paper = Paper.loadPaperById(id);
		
		
		ofy().load().type(Paper.class).id(id).getKey();
		paper.setTitle(title);
		com.google.appengine.api.datastore.Entity paperEntity = ofy().toEntity(paper);
		paperEntity.setProperty("title",title);
		ofy().save().entities(paperEntity);
		
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
	    List<Paper> papers = ofy().load().type(Paper.class).list();
		return papers;
		
	}
	
	public static Paper loadPaperById(Long id){
		
		Paper paper = ofy().load().type(Paper.class).id(id).get();
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
	
	 

	
	

}
