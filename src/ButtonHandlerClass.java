import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

public class ButtonHandlerClass implements EventHandler<ActionEvent> {

	ComboBox <String> comboBox; //what user selects in drop down
	TextField textField; //what user types in for the query
	static String userInput;
	
	
	public ButtonHandlerClass(ComboBox<String> comboBox, TextField textField) throws IOException {
		this.comboBox = comboBox;
		this.textField = textField;
		
	}

	@Override
	public void handle(ActionEvent event) {		//when button is pressed, this method is performed 
		
		String selectedItem = comboBox.getSelectionModel().getSelectedItem();
		userInput = textField.getText();
	    BufferedWriter writer = null;
	    

	    
	    //user query section...if user enters a disease, the main gene associated with that disease will be stored.  If the user enters a gene, then that gene will be stored
	    String tempGene;
	    
	    if (userInput.equalsIgnoreCase("cervical adenocarcinoma")) {
	    	tempGene = "BRCA1";
	    }
	    else if (userInput.equalsIgnoreCase("hepatocellular carcinoma")) {
	    	tempGene = "AARS";
	    }
	    else {
	    	tempGene = userInput;
	    }
	    
	    
	    //writing the gene to the temporary text file
	    try {
	         //create a temporary file
	         File logFile = new File("temp.txt");

	         // This will output the full path where the file will be written to...

	         writer = new BufferedWriter(new FileWriter(logFile));
	         writer.write(tempGene);
	     } catch (Exception ex) {
	         ex.printStackTrace();
	     
	     } finally {
	         try {
	             // Close the writer regardless of what happens...
	             writer.close();
	         } catch (Exception ex) {
	         }
	     }	
		
	    
	    
	    //loading stage

	    StackPane loadingPane = new StackPane();
	    loadingPane.getChildren().add(new Button("Ok"));
	    Scene loadingScene = new Scene(loadingPane, 300, 10);
	    
	    
	    Stage loadingStage = new Stage();
	    loadingStage.setTitle("Loading...Please Wait...");
	    loadingStage.setScene(loadingScene);
    	loadingStage.show();
		
	    
	    //run Perl scripts
		try {
			Process uniprotScript = Runtime.getRuntime().exec("perl C:\\Users\\Nidal\\Programs\\Eclipse_neon\\GeneDatabase\\E1UniProtExtraction.pl");
			Process ensembleScript = Runtime.getRuntime().exec("perl C:\\Users\\Nidal\\Programs\\Eclipse_neon\\GeneDatabase\\E2EnsembleExtraction.pl");
			Process rcsbScript = Runtime.getRuntime().exec("perl C:\\Users\\Nidal\\Programs\\Eclipse_neon\\GeneDatabase\\E4RCSBExtraction.pl");
			Process encodeScript = Runtime.getRuntime().exec("perl C:\\Users\\Nidal\\Programs\\Eclipse_neon\\GeneDatabase\\E5EncodeExtraction.pl");
			Process genbankScript = Runtime.getRuntime().exec("perl C:\\Users\\Nidal\\Programs\\Eclipse_neon\\GeneDatabase\\E6GenBankExtraction.pl");
			Process blastScript = Runtime.getRuntime().exec("perl C:\\Users\\Nidal\\Programs\\Eclipse_neon\\GeneDatabase\\E3BlastExtraction.pl");

			blastScript.waitFor();	//times out
			loadingStage.close();	//loading stage closed when results are ready to be displayed
			new NewStage();
		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
		}
		



		
		
	}

}
