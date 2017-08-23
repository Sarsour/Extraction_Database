import java.io.File;
import java.io.IOException;
import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;






public class Main extends Application {
    
    public static void main(String[] args) throws IOException {
    	
    	//create database then launch user interface.  When user interface is closed, the temp files will be deleted.
    	Process databaseCreationScript = Runtime.getRuntime().exec("perl C:\\Users\\Nidal\\Programs\\Eclipse_neon\\GeneDatabase\\DatabaseCreation.pl");
    	Application.launch(args);
    	Process tempFileDeletion = Runtime.getRuntime().exec("perl C:\\Users\\Nidal\\Programs\\Eclipse_neon\\GeneDatabase\\DeleteTempFiles.pl");
		
    }
    
    //primary stage method
    public void start(Stage primaryStage) throws IOException {
        
		FlowPane mainPane = new FlowPane();			//main pane consisting of the other 2 panes
		
		
		FlowPane query = new FlowPane();			//first pane = Gene/Disease drop down menu
		query.setPadding(new Insets(30,30,30,30));
		query.setHgap(10);
		query.setVgap(20);
		
		ComboBox<String> queryDropDown = new ComboBox<>();		//combo box configuration
		queryDropDown.getItems().addAll("Gene", "Disease");
		queryDropDown.setValue("Select One");
		System.out.println(queryDropDown.getValue());
		
		
		query.getChildren().addAll(new Label("Select Category: "), queryDropDown);
		
		
		FlowPane userInput = new FlowPane();			//second pane = user input
		userInput.setPadding(new Insets(30,30,30,30));
		userInput.setHgap(10);
		userInput.setVgap(20);
		
		TextField searchField = new TextField();	
		searchField.setPrefColumnCount(3);
		userInput.getChildren().addAll(new Label("Enter Query: "), searchField);
		
		
		
		
		FlowPane searchButtonPane = new FlowPane();			//third pane = Search Button
		
		searchButtonPane.setPadding(new Insets(30,30,30,200));
		searchButtonPane.setHgap(50);
		searchButtonPane.setVgap(50);
		Button searchButton = new Button("Search");
		
		searchButtonPane.getChildren().addAll(searchButton);
		
		
		//adding subpanes to main pane
		mainPane.getChildren().addAll(query, userInput, searchButtonPane);		
	
		//adding pane to scene
		Scene mainScene = new Scene(mainPane, 300, 250);

		
		
		//button actions
		
		ButtonHandlerClass handler1 = new ButtonHandlerClass(queryDropDown, searchField);		//pressing button and performing an action
		searchButton.setOnAction(handler1);

		

		//add to stage
		
		primaryStage.setTitle("Genetic Database");
		primaryStage.setScene(mainScene);
		primaryStage.show();
    }
}