<?php

$con = mysql_connect("unionbeer.db.6143131.hostedresource.com", "unionbeer", "Union1234!");
if($con)
{
	mysql_select_db('unionbeer');
    
	$restuarant_id = $_GET['rid'];
    $result = mysql_query("SELECT b.name, b.id, b.imageURLTap from (SELECT beer_id as bid FROM restaurant_beer r_b where r_b.restaurant_id = '$restuarant_id') as rb_beers left join beer b on b.id = rb_beers.bid;");
    
    /*
    while($data = mysql_fetch_array($result))
    {
        $output[] = $data;
    }
    echo json_encode($output);
    */
    
    
    $results = array();
    
    while($row = mysql_fetch_array($result))
    {
        $results[] = array('name' => $row['name'],
                           'id' => $row['id'],
                           'imageURLTap' => $row['imageURLTap']);
        
    }
    
    
    
    
    
    
    echo json_encode($results);
    
    
	//echo "</result>";
    

	mysql_close($con);
}
?> 