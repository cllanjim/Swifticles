<?php

$con = mysql_connect("unionbeer.db.6143131.hostedresource.com", "unionbeer", "Union1234!");
if($con)
{
	mysql_select_db('unionbeer');

	$id = $_GET['id'];
	$rid = $_GET['rid'];
	$so = $_GET[‘so’];
	$name = $_GET[‘name’];
	$desc = $_GET[‘descr’];

    	if($id != null)
    	{
            $result = mysql_query("NSERT INTO menu_item_category(id,rest_id,sort_order,name,description)VALUES ('$id', '$rid', '$so’, '$name’, '$description');");


        
    	}
	mysql_close($con);
}
?> 