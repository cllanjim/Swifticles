<?php
$con = mysql_connect("hypernova.db.6143131.hostedresource.com", "hypernova", "Hyp3r#N0va");
print('1');
if($con)
{
    
    $url = 'www.testburger.com';
    
	print('2');
	mysql_select_db('hypernova');
	print('3');
    $result = mysql_query("INSERT INTO images (imageURL, width, height) VALUES ('www.yahoo.com', '200', '300');");
	print($result);
    
    $lastID = mysql_insert_id();
    
    $output = array('imageURL' => $url, 'id' => $lastID);
    echo json_encode($output);
    
    
    //printf("Last inserted record has id %d\n", mysql_insert_id());
    
	mysql_close($con);
}
?> 
