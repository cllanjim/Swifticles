<?php

$con = mysql_connect("unionbeer.db.6143131.hostedresource.com", "unionbeer", "Union1234!");
if($con)
{
	mysql_select_db('unionbeer');
	
    $restuarant_id = $_GET['rid'];
    $category_id = $_GET['cid'];
    
    //$category_id = $_GET[‘cid'];
    
    //$category_id = -1;
    
    //if(($category_id == null) || ($category_id <= 0))
    
    
    if($restuarant_id != null)
    {
        if($category_id != null)
        {
            $result = mysql_query("SELECT id, cat_id, rest_id, name, description, price_1, price_label_1, price_2, price_label_2, price_3, price_label_3 from menu_item where cat_id = '$category_id' and rest_id = '$restuarant_id';");
        }
        else
        {
            $result = mysql_query("SELECT id, cat_id, rest_id, name, description, price_1, price_label_1, price_2, price_label_2, price_3, price_label_3 from menu_item where rest_id = '$restuarant_id';");
        }
        
    }
    else
    {
    
        if($category_id != null)
        {
            $result = mysql_query("SELECT id, cat_id, name, description, price_1, price_label_1, price_2, price_label_2, price_3, price_label_3 from menu_item where cat_id = '$category_id';");
        }
        else
        {
            $result = mysql_query("SELECT id, cat_id, name, description, price_1, price_label_1, price_2, price_label_2, price_3, price_label_3 from menu_item;");
        }
    }
    
    $results = array();
    
    while($row = mysql_fetch_array($result))
    {
        
        $results[] = array('name' => $row['name'],
                           'id' => $row['id'],
                           'cat_id' => $row['cat_id'],
                           'price_1' => $row['price_1'],
                           'price_label_1' => $row['price_label_1'],
                           'price_2' => $row['price_2'],
                           'price_label_2' => $row['price_label_2'],
                           'price_3' => $row['price_3'],
                           'price_label_3' => $row['price_label_3'],
                           'description' => $row['description']
                           );
        
        
        //$results[] = array('name' => $row['name'],
        //                   'id' => $row['id'],
        //                   'cat_id' => $row['cat_id'],
        //                   'price’ => $row['price'],
        //                   'description' => $row['description']
        //                   );
    }
    
    echo json_encode($results);
    
	mysql_close($con);
}
?> 