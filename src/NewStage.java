import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javafx.geometry.Insets;
import javafx.geometry.Orientation;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.ScrollBar;
import javafx.scene.control.ScrollPane;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.stage.Stage;

public class NewStage {
    
    NewStage() throws IOException, InterruptedException 
    {
    	//transfer over information to text files
    	Process textFilesCreation = Runtime.getRuntime().exec("perl C:\\Users\\Nidal\\Programs\\Eclipse_neon\\GeneDatabase\\GeneInfoToTextFiles.pl");
    	textFilesCreation.waitFor();
    	BufferedReader br = new BufferedReader(new FileReader("temp.txt"));
    	
    	
    	//READ ALL GENE TRAITS and add to user interface...with labels for titles
    	
    	//read gene
    	ArrayList <String> tempList = new ArrayList<String>();
	    FileReader tempFile = new FileReader("C:/Users/Nidal/Programs/Eclipse_neon/GeneDatabase/temp.txt");
	    BufferedReader tempReader = new BufferedReader(tempFile);
	    String tempLine = null;

	    while ((tempLine = tempReader.readLine()) != null) {
	    	tempList.add(tempLine);
	    	 }
	    
	    Label geneName = new Label("Gene:");
	    geneName.setTextFill(Color.web("#0076a3"));
    	
    	//read general protein name
    	ArrayList <String> genProtList = new ArrayList<String>();
	    FileReader genProtFile = new FileReader("C:/Users/Nidal/Programs/Eclipse_neon/GeneDatabase/genProteinFile.txt");
	    BufferedReader genProtReader = new BufferedReader(genProtFile);
	    String genProtLine = null;

	    while ((genProtLine = genProtReader.readLine()) != null) {
	    	genProtList.add(genProtLine);
	    	 }
	    
	    Label genProt = new Label("General Protein Name:");
	    genProt.setTextFill(Color.web("#0076a3"));
	    
	    
	    //read recommended protein name
    	ArrayList <String> recProtList = new ArrayList<String>();
	    FileReader recProtFile = new FileReader("C:/Users/Nidal/Programs/Eclipse_neon/GeneDatabase/recProteinFile.txt");
	    BufferedReader recProtReader = new BufferedReader(recProtFile);
	    String recProtLine = null;

	    while ((recProtLine = recProtReader.readLine()) != null) {
	    	recProtList.add(recProtLine);
	    	 }
    	
	    Label recProt = new Label("Recommended Protein Name:");
	    recProt.setTextFill(Color.web("#0076a3"));
	    
	    
    	//read sequence
    	ArrayList <String> seqList = new ArrayList<String>();
	    FileReader seqFile = new FileReader("C:/Users/Nidal/Programs/Eclipse_neon/GeneDatabase/sequenceFile.txt");
	    BufferedReader seqReader = new BufferedReader(seqFile);
	    String seqLine = null;

	    while ((seqLine = seqReader.readLine()) != null) {
	    	   seqList.add(seqLine);
	    	 }
	    
	    Label geneSeq = new Label("Sequence:");
	    geneSeq.setTextFill(Color.web("#0076a3"));
    	
	    
    	//read function - divide up function by sentence (it's currently stored as one long string)
    	ArrayList <String> funList = new ArrayList<String>();
    	ArrayList <String> splitLine = new ArrayList<String>();
    	
	    FileReader funFile = new FileReader("C:/Users/Nidal/Programs/Eclipse_neon/GeneDatabase/functionFile.txt");
	    BufferedReader funReader = new BufferedReader(funFile);
	    String funLine = null;

	    while ((funLine = funReader.readLine()) != null) {
	    		funList.add(funLine); 	
	    	 }
	    	    
	    String[] items = funList.get(0).split("\\.");
	    
	    List<String> itemList = Arrays.asList(items);
	    
	    ArrayList <String> finalFunList = new ArrayList<String>(itemList);
	
	    Label geneFun = new Label("Function:");
	    geneFun.setTextFill(Color.web("#0076a3"));
	
    	
    	//read species
    	ArrayList <String> speciesList = new ArrayList<String>();
	    FileReader speciesFile = new FileReader("C:/Users/Nidal/Programs/Eclipse_neon/GeneDatabase/speciesFile.txt");
	    BufferedReader speciesReader = new BufferedReader(speciesFile);
	    String speciesLine = null;

	    while ((speciesLine = speciesReader.readLine()) != null) {
	    	   speciesList.add(speciesLine);
	    	 }
	    
	    Label geneSpec = new Label("Species:");
	    geneSpec.setTextFill(Color.web("#0076a3"));
	    
	    
    	//read experts
    	ArrayList <String> authorsList = new ArrayList<String>();
	    FileReader authorsFile = new FileReader("C:/Users/Nidal/Programs/Eclipse_neon/GeneDatabase/expertFile.txt");
	    BufferedReader authorsReader = new BufferedReader(authorsFile);
	    String authorsLine = null;

	    while ((authorsLine = authorsReader.readLine()) != null) {
	    	   authorsList.add(authorsLine);
	    	 }
	    
	    Label geneExps = new Label("Experts:");
	    geneExps.setTextFill(Color.web("#0076a3"));
	    
	    
    	//read titles
    	ArrayList <String> titlesList = new ArrayList<String>();
	    FileReader titlesFile = new FileReader("C:/Users/Nidal/Programs/Eclipse_neon/GeneDatabase/titleFile.txt");
	    BufferedReader titlesReader = new BufferedReader(titlesFile);
	    String titlesLine = null;

	    while ((titlesLine = titlesReader.readLine()) != null) {
	    	   titlesList.add(titlesLine);
	    	 }
	    
	    Label genePaps = new Label("Papers:");
	    genePaps.setTextFill(Color.web("#0076a3"));
	    
	    
    	//read disease
    	ArrayList <String> diseaseList = new ArrayList<String>();
	    FileReader diseaseFile = new FileReader("C:/Users/Nidal/Programs/Eclipse_neon/GeneDatabase/diseaseFile.txt");
	    BufferedReader diseaseReader = new BufferedReader(diseaseFile);
	    String diseaseLine = null;
	    
	    Label geneDis = new Label("Disease Associated With:");
	    geneDis.setTextFill(Color.web("#0076a3"));

	    while ((diseaseLine = diseaseReader.readLine()) != null) {
	    	   diseaseList.add(diseaseLine);
	    	 }
	    
	    
    	//read length
    	ArrayList <String> lengthList = new ArrayList<String>();
	    FileReader lengthFile = new FileReader("C:/Users/Nidal/Programs/Eclipse_neon/GeneDatabase/lengthFile.txt");
	    BufferedReader lengthReader = new BufferedReader(lengthFile);
	    String lengthLine = null;

	    while ((lengthLine = lengthReader.readLine()) != null) {
	    	   lengthList.add(lengthLine);
	    	 }
	    
	    Label geneLen = new Label("Variation Lengths:");
	    geneLen.setTextFill(Color.web("#0076a3"));
	    
	   
    	//read hspscore
    	ArrayList <String> hspscoreList = new ArrayList<String>();
	    FileReader hspscoreFile = new FileReader("C:/Users/Nidal/Programs/Eclipse_neon/GeneDatabase/hspscoreFile.txt");
	    BufferedReader hspscoreReader = new BufferedReader(hspscoreFile);
	    String hspscoreLine = null;

	    while ((hspscoreLine = hspscoreReader.readLine()) != null) {
	    	   hspscoreList.add(hspscoreLine);
	    	 }
	      
	    Label geneHSP = new Label("BLAST HSP Score:");
	    geneHSP.setTextFill(Color.web("#0076a3"));
	    
	  
	    
    	
    	//create results information stage
    	
    	try {
    	    StringBuilder sb = new StringBuilder();
    	    String line = br.readLine();
	      
    	    //read line and launch new stage with gene as title
        	Stage secondaryStage = new Stage();
        	secondaryStage.setTitle(line + " Information");
                    
    		BorderPane resultsPane = new BorderPane();			//main pane consisting of the other panes
    		resultsPane.setPadding(new Insets(20,20,20,20));
    	
    		
    		//scroll
    		 ScrollBar s1 = new ScrollBar();
    		 s1.setOrientation(Orientation.VERTICAL);
    		 
    		 
    		//inside the side panes
    		VBox leftPane = new VBox();
    		VBox rightPane = new VBox();
    		leftPane.setPadding(new Insets(10,10,10,10));
    		rightPane.setPadding(new Insets(10,10,10,10));
    		
    		leftPane.getChildren().add(geneName);
    		leftPane.getChildren().add(new CustomPane(tempList));
    		leftPane.getChildren().add(genProt);
    		leftPane.getChildren().add(new CustomPane(genProtList));
    		leftPane.getChildren().add(recProt);
    		leftPane.getChildren().add(new CustomPane(recProtList));
    		leftPane.getChildren().add(geneLen);
    		leftPane.getChildren().add(new CustomPane(lengthList));
    		leftPane.getChildren().add(geneFun);
    		leftPane.getChildren().add(new CustomPane(finalFunList));
    		leftPane.getChildren().add(geneSeq);
    		leftPane.getChildren().add(new CustomPane(seqList));
    		
    		rightPane.getChildren().add(geneDis);
    		rightPane.getChildren().add(new CustomPane(diseaseList));
    		rightPane.getChildren().add(geneSpec);
    		rightPane.getChildren().add(new CustomPane(speciesList));
    		//rightPane.getChildren().add(geneHSP);
    		//rightPane.getChildren().add(new CustomPane(hspscoreList));
    		rightPane.getChildren().add(genePaps);
    		rightPane.getChildren().add(new CustomPane(titlesList));
    		rightPane.getChildren().add(geneExps);
    		rightPane.getChildren().add(new CustomPane(authorsList));
    		
    		
    		// side panes
    		resultsPane.setCenter(leftPane);
    		resultsPane.setRight(rightPane);
    		resultsPane.setLeft(s1);
    	
    		
    		//main stage
    		Scene resultsScene = new Scene(resultsPane);
    		secondaryStage.setScene(resultsScene);
    		secondaryStage.setHeight(800);
    		secondaryStage.setWidth(1300);
    		secondaryStage.show();
    		
    		//split up string
    	    while (line != null) {
    	        sb.append(line);
    	        sb.append(System.lineSeparator());
    	        line = br.readLine();
    	    }
    	    String everything = sb.toString();
    		} 
    	
    		finally {
    			br.close();
    		}
    	
    	
    	
    	
    	
    }
}
