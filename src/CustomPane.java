import java.util.ArrayList;
import javafx.geometry.Insets;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;

public class CustomPane extends StackPane {		//subclass to create extra panes quickly for all parts of the results stage

	public CustomPane(ArrayList<String> list) {
		
		int listSize = list.size();
		
		VBox listPane = new VBox();
		listPane.setPadding(new Insets(10,10,10,10));
		
		for (int i = 0; i < list.size(); i++) {	
			
		listPane.getChildren().add(new Label(list.get(i)));
		
		}
		
		setPadding(new Insets(5, 5, 5, 5));
		getChildren().add(listPane);
	
	}

}