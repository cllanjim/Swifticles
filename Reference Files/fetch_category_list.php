<?php

$con = mysql_connect("unionbeer.db.6143131.hostedresource.com", "unionbeer", "Union1234!");
if($con)
{
	mysql_select_db('unionbeer');
    
	$restuarant_id = $_GET['rid'];

    $result = mysql_query("SELECT id, name, description from menu_item_category;");
    
    $results = array();
    
    while($row = mysql_fetch_array($result))
    {
        $results[] = array('id' => $row['id'],
                           'name' => $row['name'],
                           'description' => $row['description']);
        
    }
    
    echo json_encode($results);
    
    mysql_close($con);
}
?> 